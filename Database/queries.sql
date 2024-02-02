/* Displays all the information about a player */
SELECT * FROM player_info
JOIN player_login USING (player_id)
JOIN player_stats USING (player_id)
JOIN player_team USING(player_id)

/* Displays all the information about the Schedule */
SELECT * FROM schedule 
JOIN player_schedule USING (schedule_id)
JOIN team_schedule USING (schedule_id)
JOIN announcements USING (schedule_id)




















/* TRUNCATE QUERIES FOR SHAKIRA */
/*DO NOT USE ITS EASIER TO DROP ALL TABLES AS IT WONT MESS UP THE SERIALS*/
/*USING CASCADE WILL PURGE ALL DATA RELATED WITH EACH OTHER IN THE DATABASE*/
-- TRUNCATE TABLE player_login, player_info, player_stats, player_team, player_schedule, player_injuries ;
-- TRUNCATE TABLE manager_login, manager_info;
-- TRUNCATE TABLE coach_login, coach_info;
-- TRUNCATE TABLE physio_login , physio_info

