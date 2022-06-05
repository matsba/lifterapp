--
-- File generated with SQLiteStudio v3.3.3 on ma touko 23 22:24:07 2022
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: workouts
DROP TABLE IF EXISTS workouts;
CREATE TABLE workouts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, reps INTEGER, weigth REAL, body_weigth INTEGER, timestamp TEXT, year INTEGER, month INTEGER, day INTEGER);
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (730, 'Hauiskääntö', 12, 10.0, 0, '2022-05-09 16:52:54.925588', 2022, 5, 9); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (731, 'Hauiskääntö', 12, 10.0, 0, '2022-05-09 16:55:20.200348', 2022, 5, 9); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (734, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-09 17:06:14.388152', 2022, 5, 9); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (735, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-09 17:09:17.011542', 2022, 5, 9); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (736, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-09 17:12:23.497411', 2022, 5, 9);--viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (737, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-09 17:16:11.350936', 2022, 5, 9);--viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (751, 'Hauiskääntö', 12, 10.0, 0, '2022-05-12 16:51:43.341998', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (752, 'Hauiskääntö', 12, 10.0, 0, '2022-05-12 16:53:57.125548', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (753, 'Hauiskääntö', 12, 10.0, 0, '2022-05-12 16:57:13.574603', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (754, 'Hauiskääntö', 12, 10.0, 0, '2022-05-12 17:02:09.373480', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (755, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-12 17:05:54.066365', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (756, 'Penkki käsipainoilla', 12, 12.5, 0, '2022-05-12 17:08:58.617105', 2022, 5, 12); --viikko 19
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (770, 'Ylätalja kapealla kahvalla', 12, 40.0, 0, '2022-05-16 17:36:10.556143', 2022, 5, 16); --viikko 20 
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (771, 'Ylätalja kapealla kahvalla', 12, 40.0, 0, '2022-05-16 17:38:36.513062', 2022, 5, 16);
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (780, 'Vatsat', 12, 0.0, 1, '2022-05-16 18:05:45.618054', 2022, 5, 16); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (781, 'Vatsat', 12, 0.0, 1, '2022-05-16 18:08:07.687288', 2022, 5, 16); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (786, 'Kyykky tangolla', 4, 50.0, 0, '2022-05-19 17:10:00.452975', 2022, 5, 19); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (787, 'Kyykky tangolla', 3, 50.0, 0, '2022-05-19 17:13:19.815549', 2022, 5, 19); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (794, 'Hauiskääntö', 7, 12.5, 0, '2022-05-19 17:31:44.240551', 2022, 5, 19); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (795, 'Hauiskääntö', 6, 12.5, 0, '2022-05-19 17:34:21.865212', 2022, 5, 19); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (812, 'Ylätalja kapealla kahvalla', 12, 40.0, 0, '2022-05-21 10:14:28.241927', 2022, 5, 21); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (813, 'Ylätalja kapealla kahvalla', 12, 40.0, 0, '2022-05-21 10:16:51.592927', 2022, 5, 21); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (814, 'Ylätalja kapealla kahvalla', 8, 40.0, 0, '2022-05-21 10:19:30.261329', 2022, 5, 21); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (815, 'Ylätalja kapealla kahvalla', 8, 40.0, 0, '2022-05-21 10:21:39.431718', 2022, 5, 21); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (816, 'Selkä', 11, 35.0, 0, '2022-05-21 10:23:55.981832', 2022, 5, 21); --viikko 20
INSERT INTO workouts (id, name, reps, weigth, body_weigth, timestamp, year, month, day) VALUES (817, 'Selkä', 11, 35.0, 0, '2022-05-21 10:26:27.207601', 2022, 5, 21); --viikko 20

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
