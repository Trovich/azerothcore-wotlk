--
-- Watcher Backus: walk the road between the fences, not on them.
--
-- His path (42300) was 9 points out along the road north of Darkshire and the same 9 back, up to 40 yd
-- apart. move_type 0 walks a straight line between two points, and on the stretch where the road runs
-- between two fences (points 3-7) those straight lines cut the bends right over the fence posts.
--
-- The fence is invisible to a plain navmesh check: only its posts are holes in the server navmesh, the rails
-- between them are walkable. Posts were taken from the navmesh (holes under 2.6 yd), neighbouring posts of
-- one fence (<= 4.8 yd apart) joined into a wall, and the route searched over the navmesh with that wall
-- in, clearance to any obstacle penalised up to 3 yd (keeps to the middle of the road), pulled towards the
-- old path elsewhere (it follows the road, it only cut the bends). Then reduced to points at most 12 yd
-- apart, every straight piece between two points checked: on walkable ground and >= 0.7 yd from any post,
-- wall or obstacle edge - the closest spot of the whole loop is 0.93 yd.
--
-- A loop instead of out-and-back over the same points: out 0.8 yd right of the road's middle, back 0.8 yd
-- right of it the other way, like anyone walking a road. Same two ends as before, no stops (as before).
-- 49 points, 496 yd per round. Heights: navmesh corrected by the old path's own (sniffed) z.
--
DELETE FROM `waypoint_data` WHERE `id` = 42300;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `velocity`, `delay`, `smoothTransition`, `move_type`, `action`, `action_chance`, `wpguid`) VALUES
(42300, 1, -10512.50, -1187.30, 28.086, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 2, -10501.41, -1186.29, 28.030, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 3, -10490.39, -1184.86, 28.023, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 4, -10479.39, -1183.15, 27.887, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 5, -10468.37, -1181.72, 27.689, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 6, -10457.23, -1179.40, 27.365, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 7, -10447.14, -1174.64, 27.736, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 8, -10437.00, -1168.69, 28.015, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 9, -10428.93, -1161.06, 27.631, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 10, -10423.51, -1153.87, 26.511, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 11, -10418.51, -1143.87, 25.894, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 12, -10411.70, -1134.54, 23.873, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 13, -10402.97, -1128.24, 22.587, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 14, -10394.04, -1121.01, 22.654, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 15, -10388.37, -1118.43, 22.042, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 16, -10376.50, -1118.30, 21.582, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 17, -10364.50, -1118.30, 21.451, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 18, -10352.56, -1117.44, 21.490, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 19, -10341.75, -1120.54, 21.531, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 20, -10330.74, -1123.69, 21.550, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 21, -10320.96, -1127.58, 21.521, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 22, -10312.54, -1136.02, 21.626, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 23, -10304.79, -1144.50, 22.586, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 24, -10303.15, -1146.96, 22.667, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 25, -10301.85, -1146.04, 22.756, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 26, -10309.61, -1136.97, 22.169, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 27, -10316.96, -1128.91, 21.695, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 28, -10323.17, -1124.49, 21.722, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 29, -10334.30, -1121.01, 21.426, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 30, -10345.25, -1117.74, 21.499, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 31, -10353.50, -1115.70, 21.560, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 32, -10364.50, -1116.70, 21.496, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 33, -10376.50, -1116.70, 21.646, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 34, -10387.58, -1116.70, 22.103, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 35, -10393.93, -1118.97, 22.713, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 36, -10403.03, -1126.19, 23.061, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 37, -10411.82, -1132.70, 23.741, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 38, -10416.73, -1138.05, 24.699, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 39, -10422.34, -1148.12, 26.521, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 40, -10428.11, -1157.98, 27.319, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 41, -10436.04, -1165.76, 27.966, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 42, -10444.86, -1171.78, 28.181, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 43, -10454.82, -1176.62, 27.517, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 44, -10465.63, -1179.57, 27.533, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 45, -10476.61, -1181.14, 27.796, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 46, -10487.63, -1182.85, 28.067, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 47, -10498.61, -1184.28, 28.134, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 48, -10510.53, -1185.70, 28.082, NULL, 0, 0, 0, 0, 0, 100, 0),
(42300, 49, -10512.50, -1185.70, 28.289, NULL, 0, 0, 0, 0, 0, 100, 0);

UPDATE `creature` SET `position_x` = -10512.50, `position_y` = -1187.30, `position_z` = 28.086, `currentwaypoint` = 0 WHERE `guid` = 4230;
