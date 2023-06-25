CREATE VIEW data AS
    SELECT *,
           rank() OVER (ORDER BY session_id || name) AS workout_id,
           rank() OVER (ORDER BY name) AS exercise_id,
           rank() OVER (ORDER BY session_id,
           name || reps || weigth) AS set_id
      FROM (
               SELECT year || month || day AS session_id,
                      name,
                      reps,
                      weigth,
                      count( * ) AS sets,
                      avg(body_weigth) AS body_weigth,
                      max(timestamp) AS timestamp,
                      min(timestamp) AS min_timestamp
                 FROM workouts
                GROUP BY session_id,
                         name,
                         reps,
                         weigth
                ORDER BY session_id DESC
           );


CREATE VIEW data_for_sets AS
    SELECT year || month || day AS session_id,
           name,
           reps,
           weigth,
           timestamp
      FROM workouts
     ORDER BY session_id DESC;

INSERT INTO session (
                        id,
                        timestamp
                    )
                    SELECT session_id,
                           min(timestamp) 
                      FROM data
                     GROUP BY session_id;

INSERT INTO training (
                         id
                     )
                     VALUES (1);


INSERT INTO workout (
                        id,
                        fk_exercise_id,
                        fk_session_id
                    )
                    SELECT DISTINCT workout_id,
                                    exercise_id,
                                    session_id
                      FROM data;


INSERT INTO sets (
                     fk_workout_id,
                     reps,
                     weigth,
                     body_weigth,
                     timestamp
                 )
                 SELECT b.workout_id,
                        a.reps,
                        a.weigth,
                        b.body_weigth,
                        a.timestamp
                   FROM data_for_sets AS a
                        JOIN
                        data AS b ON a.session_id = b.session_id AND 
                                     a.name = b.name
                  ORDER BY a.timestamp DESC;