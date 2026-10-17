/*
 * This file is part of the AzerothCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "PathGenerator.h"
#include "Creature.h"
#include "DetourCommon.h"
#include "DynamicTree.h"
#include "GameObjectModel.h"
#include "Geometry.h"
#include "Log.h"
#include "MMapMgr.h"
#include "Map.h"
#include "Metric.h"
#include "Player.h"
#include "World.h"
#include "WorldSession.h"
#include <algorithm>
#include <cmath>

// Blades Edge Arena Ropes normalization
namespace
{
    constexpr float BLADE_EDGE_ROPE_SNAP_DIST = 1.5f;
    constexpr float BLADE_EDGE_ROPE_SNAP_DIST2 = BLADE_EDGE_ROPE_SNAP_DIST * BLADE_EDGE_ROPE_SNAP_DIST;

    struct BladeEdgeArenaRope
    {
        G3D::Vector3 Start;
        G3D::Vector3 End;
        float Sag;
    };

    static const std::array<BladeEdgeArenaRope, 2> BladeEdgeArenaRopes =
    {{
        {
            {6243.1523f, 267.53094f, 10.929295f},
            {6245.9717f, 271.29346f, 10.879172f},
            0.43f
        },
        {
            {6234.3213f, 256.29733f, 11.002348f},
            {6231.3247f, 252.58781f, 10.976968f},
            0.46f
        }
    }};

    bool IsOutsideExpandedXYBounds(G3D::Vector3 const& point, BladeEdgeArenaRope const& rope)
    {
        float const minX = std::min(rope.Start.x, rope.End.x) - BLADE_EDGE_ROPE_SNAP_DIST;
        float const maxX = std::max(rope.Start.x, rope.End.x) + BLADE_EDGE_ROPE_SNAP_DIST;
        float const minY = std::min(rope.Start.y, rope.End.y) - BLADE_EDGE_ROPE_SNAP_DIST;
        float const maxY = std::max(rope.Start.y, rope.End.y) + BLADE_EDGE_ROPE_SNAP_DIST;

        return point.x < minX || point.x > maxX || point.y < minY || point.y > maxY;
    }

    bool GetClosestPointOnBladeEdgeArenaRope(G3D::Vector3 const& point, BladeEdgeArenaRope const& rope, G3D::Vector3& closestPoint)
    {
        G3D::Vector3 const ropeVector = rope.End - rope.Start;

        float const ropeLength2XY = ropeVector.x * ropeVector.x + ropeVector.y * ropeVector.y;
        if (ropeLength2XY < 0.00001f)
            return false;

        G3D::Vector3 const pointVector = point - rope.Start;

        float t = (pointVector.x * ropeVector.x + pointVector.y * ropeVector.y) / ropeLength2XY;
        t = std::clamp(t, 0.0f, 1.0f);

        float const closestX = rope.Start.x + ropeVector.x * t;
        float const closestY = rope.Start.y + ropeVector.y * t;

        float const dx = point.x - closestX;
        float const dy = point.y - closestY;

        // If the point is already too far in XY, it cannot be within the 3D snap radius.
        if (dx * dx + dy * dy >= BLADE_EDGE_ROPE_SNAP_DIST2)
            return false;

        float const linearZ = rope.Start.z + (rope.End.z - rope.Start.z) * t;
        float const sagZ = rope.Sag * std::sin(M_PI * t);

        closestPoint = { closestX, closestY, linearZ - sagZ };
        return true;
    }

    bool TrySnapToBladeEdgeArenaRope(G3D::Vector3& point)
    {
        bool snapped = false;
        float bestDist2 = BLADE_EDGE_ROPE_SNAP_DIST2;
        G3D::Vector3 bestPoint;

        for (BladeEdgeArenaRope const& rope : BladeEdgeArenaRopes)
        {
            if (IsOutsideExpandedXYBounds(point, rope))
                continue;

            G3D::Vector3 closestPoint;
            if (!GetClosestPointOnBladeEdgeArenaRope(point, rope, closestPoint))
                continue;

            float const dist2 = (point - closestPoint).squaredLength();
            if (dist2 < bestDist2)
            {
                bestDist2 = dist2;
                bestPoint = closestPoint;
                snapped = true;
            }
        }

        if (snapped)
            point = bestPoint;

        return snapped;
    }
}

 ////////////////// PathGenerator //////////////////
PathGenerator::PathGenerator(WorldObject const* owner) :
    _polyLength(0), _type(PATHFIND_BLANK), _useStraightPath(false), _forceDestination(false),
    _slopeCheck(false), _pointPathLimit(MAX_POINT_PATH_LENGTH), _useRaycast(false),
    _endPosition(G3D::Vector3::zero()), _source(owner), _navMesh(nullptr),
    _navMeshQuery(nullptr), _lastObstacle(nullptr), _lastObstacleLeft(false)
{
    memset(_pathPolyRefs, 0, sizeof(_pathPolyRefs));

    //if (sDisableMgr->IsPathfindingEnabled(_sourceUnit->FindMap()))
    {
        _navMesh = _source->GetMap()->GetMapCollisionData().GetMMapData().GetNavMesh();
        _navMeshQuery = _source->GetMap()->GetMapCollisionData().GetMMapData().GetNavMeshQuery();
    }

    CreateFilter();
}

PathGenerator::~PathGenerator()
{
}

bool PathGenerator::CalculatePath(float destX, float destY, float destZ, bool forceDest)
{
    float x, y, z;
    _source->GetPosition(x, y, z);

    return CalculatePath(x, y, z, destX, destY, destZ, forceDest);
}

bool PathGenerator::CalculatePath(float x, float y, float z, float destX, float destY, float destZ, bool forceDest)
{
    if (!Acore::IsValidMapCoord(destX, destY, destZ) || !Acore::IsValidMapCoord(x, y, z))
        return false;

    METRIC_DETAILED_EVENT("mmap_events", "CalculatePath", "");

    G3D::Vector3 dest(destX, destY, destZ);
    SetEndPosition(dest);

    G3D::Vector3 start(x, y, z);
    SetStartPosition(start);

    _forceDestination = forceDest;

    // make sure navMesh works - we can run on map w/o mmap
    // check if the start and end point have a .mmtile loaded (can we pass via not loaded tile on the way?)
    Unit const* _sourceUnit = _source->ToUnit();
    if (!_navMesh || !_navMeshQuery || (_sourceUnit && _sourceUnit->HasUnitState(UNIT_STATE_IGNORE_PATHFINDING)) ||
        !HaveTile(start) || !HaveTile(dest))
    {
        BuildShortcut();
        _type = PathType(PATHFIND_NORMAL | PATHFIND_NOT_USING_PATH);
        return true;
    }

    UpdateFilter();

    BuildPolyPath(start, dest);
    AvoidDynamicObstacles();
    return true;
}

dtPolyRef PathGenerator::GetPathPolyByPosition(dtPolyRef const* polyPath, uint32 polyPathSize, float const* point, float* distance) const
{
    if (!polyPath || !polyPathSize)
        return INVALID_POLYREF;

    dtPolyRef nearestPoly = INVALID_POLYREF;
    float minDist = FLT_MAX;

    for (uint32 i = 0; i < polyPathSize; ++i)
    {
        float closestPoint[VERTEX_SIZE];
        if (dtStatusFailed(_navMeshQuery->closestPointOnPoly(polyPath[i], point, closestPoint, nullptr)))
            continue;

        float d = dtVdistSqr(point, closestPoint);
        if (d < minDist)
        {
            minDist = d;
            nearestPoly = polyPath[i];
        }

        if (minDist < 1.0f) // shortcut out - close enough for us
        {
            break;
        }
    }

    if (distance)
    {
        *distance = dtMathSqrtf(minDist);
    }

    return (minDist < 3.0f) ? nearestPoly : INVALID_POLYREF;
}

dtPolyRef PathGenerator::GetPolyByLocation(float const* point, float* distance) const
{
    // first we check the current path
    // if the current path doesn't contain the current poly,
    // we need to use the expensive navMesh.findNearestPoly
    dtPolyRef polyRef = GetPathPolyByPosition(_pathPolyRefs, _polyLength, point, distance);
    if (polyRef != INVALID_POLYREF)
        return polyRef;

    // we don't have it in our old path
    // try to get it by findNearestPoly()
    // first try with low search box
    float extents[VERTEX_SIZE] = { 3.0f, 5.0f, 3.0f };    // bounds of poly search area
    float closestPoint[VERTEX_SIZE] = { 0.0f, 0.0f, 0.0f };
    if (dtStatusSucceed(_navMeshQuery->findNearestPoly(point, extents, &_filter, &polyRef, closestPoint)) && polyRef != INVALID_POLYREF)
    {
        *distance = dtVdist(closestPoint, point);
        return polyRef;
    }

    // still nothing ..
    // try with bigger search box
    // Note that the extent should not overlap more than 128 polygons in the navmesh (see dtNavMeshQuery::findNearestPoly)
    extents[1] = 50.0f;

    if (dtStatusSucceed(_navMeshQuery->findNearestPoly(point, extents, &_filter, &polyRef, closestPoint)) && polyRef != INVALID_POLYREF)
    {
        *distance = dtVdist(closestPoint, point);
        return polyRef;
    }

    *distance = FLT_MAX;
    return INVALID_POLYREF;
}

void PathGenerator::BuildPolyPath(G3D::Vector3 const& startPos, G3D::Vector3 const& endPos)
{
    // *** getting start/end poly logic ***

    float distToStartPoly, distToEndPoly;
    float startPoint[VERTEX_SIZE] = { startPos.y, startPos.z, startPos.x };
    float endPoint[VERTEX_SIZE] = { endPos.y, endPos.z, endPos.x };

    dtPolyRef startPoly = GetPolyByLocation(startPoint, &distToStartPoly);
    dtPolyRef endPoly = GetPolyByLocation(endPoint, &distToEndPoly);

    _type = PathType(PATHFIND_NORMAL);

    Creature const* creature = _source->ToCreature();

    // we have a hole in our mesh
    // make shortcut path and mark it as NOPATH ( with flying and swimming exception )
    // its up to caller how he will use this info
    if (startPoly == INVALID_POLYREF || endPoly == INVALID_POLYREF)
    {
        BuildShortcut();

        bool canSwim = creature ? creature->CanSwim() : true;
        bool path = creature ? creature->CanFly() : true;
        bool waterPath = IsWaterPath(_pathPoints);
        if (path || (waterPath && canSwim))
        {
            _type = PathType(PATHFIND_NORMAL | PATHFIND_NOT_USING_PATH);
            return;
        }

        // raycast doesn't need endPoly to be valid
        if (!_useRaycast)
        {
            _type = PATHFIND_NOPATH;
            return;
        }
    }

    // we may need a better number here
    bool startFarFromPoly = distToStartPoly > 7.0f;
    bool endFarFromPoly = distToEndPoly > 7.0f;

    // create a shortcut if the path begins or end too far
    // away from the desired path points.
    // swimming creatures should not use a shortcut
    // because exiting the water must be done following a proper path
    // we just need to remove/normalize paths between 2 adjacent points
    if (startFarFromPoly || endFarFromPoly)
    {
        bool buildShortcut = false;

        auto liquidDataStart = _source->GetMap()->GetLiquidData(_source->GetPhaseMask(), startPos.x, startPos.y, startPos.z, _source->GetCollisionHeight(), {});
        auto liquidDataEnd = _source->GetMap()->GetLiquidData(_source->GetPhaseMask(), endPos.x, endPos.y, endPos.z, _source->GetCollisionHeight(), {});

        bool startUnderWaterEndInWater = liquidDataStart.Status == LIQUID_MAP_UNDER_WATER &&
                                         (liquidDataEnd.Status & MAP_LIQUID_STATUS_IN_CONTACT) != 0;
        bool startInWaterEndUnderWater = (liquidDataStart.Status & MAP_LIQUID_STATUS_IN_CONTACT) != 0 &&
                                         liquidDataEnd.Status == LIQUID_MAP_UNDER_WATER;
        bool waterPath = startUnderWaterEndInWater || startInWaterEndUnderWater;
        Unit const* _sourceUnit = _source->ToUnit();

        if (_sourceUnit)
        {
            bool isWater = (_sourceUnit->CanSwim() && waterPath);

            if (isWater || _sourceUnit->CanFly() || (_sourceUnit->IsFalling() && endPos.z < startPos.z))
            {
                buildShortcut = true;
            }
        }

        if (buildShortcut)
        {
            BuildShortcut();
            _type = PathType(PATHFIND_NORMAL | PATHFIND_NOT_USING_PATH);

            AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);

            return;
        }
        else
        {
            float closestPoint[VERTEX_SIZE];
            // we may want to use closestPointOnPolyBoundary instead
            if (dtStatusSucceed(_navMeshQuery->closestPointOnPoly(endPoly, endPoint, closestPoint, nullptr)))
            {
                dtVcopy(endPoint, closestPoint);
                SetActualEndPosition(G3D::Vector3(endPoint[2], endPoint[0], endPoint[1]));
            }

            _type = PathType(PATHFIND_INCOMPLETE);

            AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);
        }
    }

    // *** poly path generating logic ***

    // start and end are on same polygon
    // handle this case as if they were 2 different polygons, building a line path split in some few points
    if (startPoly == endPoly && !_useRaycast)
    {
        _pathPolyRefs[0] = startPoly;
        _polyLength = 1;

        if (startFarFromPoly || endFarFromPoly)
        {
            _type = PathType(PATHFIND_INCOMPLETE);

            AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);
        }
        else
            _type = PATHFIND_NORMAL;

        BuildPointPath(startPoint, endPoint);
        return;
    }

    // look for startPoly/endPoly in current path
    /// @todo we can merge it with getPathPolyByPosition() loop
    bool startPolyFound = false;
    bool endPolyFound = false;
    uint32 pathStartIndex = 0;
    uint32 pathEndIndex = 0;

    if (_polyLength)
    {
        for (; pathStartIndex < _polyLength; ++pathStartIndex)
        {
            // here to catch few bugs
            if (_pathPolyRefs[pathStartIndex] == INVALID_POLYREF)
            {
                break;
            }

            if (_pathPolyRefs[pathStartIndex] == startPoly)
            {
                startPolyFound = true;
                break;
            }
        }

        for (pathEndIndex = _polyLength - 1; pathEndIndex > pathStartIndex; --pathEndIndex)
        {
            if (_pathPolyRefs[pathEndIndex] == endPoly)
            {
                endPolyFound = true;
                break;
            }
        }
    }

    if (startPolyFound && endPolyFound)
    {
        // we moved along the path and the target did not move out of our old poly-path
        // our path is a simple subpath case, we have all the data we need
        // just "cut" it out

        _polyLength = pathEndIndex - pathStartIndex + 1;
        memmove(_pathPolyRefs, _pathPolyRefs + pathStartIndex, _polyLength * sizeof(dtPolyRef));
    }
    else if (startPolyFound && !endPolyFound)
    {
        // we are moving on the old path but target moved out
        // so we have atleast part of poly-path ready

        _polyLength -= pathStartIndex;

        // try to adjust the suffix of the path instead of recalculating entire length
        // at given interval the target cannot get too far from its last location
        // thus we have less poly to cover
        // sub-path of optimal path is optimal

    // take ~80% of the original length
        /// @todo play with the values here
        uint32 prefixPolyLength = uint32(_polyLength * 0.8f + 0.5f);
        memmove(_pathPolyRefs, _pathPolyRefs + pathStartIndex, prefixPolyLength * sizeof(dtPolyRef));

        dtPolyRef suffixStartPoly = _pathPolyRefs[prefixPolyLength - 1];

        // we need any point on our suffix start poly to generate poly-path, so we need last poly in prefix data
        float suffixEndPoint[VERTEX_SIZE];
        if (dtStatusFailed(_navMeshQuery->closestPointOnPoly(suffixStartPoly, endPoint, suffixEndPoint, nullptr)))
        {
            // we can hit offmesh connection as last poly - closestPointOnPoly() don't like that
            // try to recover by using prev polyref
            --prefixPolyLength;
            suffixStartPoly = _pathPolyRefs[prefixPolyLength - 1];
            if (dtStatusFailed(_navMeshQuery->closestPointOnPoly(suffixStartPoly, endPoint, suffixEndPoint, nullptr)))
            {
                // suffixStartPoly is still invalid, error state
                BuildShortcut();
                _type = PATHFIND_NOPATH;
                return;
            }
        }

        // generate suffix
        uint32 suffixPolyLength = 0;

        dtStatus dtResult;
        if (_useRaycast)
        {
            BuildShortcut();
            _type = PATHFIND_NOPATH;
            return;
        }
        else
        {
            dtResult = _navMeshQuery->findPath(
                suffixStartPoly,    // start polygon
                endPoly,            // end polygon
                suffixEndPoint,     // start position
                endPoint,           // end position
                &_filter,            // polygon search filter
                _pathPolyRefs + prefixPolyLength - 1,    // [out] path
                (int*)&suffixPolyLength,
                MAX_PATH_LENGTH - prefixPolyLength); // max number of polygons in output path
        }

        if (!suffixPolyLength || dtStatusFailed(dtResult))
        {
            // this is probably an error state, but we'll leave it
            // and hopefully recover on the next Update
            // we still need to copy our preffix
            LOG_ERROR("movement", "PathGenerator::BuildPolyPath: Path Build failed {}", _source->GetGUID().ToString());
        }

        // new path = prefix + suffix - overlap
        _polyLength = prefixPolyLength + suffixPolyLength - 1;
    }
    else
    {
        // either we have no path at all -> first run
        // or something went really wrong -> we aren't moving along the path to the target
        // just generate new path

        // free and invalidate old path data
        Clear();

        dtStatus dtResult;
        if (_useRaycast)
        {
            float hit = 0;
            float hitNormal[3];
            memset(hitNormal, 0, sizeof(hitNormal));

            dtResult = _navMeshQuery->raycast(
                startPoly,
                startPoint,
                endPoint,
                &_filter,
                &hit,
                hitNormal,
                _pathPolyRefs,
                (int*)&_polyLength,
                MAX_PATH_LENGTH);

            if (!_polyLength || dtStatusFailed(dtResult))
            {
                BuildShortcut();
                _type = PATHFIND_NOPATH;
                AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);
                return;
            }

            // raycast() sets hit to FLT_MAX if there is a ray between start and end
            if (hit != FLT_MAX)
            {
                float hitPos[3];

                // Walk back a bit from the hit point to make sure it's in the mesh (sometimes the point is actually outside of the polygons due to float precision issues)
                hit *= 0.99f;
                dtVlerp(hitPos, startPoint, endPoint, hit);

                // if it fails again, clamp to poly boundary
                if (dtStatusFailed(_navMeshQuery->getPolyHeight(_pathPolyRefs[_polyLength - 1], hitPos, &hitPos[1])))
                    _navMeshQuery->closestPointOnPolyBoundary(_pathPolyRefs[_polyLength - 1], hitPos, hitPos);

                _pathPoints.resize(2);
                _pathPoints[0] = GetStartPosition();
                _pathPoints[1] = G3D::Vector3(hitPos[2], hitPos[0], hitPos[1]);

                NormalizePath();
                _type = PATHFIND_INCOMPLETE;
                AddFarFromPolyFlags(startFarFromPoly, false);
                return;
            }
            else
            {
                // clamp to poly boundary if we fail to get the height
                if (dtStatusFailed(_navMeshQuery->getPolyHeight(_pathPolyRefs[_polyLength - 1], endPoint, &endPoint[1])))
                    _navMeshQuery->closestPointOnPolyBoundary(_pathPolyRefs[_polyLength - 1], endPoint, endPoint);

                _pathPoints.resize(2);
                _pathPoints[0] = GetStartPosition();
                _pathPoints[1] = G3D::Vector3(endPoint[2], endPoint[0], endPoint[1]);

                NormalizePath();
                if (startFarFromPoly || endFarFromPoly)
                {
                    _type = PathType(PATHFIND_INCOMPLETE);

                    AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);
                }
                else
                    _type = PATHFIND_NORMAL;
                return;
            }
        }
        else
        {
            dtResult = _navMeshQuery->findPath(
                startPoly,          // start polygon
                endPoly,            // end polygon
                startPoint,         // start position
                endPoint,           // end position
                &_filter,           // polygon search filter
                _pathPolyRefs,     // [out] path
                (int*)&_polyLength,
                MAX_PATH_LENGTH);   // max number of polygons in output path
        }

        if (!_polyLength || dtStatusFailed(dtResult))
        {
            // only happens if we passed bad data to findPath(), or navmesh is messed up
            LOG_ERROR("movement", "PathGenerator::BuildPolyPath: {} Path Build failed: 0 length path", _source->GetGUID().ToString());
            BuildShortcut();
            _type = PATHFIND_NOPATH;
            return;
        }
    }

    if (!_polyLength)
    {
        LOG_ERROR("movement", "PathGenerator::BuildPolyPath: {} Path Build failed: 0 length path", _source->GetGUID().ToString());
        BuildShortcut();
        _type = PATHFIND_NOPATH;
        return;
    }

    // by now we know what type of path we can get
    if (_pathPolyRefs[_polyLength - 1] == endPoly && !(_type & PATHFIND_INCOMPLETE))
    {
        _type = PATHFIND_NORMAL;
    }
    else
    {
        _type = PATHFIND_INCOMPLETE;
    }

    AddFarFromPolyFlags(startFarFromPoly, endFarFromPoly);

    // generate the point-path out of our up-to-date poly-path
    BuildPointPath(startPoint, endPoint);
}

void PathGenerator::BuildPointPath(float const* startPoint, float const* endPoint)
{
    float pathPoints[MAX_POINT_PATH_LENGTH * VERTEX_SIZE];
    uint32 pointCount = 0;
    dtStatus dtResult = DT_FAILURE;
    if (_useRaycast)
    {
        // _straightLine uses raycast and it currently doesn't support building a point path, only a 2-point path with start and hitpoint/end is returned
        LOG_ERROR("movement", "PathGenerator::BuildPointPath() called with _useRaycast for unit {}", _source->GetGUID().ToString());
        BuildShortcut();
        _type = PATHFIND_NOPATH;
        return;
    }
    else if (_useStraightPath)
    {
        dtResult = _navMeshQuery->findStraightPath(
            startPoint,         // start position
            endPoint,           // end position
            _pathPolyRefs,     // current path
            _polyLength,       // lenth of current path
            pathPoints,         // [out] path corner points
            nullptr,               // [out] flags
            nullptr,               // [out] shortened path
            (int*)&pointCount,
            _pointPathLimit);   // maximum number of points/polygons to use
    }
    else
    {
        dtResult = FindSmoothPath(
            startPoint,         // start position
            endPoint,           // end position
            _pathPolyRefs,     // current path
            _polyLength,       // length of current path
            pathPoints,         // [out] path corner points
            (int*)&pointCount,
            _pointPathLimit);    // maximum number of points
    }

    // Special case with start and end positions very close to each other
    if (_polyLength == 1 && pointCount == 1 && !(dtResult & DT_SLOPE_TOO_STEEP))
    {
        // First point is start position, append end position
        dtVcopy(&pathPoints[1 * VERTEX_SIZE], endPoint);
        pointCount++;
    }
    else if (pointCount < 2 || dtStatusFailed(dtResult))
    {
        // If its too steep, just return incomplete path.
        if (pointCount > 0 && dtResult & DT_SLOPE_TOO_STEEP)
        {
            _pathPoints.resize(pointCount);
            for (uint32 i = 0; i < pointCount; ++i)
                _pathPoints[i] = G3D::Vector3(pathPoints[i * VERTEX_SIZE + 2], pathPoints[i * VERTEX_SIZE], pathPoints[i * VERTEX_SIZE + 1]);

            NormalizePath();

            // first point is always our current location - we need the next one
            SetActualEndPosition(_pathPoints[pointCount - 1]);

            _type = PathType(_type | PATHFIND_INCOMPLETE);
            return;
        }

        // only happens if pass bad data to findStraightPath or navmesh is broken
        // single point paths can be generated here
        /// @todo check the exact cases
        BuildShortcut();
        _type = PathType(_type | PATHFIND_NOPATH);
        return;
    }
    else if (pointCount >= _pointPathLimit)
    {
        BuildShortcut();
        _type = PathType(_type | PATHFIND_SHORT);
        return;
    }

    _pathPoints.resize(pointCount);
    for (uint32 i = 0; i < pointCount; ++i)
        _pathPoints[i] = G3D::Vector3(pathPoints[i * VERTEX_SIZE + 2], pathPoints[i * VERTEX_SIZE], pathPoints[i * VERTEX_SIZE + 1]);

    NormalizePath();

    // first point is always our current location - we need the next one
    SetActualEndPosition(_pathPoints[pointCount - 1]);

    // force the given destination, if needed
    if (_forceDestination &&
        (!(_type & PATHFIND_NORMAL) || !InRange(GetEndPosition(), GetActualEndPosition(), 1.0f, 1.0f)))
    {
        // we may want to keep partial subpath
        if (Dist3DSqr(GetActualEndPosition(), GetEndPosition()) < 0.3f * Dist3DSqr(GetStartPosition(), GetEndPosition()))
        {
            SetActualEndPosition(GetEndPosition());
            _pathPoints[_pathPoints.size() - 1] = GetEndPosition();
        }
        else
        {
            SetActualEndPosition(GetEndPosition());
            BuildShortcut();
        }

        _type = PathType(PATHFIND_NORMAL | PATHFIND_NOT_USING_PATH);
    }
}

void PathGenerator::NormalizePath()
{
    bool const snapBladeEdgeArenaRopes = _source->GetMapId() == MAP_BLADES_EDGE_ARENA;
    for (G3D::Vector3& point : _pathPoints)
    {
        if (snapBladeEdgeArenaRopes && TrySnapToBladeEdgeArenaRope(point))
            continue;

        _source->UpdateAllowedPositionZ(point.x, point.y, point.z);
    }
}

void PathGenerator::BuildShortcut()
{
    Clear();

    // make two point path, our curr pos is the start, and dest is the end
    _pathPoints.resize(2);

    // set start and a default next position
    _pathPoints[0] = GetStartPosition();
    _pathPoints[1] = GetActualEndPosition();

    NormalizePath();

    _type = PATHFIND_SHORTCUT;
}

void PathGenerator::CreateFilter()
{
    uint16 includeFlags = 0;
    uint16 excludeFlags = 0;
    bool isHeadless = false;

    if (_source->IsCreature())
    {
        Creature* creature = (Creature*)_source;
        if (creature->CanWalk())
            includeFlags |= (NAV_GROUND | NAV_GROUND_STEEP);

        // creatures don't take environmental damage
        if (creature->CanEnterWater())
            includeFlags |= (NAV_WATER | NAV_MAGMA);
    }
    else // assume Player
    {
        // Bots navigate with a stricter filter: include ground + water but exclude lava/slime and
        // NAV_GROUND_STEEP (the 50-60deg slopes the extractor tags via modAlmostUnwalkableTriangles), so
        // they keep off steep mountainsides and follow gentle ground/roads. Real players are unchanged and
        // may still path across steep terrain.
        Player const* player = _source->ToPlayer();
        if (player && player->GetSession() && player->GetSession()->IsHeadless())
        {
            includeFlags |= (NAV_GROUND | NAV_WATER);
            excludeFlags |= (NAV_MAGMA | NAV_SLIME | NAV_GROUND_STEEP);
            isHeadless = true;
        }
        else
        {
            // perfect support not possible, just stay 'safe'
            includeFlags |= (NAV_GROUND | NAV_GROUND_STEEP | NAV_WATER | NAV_MAGMA);
        }
    }

    _filter.setIncludeFlags(includeFlags);
    _filter.setExcludeFlags(excludeFlags);

    // Bots bias their routes away from deep water (swim only when necessary). poly.area == poly.flags ==
    // NavTerrain, so NAV_WATER doubles as the water area index. Real players and creatures assign no cost.
    if (isHeadless)
        _filter.setAreaCost(NAV_WATER, 20.0f);

    UpdateFilter();
}

void PathGenerator::UpdateFilter()
{
    // allow creatures to cheat and use different movement types if they are moved
    // forcefully into terrain they can't normally move in
    if (Unit const* _sourceUnit = _source->ToUnit())
    {
        if (_sourceUnit->IsInWater() || _sourceUnit->IsUnderWater())
        {
            uint16 includedFlags = _filter.getIncludeFlags();
            includedFlags |= GetNavTerrain(_source->GetPositionX(),
                _source->GetPositionY(),
                _source->GetPositionZ());

            _filter.setIncludeFlags(includedFlags);
        }

        /*if (Creature const* _sourceCreature = _source->ToCreature())
            if (_sourceCreature->IsInCombat() || _sourceCreature->IsInEvadeMode())
                _filter.setIncludeFlags(_filter.getIncludeFlags() | NAV_GROUND_STEEP);*/
    }
}

NavTerrain PathGenerator::GetNavTerrain(float x, float y, float z) const
{
    LiquidData const& liquidData = _source->GetMap()->GetLiquidData(_source->GetPhaseMask(), x, y, z, _source->GetCollisionHeight(), {});
    if (liquidData.Status == LIQUID_MAP_NO_WATER)
        return NAV_GROUND;

    switch (liquidData.Flags)
    {
        case MAP_LIQUID_TYPE_WATER:
        case MAP_LIQUID_TYPE_OCEAN:
            return NAV_WATER;
        case MAP_LIQUID_TYPE_MAGMA:
        case MAP_LIQUID_TYPE_SLIME:
            return NAV_MAGMA;
        default:
            return NAV_GROUND;
    }
}

bool PathGenerator::HaveTile(G3D::Vector3 const& p) const
{
    int tx = -1, ty = -1;
    float point[VERTEX_SIZE] = { p.y, p.z, p.x };

    _navMesh->calcTileLoc(point, &tx, &ty);

    /// Workaround
    /// For some reason, often the tx and ty variables wont get a valid value
    /// Use this check to prevent getting negative tile coords and crashing on getTileAt
    if (tx < 0 || ty < 0)
        return false;

    return (_navMesh->getTileAt(tx, ty, 0) != nullptr);
}

uint32 PathGenerator::FixupCorridor(dtPolyRef* path, uint32 npath, uint32 maxPath, dtPolyRef const* visited, uint32 nvisited)
{
    int32 furthestPath = -1;
    int32 furthestVisited = -1;

    // Find furthest common polygon.
    for (int32 i = npath - 1; i >= 0; --i)
    {
        bool found = false;
        for (int32 j = nvisited - 1; j >= 0; --j)
        {
            if (path[i] == visited[j])
            {
                furthestPath = i;
                furthestVisited = j;
                found = true;
            }
        }
        if (found)
            break;
    }

    // If no intersection found just return current path.
    if (furthestPath == -1 || furthestVisited == -1)
        return npath;

    // Concatenate paths.

    // Adjust beginning of the buffer to include the visited.
    uint32 req = nvisited - furthestVisited;
    uint32 orig = uint32(furthestPath + 1) < npath ? furthestPath + 1 : npath;
    uint32 size = npath > orig ? npath - orig : 0;
    if (req + size > maxPath)
        size = maxPath - req;

    if (size)
        memmove(path + req, path + orig, size * sizeof(dtPolyRef));

    // Store visited
    for (uint32 i = 0; i < req; ++i)
        path[i] = visited[(nvisited - 1) - i];

    return req + size;
}

bool PathGenerator::GetSteerTarget(float const* startPos, float const* endPos,
    float minTargetDist, dtPolyRef const* path, uint32 pathSize,
    float* steerPos, unsigned char& steerPosFlag, dtPolyRef& steerPosRef)
{
    // Find steer target.
    static const uint32 MAX_STEER_POINTS = 3;
    float steerPath[MAX_STEER_POINTS * VERTEX_SIZE];
    unsigned char steerPathFlags[MAX_STEER_POINTS];
    dtPolyRef steerPathPolys[MAX_STEER_POINTS];
    uint32 nsteerPath = 0;
    dtStatus dtResult = _navMeshQuery->findStraightPath(startPos, endPos, path, pathSize,
        steerPath, steerPathFlags, steerPathPolys, (int*)&nsteerPath, MAX_STEER_POINTS);
    if (!nsteerPath || dtStatusFailed(dtResult))
        return false;

    // Find vertex far enough to steer to.
    uint32 ns = 0;
    while (ns < nsteerPath)
    {
        // Stop at Off-Mesh link or when point is further than slop away.
        if ((steerPathFlags[ns] & DT_STRAIGHTPATH_OFFMESH_CONNECTION) ||
            !InRangeYZX(&steerPath[ns * VERTEX_SIZE], startPos, minTargetDist, 1000.0f))
            break;

        ns++;
    }
    // Failed to find good point to steer to.
    if (ns >= nsteerPath)
        return false;

    dtVcopy(steerPos, &steerPath[ns * VERTEX_SIZE]);
    steerPos[1] = startPos[1];  // keep Z value
    steerPosFlag = steerPathFlags[ns];
    steerPosRef = steerPathPolys[ns];

    return true;
}

dtStatus PathGenerator::FindSmoothPath(float const* startPos, float const* endPos,
    dtPolyRef const* polyPath, uint32 polyPathSize,
    float* smoothPath, int* smoothPathSize, uint32 maxSmoothPathSize)
{
    *smoothPathSize = 0;
    uint32 nsmoothPath = 0;

    dtPolyRef polys[MAX_PATH_LENGTH];
    memcpy(polys, polyPath, sizeof(dtPolyRef) * polyPathSize);
    uint32 npolys = polyPathSize;

    float iterPos[VERTEX_SIZE], targetPos[VERTEX_SIZE];

    if (polyPathSize > 1)
    {
        // Pick the closest points on poly border
        if (dtStatusFailed(_navMeshQuery->closestPointOnPolyBoundary(polys[0], startPos, iterPos)))
        {
            return DT_FAILURE;
        }

        if (dtStatusFailed(_navMeshQuery->closestPointOnPolyBoundary(polys[npolys - 1], endPos, targetPos)))
        {
            return DT_FAILURE;
        }
    }
    else
    {
        // Case where the path is on the same poly
        dtVcopy(iterPos, startPos);
        dtVcopy(targetPos, endPos);
    }

    dtVcopy(&smoothPath[nsmoothPath * VERTEX_SIZE], iterPos);
    nsmoothPath++;

    // Move towards target a small advancement at a time until target reached or
    // when ran out of memory to store the path.
    while (npolys && nsmoothPath < maxSmoothPathSize)
    {
        // Find location to steer towards.
        float steerPos[VERTEX_SIZE];
        unsigned char steerPosFlag;
        dtPolyRef steerPosRef = INVALID_POLYREF;

        if (!GetSteerTarget(iterPos, targetPos, SMOOTH_PATH_SLOP, polys, npolys, steerPos, steerPosFlag, steerPosRef))
            break;

        bool endOfPath = (steerPosFlag & DT_STRAIGHTPATH_END) != 0;
        bool offMeshConnection = (steerPosFlag & DT_STRAIGHTPATH_OFFMESH_CONNECTION) != 0;

        // Find movement delta.
        float delta[VERTEX_SIZE];
        dtVsub(delta, steerPos, iterPos);
        float len = dtMathSqrtf(dtVdot(delta, delta));
        // If the steer target is end of path or off-mesh link, do not move past the location.
        if ((endOfPath || offMeshConnection) && len < SMOOTH_PATH_STEP_SIZE)
            len = 1.0f;
        else
            len = SMOOTH_PATH_STEP_SIZE / len;

        float moveTgt[VERTEX_SIZE];
        dtVmad(moveTgt, iterPos, delta, len);

        // Move
        float result[VERTEX_SIZE];
        const static uint32 MAX_VISIT_POLY = 16;
        dtPolyRef visited[MAX_VISIT_POLY];

        uint32 nvisited = 0;
        if (dtStatusFailed(_navMeshQuery->moveAlongSurface(polys[0], iterPos, moveTgt, &_filter, result, visited, (int*)&nvisited, MAX_VISIT_POLY)))
        {
            return DT_FAILURE;
        }
        npolys = FixupCorridor(polys, npolys, MAX_PATH_LENGTH, visited, nvisited);

        if (dtStatusFailed(_navMeshQuery->getPolyHeight(polys[0], result, &result[1])))
            LOG_DEBUG("maps", "PathGenerator::FindSmoothPath: Cannot find height at position X: {} Y: {} Z: {} for {}",
                result[2], result[0], result[1], _source->GetGUID().ToString());
        result[1] += 0.5f;
        dtVcopy(iterPos, result);

        bool canCheckSlope = _slopeCheck && (GetPathType() & ~(PATHFIND_NOT_USING_PATH));

        if (canCheckSlope && !IsSwimmableSegment(iterPos, steerPos) && !IsWalkableClimb(iterPos, steerPos))
        {
            nsmoothPath--;
            *smoothPathSize = nsmoothPath;
            return DT_FAILURE | DT_SLOPE_TOO_STEEP;
        }

        // Handle end of path and off-mesh links when close enough.
        if (endOfPath && InRangeYZX(iterPos, steerPos, SMOOTH_PATH_SLOP, 1.0f))
        {
            // Reached end of path.
            dtVcopy(iterPos, targetPos);
            if (nsmoothPath < maxSmoothPathSize)
            {
                dtVcopy(&smoothPath[nsmoothPath * VERTEX_SIZE], iterPos);
                nsmoothPath++;
            }
            break;
        }
        else if (offMeshConnection && InRangeYZX(iterPos, steerPos, SMOOTH_PATH_SLOP, 1.0f))
        {
            // Advance the path up to and over the off-mesh connection.
            dtPolyRef prevRef = INVALID_POLYREF;
            dtPolyRef polyRef = polys[0];
            uint32 npos = 0;
            while (npos < npolys && polyRef != steerPosRef)
            {
                prevRef = polyRef;
                polyRef = polys[npos];
                npos++;
            }

            for (uint32 i = npos; i < npolys; ++i)
                polys[i - npos] = polys[i];

            npolys -= npos;

            // Handle the connection.
            float connectionStartPos[VERTEX_SIZE], connectionEndPos[VERTEX_SIZE];
            if (dtStatusSucceed(_navMesh->getOffMeshConnectionPolyEndPoints(prevRef, polyRef, connectionStartPos, connectionEndPos)))
            {
                if (nsmoothPath < maxSmoothPathSize)
                {
                    dtVcopy(&smoothPath[nsmoothPath * VERTEX_SIZE], connectionStartPos);
                    nsmoothPath++;
                }
                // Move position at the other side of the off-mesh link.
                dtVcopy(iterPos, connectionEndPos);
                if (dtStatusFailed(_navMeshQuery->getPolyHeight(polys[0], iterPos, &iterPos[1])))
                    return DT_FAILURE;
                iterPos[1] += 0.5f;
            }
        }

        // Store results.
        if (nsmoothPath < maxSmoothPathSize)
        {
            dtVcopy(&smoothPath[nsmoothPath * VERTEX_SIZE], iterPos);
            nsmoothPath++;
        }
    }

    *smoothPathSize = nsmoothPath;

    // this is most likely a loop
    return nsmoothPath < MAX_POINT_PATH_LENGTH ? DT_SUCCESS : DT_FAILURE;
}

bool PathGenerator::IsWalkableClimb(float const* v1, float const* v2) const
{
    return IsWalkableClimb(v1[2], v1[0], v1[1], v2[2], v2[0], v2[1]);
}

bool PathGenerator::IsWalkableClimb(float x, float y, float z, float destX, float destY, float destZ) const
{
    return IsWalkableClimb(x, y, z, destX, destY, destZ, _source->GetCollisionHeight());
}

/**
 * @brief Check if a slope can be climbed based on source height
 * This method is meant for short distances or linear paths
 *
 * @param x start x coord
 * @param y start y coord
 * @param z start z coord
 * @param destX destination x coord
 * @param destY destination y coord
 * @param destZ destination z coord
 * @param sourceHeight height of the source
 * @return bool check if you can climb the path
 */
bool PathGenerator::IsWalkableClimb(float x, float y, float z, float destX, float destY, float destZ, float sourceHeight)
{
    float diffHeight = std::abs(destZ - z);
    float reqHeight = GetRequiredHeightToClimb(x, y, z, destX, destY, destZ, sourceHeight);
    // check walkable slopes, based on unit height
    return diffHeight <= reqHeight;
}

/**
 * @brief Return the height of a slope that can be climbed based on source height
 * This method is meant for short distances or linear paths
 *
 * @param x start x coord
 * @param y start y coord
 * @param z start z coord
 * @param destX destination x coord
 * @param destY destination y coord
 * @param destZ destination z coord
 * @param sourceHeight height of the source
 * @return float the maximum height that a source can climb based on slope angle
 */
float PathGenerator::GetRequiredHeightToClimb(float x, float y, float z, float destX, float destY, float destZ, float sourceHeight)
{
    float slopeAngle = getSlopeAngleAbs(x, y, z, destX, destY, destZ);
    float slopeAngleDegree = (slopeAngle * 180.0f / M_PI);
    float climbableHeight = sourceHeight - (sourceHeight * (slopeAngleDegree / 100));
    return climbableHeight;
}

bool PathGenerator::InRangeYZX(float const* v1, float const* v2, float r, float h) const
{
    const float dx = v2[0] - v1[0];
    const float dy = v2[1] - v1[1]; // elevation
    const float dz = v2[2] - v1[2];
    return (dx * dx + dz * dz) < r * r && fabsf(dy) < h;
}

bool PathGenerator::InRange(G3D::Vector3 const& p1, G3D::Vector3 const& p2, float r, float h) const
{
    G3D::Vector3 d = p1 - p2;
    return (d.x * d.x + d.y * d.y) < r * r && fabsf(d.z) < h;
}

float PathGenerator::Dist3DSqr(G3D::Vector3 const& p1, G3D::Vector3 const& p2) const
{
    return (p1 - p2).squaredLength();
}

void PathGenerator::ShortenPathUntilDist(G3D::Vector3 const& target, float dist)
{
    if (GetPathType() == PATHFIND_BLANK || _pathPoints.size() < 2)
    {
        LOG_ERROR("movement", "PathGenerator::ReducePathLengthByDist called before path was successfully built");
        return;
    }

    float const distSq = dist * dist;

    // the first point of the path must be outside the specified range
    // (this should have really been checked by the caller...)
    if ((_pathPoints[0] - target).squaredLength() < distSq)
        return;

    // check if we even need to do anything
    if ((*_pathPoints.rbegin() - target).squaredLength() >= distSq)
        return;

    std::size_t i = _pathPoints.size() - 1;
    float const collisionHeight = _source->GetCollisionHeight();
    // find the first i s.t.:
    //  - _pathPoints[i] is still too close
    //  - _pathPoints[i-1] is too far away
    // => the end point is somewhere on the line between the two
    while (1)
    {
        // we know that pathPoints[i] is too close already (from the previous iteration)
        if ((_pathPoints[i - 1] - target).squaredLength() >= distSq)
            break; // bingo!

        bool canCheckSlope = _slopeCheck && (GetPathType() & ~(PATHFIND_NOT_USING_PATH));

        // check if the shortened path is still in LoS with the target and it is walkable
        // The sight line has to run from the candidate end point to the target. It used to start
        // at the source's current hit sphere instead - wherever the mover still is, often 10-20 yd
        // back - so a single tree or rock between the mover and a point 3 yd short of the target
        // left the path uncut: melee chasers ran into their victim's centre (braked only by the
        // 400 ms chase recheck) and charges landed inside the target, mostly in forests and rough
        // ground (e.g. Timber Worgs in the Terokkar forest).
        if (!_source->GetMap()->isInLineOfSight(_pathPoints[i - 1].x, _pathPoints[i - 1].y,
            _pathPoints[i - 1].z + collisionHeight, target.x, target.y, target.z + collisionHeight,
            _source->GetPhaseMask(), LINEOFSIGHT_ALL_CHECKS, VMAP::ModelIgnoreFlags::Nothing) || (canCheckSlope &&
                !IsSwimmableSegment(_source->GetPositionX(), _source->GetPositionY(), _source->GetPositionZ(), _pathPoints[i - 1].x, _pathPoints[i - 1].y, _pathPoints[i - 1].z) &&
                !IsWalkableClimb(_source->GetPositionX(), _source->GetPositionY(), _source->GetPositionZ(), _pathPoints[i - 1].x, _pathPoints[i - 1].y, _pathPoints[i - 1].z)))
        {
            // whenver we find a point that is not valid anymore, simply use last valid path
            _pathPoints.resize(i + 1);
            return;
        }

        if (!--i)
        {
            // no point found that fulfills the condition
            _pathPoints[0] = _pathPoints[1];
            _pathPoints.resize(2);
            return;
        }
    }

    // ok, _pathPoints[i] is too close, _pathPoints[i-1] is not, so our target point is somewhere between the two...
    //   ... settle for a guesstimate since i'm not confident in doing trig on every chase motion tick...
    // (@todo review this)
    _pathPoints[i] += (_pathPoints[i - 1] - _pathPoints[i]).direction() * (dist - (_pathPoints[i] - target).length());
    _pathPoints.resize(i + 1);
}

// Walking round spawned gameobjects
namespace
{
    constexpr float OBSTACLE_RAY_HEIGHT = 0.8f;         // segments are tested this far above the ground, lower things are stepped over
    constexpr float OBSTACLE_CLEARANCE = 0.3f;          // kept between the mover's bounding radius and the object
    constexpr float OBSTACLE_CORNER_SLACK = 0.1f;       // detour corners sit this far outside the area a leg may not cross
    constexpr float OBSTACLE_MIN_RADIUS = 0.3f;
    constexpr float OBSTACLE_MAX_RADIUS = 2.0f;
    constexpr float OBSTACLE_SIDE_BIAS = 1.3f;          // the side taken last time is kept unless it got this much longer
    constexpr float OBSTACLE_MAX_FLOOR_DIFF = 3.0f;
    constexpr uint32 OBSTACLE_MAX_PER_PATH = 4;
    constexpr int OBSTACLE_MAX_LEG_POLYS = 32;

    // The footprint of a gameobject model as a rectangle that may be turned any way
    struct ObstacleRect
    {
        float cx, cy;   // centre
        float ux, uy;   // unit vector along one side, the other side runs along (-uy, ux)
        float hu, hv;   // half sizes along those two

        explicit ObstacleRect(G3D::Vector3 const* footprint)
        {
            cx = (footprint[0].x + footprint[2].x) * 0.5f;
            cy = (footprint[0].y + footprint[2].y) * 0.5f;

            float const ax = footprint[1].x - footprint[0].x;
            float const ay = footprint[1].y - footprint[0].y;
            float const bx = footprint[3].x - footprint[0].x;
            float const by = footprint[3].y - footprint[0].y;
            float const lengthA = std::sqrt(ax * ax + ay * ay);
            float const lengthB = std::sqrt(bx * bx + by * by);

            // the shorter side may have no length at all, so take the direction from the longer one
            if (lengthA >= lengthB)
            {
                ux = lengthA > 0.0f ? ax / lengthA : 1.0f;
                uy = lengthA > 0.0f ? ay / lengthA : 0.0f;
            }
            else
            {
                ux = by / lengthB;
                uy = -bx / lengthB;
            }

            hu = lengthA * 0.5f;
            hv = lengthB * 0.5f;
        }

        void ToLocal(G3D::Vector3 const& point, float& u, float& v) const
        {
            float const dx = point.x - cx;
            float const dy = point.y - cy;
            u = dx * ux + dy * uy;
            v = dy * ux - dx * uy;
        }

        [[nodiscard]] G3D::Vector3 ToWorld(float u, float v, float z) const
        {
            return G3D::Vector3(cx + u * ux - v * uy, cy + u * uy + v * ux, z);
        }

        // all three take the rectangle made 'grow' yards larger on every side

        [[nodiscard]] bool Contains(G3D::Vector3 const& point, float grow) const
        {
            float u, v;
            ToLocal(point, u, v);
            return std::fabs(u) < hu + grow && std::fabs(v) < hv + grow;
        }

        // true if the segment passes through the inside, touching the border does not count
        [[nodiscard]] bool Crosses(G3D::Vector3 const& from, G3D::Vector3 const& to, float grow) const
        {
            float start[2], end[2];
            ToLocal(from, start[0], start[1]);
            ToLocal(to, end[0], end[1]);
            float const extent[2] = { hu + grow, hv + grow };

            float tMin = 0.0f;
            float tMax = 1.0f;
            for (int axis = 0; axis < 2; ++axis)
            {
                float const delta = end[axis] - start[axis];
                if (std::fabs(delta) < 1e-5f)
                {
                    if (std::fabs(start[axis]) >= extent[axis])
                        return false;

                    continue;
                }

                float t1 = (-extent[axis] - start[axis]) / delta;
                float t2 = (extent[axis] - start[axis]) / delta;
                if (t1 > t2)
                    std::swap(t1, t2);

                tMin = std::max(tMin, t1);
                tMax = std::min(tMax, t2);
                if (tMin >= tMax)
                    return false;
            }

            return tMax - tMin > 1e-3f;
        }

        // corners 0..3 follow each other round the rectangle
        [[nodiscard]] G3D::Vector3 Corner(uint32 index, float grow, float z) const
        {
            float const u = (index == 1 || index == 2) ? hu + grow : -(hu + grow);
            float const v = (index == 2 || index == 3) ? hv + grow : -(hv + grow);
            return ToWorld(u, v, z);
        }

        // the nearest point on the border, for a point inside
        [[nodiscard]] G3D::Vector3 PushOut(G3D::Vector3 const& point, float grow) const
        {
            float u, v;
            ToLocal(point, u, v);
            float const extentU = hu + grow;
            float const extentV = hv + grow;
            if (extentU - std::fabs(u) < extentV - std::fabs(v))
                u = u < 0.0f ? -extentU : extentU;
            else
                v = v < 0.0f ? -extentV : extentV;

            return ToWorld(u, v, point.z);
        }
    };

    // A way round the rectangle over up to three corners that follow each other
    struct ObstacleRoute
    {
        uint32 count = 0;
        uint32 corners[3] = { 0, 0, 0 };
        float length = 0.0f;

        [[nodiscard]] bool SharesCorner(ObstacleRoute const& other) const
        {
            for (uint32 i = 0; i < count; ++i)
                for (uint32 j = 0; j < other.count; ++j)
                    if (corners[i] == other.corners[j])
                        return true;

            return false;
        }
    };

    float ObstacleDistance2D(G3D::Vector3 const& a, G3D::Vector3 const& b)
    {
        float const dx = a.x - b.x;
        float const dy = a.y - b.y;
        return std::sqrt(dx * dx + dy * dy);
    }
}

void PathGenerator::AvoidDynamicObstacles()
{
    // straight and raycast paths are not walked, and a raycast caller checks dynamic collision itself
    if (_useRaycast || _useStraightPath || _pathPoints.size() < 2)
        return;

    // only paths that follow the navmesh: the rest is flown, swum or a fallback already
    if (!(_type & (PATHFIND_NORMAL | PATHFIND_INCOMPLETE)) ||
        (_type & (PATHFIND_SHORTCUT | PATHFIND_NOPATH | PATHFIND_NOT_USING_PATH | PATHFIND_SHORT)))
        return;

    if (!sWorld->getBoolConfig(CONFIG_PATH_GO_OBSTACLES_ENABLE))
        return;

    Unit const* unit = _source->ToUnit();
    if (!unit || unit->IsFlying())
        return;

    if (unit->IsPlayer() && !sWorld->getBoolConfig(CONFIG_PATH_GO_OBSTACLES_PLAYERS))
        return;

    DynamicMapTree const& tree = _source->GetMap()->GetMapCollisionData().GetPathObstacleTree();
    if (!tree.size())
        return;

    float const scanDistance = sWorld->getFloatConfig(CONFIG_PATH_GO_OBSTACLES_SCAN_DISTANCE);
    float scanned = 0.0f;

    // objects the path starts or ends in, and objects no way round was found for
    std::vector<GameObjectModel const*> ignored;
    uint32 handled = 0;

    for (std::size_t i = 0; i + 1 < _pathPoints.size(); ++i)
    {
        if (scanDistance > 0.0f && scanned > scanDistance)
            break;

        scanned += ObstacleDistance2D(_pathPoints[i], _pathPoints[i + 1]);

        GameObjectModel const* obstacle = FindObstacle(tree, ignored, _pathPoints[i], _pathPoints[i + 1]);
        if (!obstacle)
            continue;

        std::size_t resumeIndex = 0;
        if (DetourAroundObstacle(tree, obstacle, i, ignored, resumeIndex))
        {
            LOG_DEBUG("movement", "PathGenerator::AvoidDynamicObstacles: {} goes round gameobject model {}",
                _source->GetGUID().ToString(), obstacle->name);

            // carry on from the point the detour rejoins the path at
            i = resumeIndex - 1;
        }
        else
            ignored.push_back(obstacle);

        if (++handled >= OBSTACLE_MAX_PER_PATH)
            break;
    }
}

GameObjectModel const* PathGenerator::FindObstacle(DynamicMapTree const& tree, std::vector<GameObjectModel const*> const& ignored,
    G3D::Vector3 const& from, G3D::Vector3 const& to) const
{
    uint32 const phaseMask = _source->GetPhaseMask();

    GameObjectModel const* obstacle = tree.GetHitModel(phaseMask,
        G3D::Vector3(from.x, from.y, from.z + OBSTACLE_RAY_HEIGHT), G3D::Vector3(to.x, to.y, to.z + OBSTACLE_RAY_HEIGHT));

    // A path point on top of a low object got that object's height, and the ray above then climbs over
    // the object's edge. Look again level with the lower end.
    if (!obstacle && std::fabs(from.z - to.z) > 0.5f)
    {
        float const z = std::min(from.z, to.z) + OBSTACLE_RAY_HEIGHT;
        obstacle = tree.GetHitModel(phaseMask, G3D::Vector3(from.x, from.y, z), G3D::Vector3(to.x, to.y, z));
    }

    if (obstacle && std::find(ignored.begin(), ignored.end(), obstacle) != ignored.end())
        return nullptr;

    return obstacle;
}

bool PathGenerator::DetourAroundObstacle(DynamicMapTree const& tree, GameObjectModel const* obstacle, std::size_t hitSegment,
    std::vector<GameObjectModel const*> const& ignored, std::size_t& resumeIndex)
{
    ObstacleRect const rect(obstacle->GetFootprint());

    // leaving the object or heading right into it (a chest being looted, a target standing on it):
    // there is nothing to walk round
    if (rect.Contains(_pathPoints.front(), 0.0f) || rect.Contains(_pathPoints.back(), 0.0f))
        return false;

    float const outer = std::clamp(_source->ToUnit()->GetBoundaryRadius(), OBSTACLE_MIN_RADIUS, OBSTACLE_MAX_RADIUS) + OBSTACLE_CLEARANCE;
    float const inner = outer - OBSTACLE_CORNER_SLACK;

    // the stretch to replace runs from the last point still clear of the object to the first one clear of it again
    std::size_t leave = hitSegment;
    while (leave > 0 && rect.Contains(_pathPoints[leave], inner))
        --leave;

    std::size_t rejoin = hitSegment + 1;
    while (rejoin + 1 < _pathPoints.size() && rect.Contains(_pathPoints[rejoin], inner))
        ++rejoin;

    // a path that starts right next to the object first steps away from it, one that ends there steps up to it last
    Movement::PointsArray head;
    head.push_back(_pathPoints[leave]);
    if (rect.Contains(head.back(), inner))
        head.push_back(rect.PushOut(head.back(), outer));

    Movement::PointsArray tail;
    if (rect.Contains(_pathPoints[rejoin], inner))
        tail.push_back(rect.PushOut(_pathPoints[rejoin], outer));
    tail.push_back(_pathPoints[rejoin]);

    G3D::Vector3 const from = head.back();
    G3D::Vector3 const to = tail.front();

    // every way over corners that follow each other, in both directions, that stays out of the object
    ObstacleRoute routes[21];
    uint32 routeCount = 0;

    auto addRoute = [&](uint32 count, uint32 first, int32 step)
    {
        ObstacleRoute route;
        route.count = count;

        G3D::Vector3 previous = from;
        for (uint32 i = 0; i < count; ++i)
        {
            route.corners[i] = uint32(int32(first) + step * int32(i) + 4) % 4;

            G3D::Vector3 const corner = rect.Corner(route.corners[i], outer, from.z);
            if (rect.Crosses(previous, corner, inner))
                return;

            route.length += ObstacleDistance2D(previous, corner);
            previous = corner;
        }

        if (rect.Crosses(previous, to, inner))
            return;

        route.length += ObstacleDistance2D(previous, to);
        routes[routeCount++] = route;
    };

    addRoute(0, 0, 1);
    for (uint32 first = 0; first < 4; ++first)
    {
        addRoute(1, first, 1);
        for (uint32 count = 2; count <= 3; ++count)
        {
            addRoute(count, first, 1);
            addRoute(count, first, -1);
        }
    }

    if (!routeCount)
        return false;

    // the shortest way, and the shortest one round the other side as a fallback
    ObstacleRoute const* best = &routes[0];
    for (uint32 i = 1; i < routeCount; ++i)
        if (routes[i].length < best->length)
            best = &routes[i];

    ObstacleRoute const* other = nullptr;
    if (best->count)
        for (uint32 i = 0; i < routeCount; ++i)
            if (routes[i].count && !routes[i].SharesCorner(*best) && (!other || routes[i].length < other->length))
                other = &routes[i];

    auto isLeft = [&](ObstacleRoute const& route)
    {
        G3D::Vector3 const corner = rect.Corner(route.corners[0], outer, from.z);
        return (to.x - from.x) * (corner.y - from.y) - (to.y - from.y) * (corner.x - from.x) > 0.0f;
    };

    if (other && _lastObstacle == obstacle && isLeft(*other) == _lastObstacleLeft && isLeft(*best) != _lastObstacleLeft &&
        other->length <= best->length * OBSTACLE_SIDE_BIAS)
        std::swap(best, other);

    ObstacleRoute const* const order[2] = { best, other };
    for (ObstacleRoute const* route : order)
    {
        if (!route)
            continue;

        Movement::PointsArray points = head;
        for (uint32 i = 0; i < route->count; ++i)
            points.push_back(rect.Corner(route->corners[i], outer, from.z));
        points.insert(points.end(), tail.begin(), tail.end());

        if (!ValidateDetour(tree, ignored, points))
            continue;

        // keep the point spacing of the rest of the path, so that the spline follows the ground on long legs
        Movement::PointsArray detour;
        for (std::size_t leg = 0; leg + 1 < points.size(); ++leg)
        {
            G3D::Vector3 const& legStart = points[leg];
            G3D::Vector3 const& legEnd = points[leg + 1];
            float const legLength = (legEnd - legStart).magnitude();

            for (float walked = SMOOTH_PATH_STEP_SIZE; walked + 1.0f < legLength; walked += SMOOTH_PATH_STEP_SIZE)
            {
                G3D::Vector3 point = legStart + (legEnd - legStart) * (walked / legLength);
                point.z += 0.5f;
                _source->UpdateAllowedPositionZ(point.x, point.y, point.z);
                detour.push_back(point);
            }

            if (leg + 2 < points.size())
                detour.push_back(legEnd);
        }

        if (_pathPoints.size() - (rejoin - leave - 1) + detour.size() > std::size_t(MAX_POINT_PATH_LENGTH))
            return false;

        _pathPoints.erase(_pathPoints.begin() + leave + 1, _pathPoints.begin() + rejoin);
        _pathPoints.insert(_pathPoints.begin() + leave + 1, detour.begin(), detour.end());
        resumeIndex = leave + 1 + detour.size();

        if (route->count)
        {
            _lastObstacle = obstacle;
            _lastObstacleLeft = isLeft(*route);
        }

        return true;
    }

    return false;
}

bool PathGenerator::ValidateDetour(DynamicMapTree const& tree, std::vector<GameObjectModel const*> const& ignored, Movement::PointsArray& route) const
{
    // every leg has to stay on the navmesh the mover is allowed on...
    float const extents[VERTEX_SIZE] = { 1.0f, 3.0f, 1.0f };
    float position[VERTEX_SIZE] = { route[0].y, route[0].z, route[0].x };
    float nearest[VERTEX_SIZE] = { 0.0f, 0.0f, 0.0f };
    dtPolyRef poly = INVALID_POLYREF;
    if (dtStatusFailed(_navMeshQuery->findNearestPoly(position, extents, &_filter, &poly, nearest)) || poly == INVALID_POLYREF)
        return false;

    if (dtVdist2DSqr(position, nearest) > 1.0f)
        return false;

    dtVcopy(position, nearest);

    for (std::size_t i = 1; i < route.size(); ++i)
    {
        bool const isLast = i + 1 == route.size();
        float end[VERTEX_SIZE] = { route[i].y, position[1], route[i].x };

        // nothing to cast over
        if (dtVdist2DSqr(position, end) < 0.01f)
        {
            if (!isLast)
                route[i].z = position[1];

            continue;
        }

        float hit = 0.0f;
        float hitNormal[VERTEX_SIZE] = { 0.0f, 0.0f, 0.0f };
        dtPolyRef visited[OBSTACLE_MAX_LEG_POLYS];
        int visitedCount = 0;
        dtStatus const status = _navMeshQuery->raycast(poly, position, end, &_filter, &hit, hitNormal, visited, &visitedCount, OBSTACLE_MAX_LEG_POLYS);

        // raycast() sets hit to FLT_MAX if the end was reached
        if (dtStatusFailed(status) || dtStatusDetail(status, DT_BUFFER_TOO_SMALL) || hit != FLT_MAX || visitedCount <= 0)
            return false;

        poly = visited[visitedCount - 1];

        float height = 0.0f;
        if (dtStatusFailed(_navMeshQuery->getPolyHeight(poly, end, &height)))
        {
            float closest[VERTEX_SIZE];
            if (dtStatusFailed(_navMeshQuery->closestPointOnPoly(poly, end, closest, nullptr)))
                return false;

            height = closest[1];
        }

        end[1] = height;

        if (isLast)
        {
            // the cast is flat and may have come out on another floor than the point it should reach
            if (std::fabs(height - route[i].z) > OBSTACLE_MAX_FLOOR_DIFF)
                return false;
        }
        else
        {
            route[i].z = height + 0.5f;
            _source->UpdateAllowedPositionZ(route[i].x, route[i].y, route[i].z);
        }

        dtVcopy(position, end);
    }

    // ...and must not run into this or another object
    for (std::size_t i = 0; i + 1 < route.size(); ++i)
        if (FindObstacle(tree, ignored, route[i], route[i + 1]))
            return false;

    return true;
}

bool PathGenerator::IsInvalidDestinationZ(Unit const* target) const
{
    return (target->GetPositionZ() - GetActualEndPosition().z) > 5.0f;
}

void PathGenerator::AddFarFromPolyFlags(bool startFarFromPoly, bool endFarFromPoly)
{
    if (startFarFromPoly)
    {
        _type = PathType(_type | PATHFIND_FARFROMPOLY_START);
    }
    if (endFarFromPoly)
    {
        _type = PathType(_type | PATHFIND_FARFROMPOLY_END);
    }
}

/**
 * @brief predict if a certain segment is underwater and the unit can swim
 * Must only be used for very short segments since this check doesn't work on
 * long paths that alternate terrain and water.
 *
 * @param v1
 * @param v2
 * @return true
 * @return false
 */
bool PathGenerator::IsSwimmableSegment(float const* v1, float const* v2, bool checkSwim) const
{
    return IsSwimmableSegment(v1[2], v1[0], v1[1], v2[2], v2[0], v2[1], checkSwim);
}

/**
 * @brief predict if a certain segment is underwater and the unit can swim
 * Must only be used for very short segments since this check doesn't work on
 * long paths that alternate terrain and water.
 *
 * @param x
 * @param y
 * @param z
 * @param destX
 * @param destY
 * @param destZ
 * @param checkSwim also check if the unit can swim
 * @return true if there's water at the end AND at the start of the segment
 * @return false if there's no water at the end OR at the start of the segment
 */
bool PathGenerator::IsSwimmableSegment(float x, float y, float z, float destX, float destY, float destZ, bool checkSwim) const
{
    Creature const* _sourceCreature = _source->ToCreature();
    return _source->GetMap()->IsInWater(_source->GetPhaseMask(), x, y, z, _source->GetCollisionHeight()) &&
        _source->GetMap()->IsInWater(_source->GetPhaseMask(), destX, destY, destZ, _source->GetCollisionHeight()) &&
        (!checkSwim || !_sourceCreature || _sourceCreature->CanSwim());
}

bool PathGenerator::IsWaterPath(Movement::PointsArray pathPoints) const
{
    bool waterPath = true;
    // Check both start and end points, if they're both in water, then we can *safely* let the creature move
    for (uint32 i = 0; i < pathPoints.size(); ++i)
    {
        NavTerrain terrain = GetNavTerrain(pathPoints[i].x, pathPoints[i].y, pathPoints[i].z);
        // One of the points is not in the water
        if (terrain != NAV_MAGMA && terrain != NAV_WATER)
        {
            waterPath = false;
            break;
        }
    }

    return waterPath;
}
