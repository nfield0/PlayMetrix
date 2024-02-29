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


/*--------------------------------------QUERIES---------------------------------------------*/
/*BASIC QUERIES TO TEST ALL IN PLAYER TABLES DATA*/
SELECT * FROM player_info;
SELECT * FROM player_injuries;
SELECT * FROM player_login; 
SELECT * FROM player_team;
SELECT * FROM player_stats;


/*BASIC JOIN PLAYER QUERIES*/
SELECT player_surname, player_image FROM player_info;

SELECT player_firstname, player_surname, injury_type
FROM player_info 
JOIN player_injuries USING(player_id)
JOIN injuries USING(injury_id);

SELECT player_surname AS SURNAME, player_team_number AS KITNUM, team_position AS POSITION
FROM player_info 
JOIN player_team USING(player_id)
ORDER BY player_team_number ASC;

SELECT player_surname AS SURNAME, COUNT(injury_id) AS numOfInjuries
FROM player_info 
JOIN player_injuries USING(player_id)
GROUP BY player_surname;

SELECT player_surname, injury_prone FROM player_info 
JOIN player_stats USING (player_id);

SELECT player_surname, team_id, team_position, player_team_number, playing_status
FROM player_team JOIN player_info 
USING(player_id);

SELECT playerInfo.player_surname, teamInfo.team_name 
FROM  player_info playerInfo, team teamInfo, player_team teamPlayer 
WHERE playerInfo.player_id = teamPlayer.player_id AND teamInfo.team_id = teamPlayer.team_id;


/*BASIC MANAGER QUERIES*/
SELECT * FROM manager_login;
SELECT * FROM manager_info;
SELECT * FROM manager_info INNER JOIN manager_login USING(manager_login_id);

/*JOIN MANAGERS TABLES*/
SELECT manager_firstname, manager_surname, team_name,team_location FROM team 
JOIN manager_info USING (manager_id);

SELECT manager_firstname,manager_surname, manager_email, manager_contact_number FROM manager_login JOIN manager_info 
USING (manager_id);


/*BASIC PHYSIO QUERIES*/
SELECT * FROM physio_login;
SELECT * FROM physio_info;
SELECT * FROM physio_info INNER JOIN physio_login USING(physio_id);


SELECT physio_email, physio_contact_number FROM physio_login JOIN physio_info 
USING (physio_id);

/*Schedules Queries*/
SELECT * FROM schedule
SELECT * FROM team_schedule
SELECT * FROM announcements

/*Injury Queries */

SELECT * FROM injury;
SELECT * FROM player_injuries


/*Deletion Queries*/
/*Delete all records from each table*/
DELETE FROM player_injuries;
DELETE FROM player_team;
DELETE FROM player_stats;
DELETE FROM player_info;
DELETE FROM player_login;
DELETE FROM team_coach;
DELETE FROM team_physio;
DELETE FROM team;
DELETE FROM physio_info;
DELETE FROM physio_login;
DELETE FROM manager_info;
DELETE FROM manager_login;
DELETE FROM coach_info;
DELETE FROM coach_login;
DELETE FROM league;
DELETE FROM sport;
DELETE FROM injuries;
DELETE FROM schedule;
DELETE FROM team_schedule;
DELETE FROM announcements;

/*Delete team*/
DELETE FROM team WHERE team_id =


/*Deleting Players using id --- Most logical*/
DELETE FROM player_info WHERE player_id =
DELETE FROM player_stats WHERE player_id =
DELETE FROM player_team WHERE player_id =
DELETE FROM player_injuries WHERE player_id =
/*Due to Key Constraints this will have to be the last one*/
DELETE FROM player_login WHERE player_id =

/*Delete sport*/
DELETE FROM sport WHERE sport_id =

/*Delete league*/
DELETE FROM league WHERE league_id =



/*Deleting Manager using id --- Most logical*/
DELETE FROM manager_info WHERE manager_id =
/*Due to Key Constraints this will have to be the last one*/
DELETE FROM manager_login WHERE manager_id =

/*Deleting Coach using id --- Most logical*/
DELETE FROM coach_info WHERE coach_id =
DELETE FROM team_coach WHERE coach_id =
/*Due to Key Constraints this will have to be the last one*/
DELETE FROM coach_login WHERE coach_id =

/*Deleting Physio using id --- Most logical*/
DELETE FROM physio_info WHERE physio_id =
DELETE FROM team_physio WHERE physio_id =
/*Due to Key Constraints this will have to be the last one*/
DELETE FROM physio_login WHERE physio_id =



/********EDITING QUERIES**************/
/*As the season progresses players will regularly get injured and drop in and out of the team*/
UPDATE player_team set playing_status = "Fit" where player_id = ;
UPDATE player_team set lineup_status = "Starter" where player_id = ;
UPDATE player_stats set matches_started = where player_id = ;
UPDATE player_stats set matches_off_the_bench = where player_id = ;
UPDATE player_stats set matches_played = where player_id = ;


/*Promotion or Relegation*/
UPDATE team set league_id = where team_name = "";


/*Unfortunate Event of a Manager leaving or being sacked*/
/*Step One will need to add a new manager profile code for this is above on lines 365 - 369*/
UPDATE team set manager_id = where team_name = "";

/*If coaches leave*/
/*Again will need to add a coach profile first use lines 373 - 379*/
UPDATE team set coache_id = where team_name = ""

/*Updating Profile Pictures for profiles and clubs*/
UPDATE team set team_logo = "" where team_name = ;
UPDATE player_info set player_image = "" where player_id = ;
UPDATE manager_info set manager_image = "" where manager_id = ;
UPDATE coach_info set coach_image = "" where coach_id = ;


/*Other Misc PlayerInfo edits that may be needed*/
UPDATE player_info set player_surname = "" where player_id = ;
UPDATE player_info set player_contact_number = "" where player_id = ;
UPDATE player_info set player_height = where player_id = ;


/*Scheduling and announcements Editing*/
/*Unless theres a more efficient way to tie these two together may just have to update them individually*/
UPDATE schedule set schedule_start_time = where schedule_id = ;
UPDATE schedule set schedule_start_end = where schedule_id = ;

/*In the Event of something like a match getting postponed or cancalled*/
/*But the manager wants to take training instead*/
UPDATE schedule set schedule_type = "Training" where schedule id = ;


/*Anouncements Table*/
UPDATE announcements set announcements_title = "Generic Message" where announcements_id = ;
UPDATE announcements set announcements_desc = "Generic Description" where announcements_id = ;


/*Updating a Password*/
UPDATE player_login set player_password = "newSecurerPassword1" where player_email = "";
UPDATE manager_login set manager_password = "newSecurerPassword1" where manager_email = "";
UPDATE coach_login set player_password = "newSecurerPassword1" where coach_email = "";
UPDATE player_login set player_password = "newSecurerPassword1" where player_email = "";

/*Shows the players Position and and matches they have played*/
SELECT playerLogin.player_email, playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.team_position 
FROM player_login playerLogin, player_info playerInfo, player_stats playerStats, player_team playerTeam
WHERE playerLogin.player_id = playerInfo.player_id
AND playerInfo.player_id = playerStats.player_id 
AND playerInfo.player_id = playerTeam.player_id;

SELECT playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.team_position 
FROM player_info playerInfo, player_stats playerStats, player_team playerTeam
WHERE playerInfo.player_id = playerStats.player_id 
AND playerInfo.player_id = playerTeam.player_id;

/*Shows the team and physio*/
SELECT physioInfo.physio_firstname, physioInfo.physio_surname, teamInfo.team_name, teamInfo.team_location
FROM physio_info physioInfo, team teamInfo, team_physio teamPhysio
WHERE physioInfo.physio_id = teamPhysio.physio_id AND teamInfo.team_id = teamPhysio.team_id;


/*Displaying what manager, coaches and players will be attending training for attacking */
/*Still Some Kinks to work out in this*/
SELECT playerInfo.player_firstname, playerInfo.player_surname, 
	   managerInfo.manager_firstname, managerInfo.manager_surname,
	   coachInfo.coach_firstname, coachInfo_coach_surname,
	   teamSchedule.player_attending 
FROM player_info PlayerInfo, team_schedule teamSchedule, schedule schedule, manger_info managerInfo, coach_info coachInfo
WHERE playerInfo.player_id = teamSchedule.player_id AND teamSchedule.schedule_id = schedule.schedule_id 
AND teamSchedule.players_attending = TRUE AND schedule.schedule_type = "Attacking";
	   
/*Shows if a Player will be attending matches*/
SELECT Player.player_firstname, Player.player_surname, teamS.player_attending, schedule.schedule_type 
FROM player_info Player, team_schedule teamS, schedule schedule
WHERE Player.player_id = teamS.player_id AND teamS.schedule_id = schedule.schedule_id;
AND schedule.schedule_type = 'Match';

/*Shows if a Player will be attending Defense Training*/
SELECT Player.player_firstname, Player.player_surname, teamS.player_attending, schedule.schedule_type 
FROM player_info Player, team_schedule teamS, schedule schedule
WHERE Player.player_id = teamS.player_id AND teamS.schedule_id = schedule.schedule_id;
AND schedule.schedule_type = 'Defending';

/*Shows if a Player will be Attacking matches*/
SELECT Player.player_firstname, Player.player_surname, teamS.player_attending, schedule.schedule_type 
FROM player_info Player, team_schedule teamS, schedule schedule
WHERE Player.player_id = teamS.player_id AND teamS.schedule_id = schedule.schedule_id
AND schedule.schedule_type = 'Attacking';


/*SQUAD DEPTH QUERY*/
/*A Query that Counts the number of player and coaches that are associated with the team as well as who the manager of the team is */
SELECT  DISTINCT managerInfo.manager_firstname, managerInfo.manager_surname, 
	   coachInfo.coach_firstname, coachInfo.coach_surname, teamCoach.team_role, 
	   COUNT(teamPlayer.player_id) AS Squad_Depth
FROM manager_info managerInfo, coach_info coachInfo, team_coach teamCoach, team teamInfo, player_team teamPlayer
WHERE managerInfo.manager_id = teamInfo.manager_id AND coachInfo.coach_id = teamCoach.coach_id
GROUP BY manager_firstname, manager_surname, coach_firstname, coach_surname, team_role



/*View the Binary Data*/
SELECT encode(player_injury_reports::bytea, 'escape') FROM player_physio as o where o.player_injury_reports != ''


SELECT playerInfo.player_id AS PlayerID,
	   playerInfo.player_firstname, playerInfo.player_surname, playerInfo.player_dob,
	   playerInfo.player_contact_number, playerInfo.player_height, playerInfo.player_gender,
	   playerStats.matches_played, playerStats.matches_started, playerStats.matches_off_the_bench,
	   playerStats.minutes_played, team.team_name, playerTeam.team_position, playerTeam.player_team_number,
	   playerTeam.playing_status, playerTeam.lineup_status, physioInfo.physio_id,
	   injuries.injury_type, playerInjury.date_of_injury, playerInjury.date_of_recovery, playerInjury.player_injury_report
FROM player_info playerInfo, player_stats playerStats, player_team playerTeam, physio_info physioInfo,
	 team team, injuries injuries, player_injuries playerInjury
WHERE playerInfo.player_id = playerStats.player_id 
AND playerTeam.team_id = team.team_id
AND injuries.injury_id = playerInjury.injury_id 

SELECT injury_id, injury_type, injury_name_and_grade, injury_location, 
	   potential_recovery_method_1, potential_recovery_method_2, potential_recovery_method_3, 
	   expected_minimum_recovery_time AS MinWeeks, expected_maximum_recovery_time AS MaxWeeks 
FROM injuries;









/* TRUNCATE QUERIES FOR SHAKIRA */
/*DO NOT USE ITS EASIER TO DROP ALL TABLES AS IT WONT MESS UP THE SERIALS*/
/*USING CASCADE WILL PURGE ALL DATA RELATED WITH EACH OTHER IN THE DATABASE*/
-- TRUNCATE TABLE player_login, player_info, player_stats, player_team, player_schedule, player_injuries ;
-- TRUNCATE TABLE manager_login, manager_info;
-- TRUNCATE TABLE coach_login, coach_info;
-- TRUNCATE TABLE physio_login , physio_info

