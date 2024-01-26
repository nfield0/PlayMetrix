CREATE DATABASE playmetrix;

/*DROP TABLE league, manager_login, manager_info, sport, player_login, player_info, player_stats, physio_login, physio_info, team, team_physio, player_team*/

/*SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'player_info';*/

/*--------------------------------------TABLES---------------------------------------------*/

/*CREATING THE BASICS PLAYER TABLES*/
CREATE TABLE IF NOT EXISTS player_login
(
	player_id serial PRIMARY KEY,
	player_email VARCHAR(50) UNIQUE NOT NULL,
	player_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS player_info 
(
	player_id INT NOT NULL PRIMARY KEY,
	player_firstname VARCHAR(25) NOT NULL, 
	player_surname VARCHAR(25) NOT NULL,
	player_DOB DATE NOT NULL,
	player_contact_number VARCHAR(20),
    player_height VARCHAR(10),
    player_gender VARCHAR(20),
	player_image bytea,
	FOREIGN KEY(player_id)
		REFERENCES player_login(player_id)
);

CREATE TABLE IF NOT EXISTS player_stats 
(
	player_id INT NOT NULL PRIMARY KEY,
	matches_played INT NOT NULL, 
	matches_started INT NOT NULL,
	matches_off_the_bench INT NOT NULL, 
	injury_prone BOOLEAN NOT NULL,
	minutes_played INT NOT NULL,
	FOREIGN KEY(player_id)
		REFERENCES player_info(player_id)
);

/*BASE TABLES FOR MANAGER*/

CREATE TABLE IF NOT EXISTS manager_login
(
	manager_id serial PRIMARY KEY,
	manager_email VARCHAR (50) NOT NULL, 
	manager_password VARCHAR (150) NOT NULL
);

CREATE TABLE IF NOT EXISTS manager_info
(
	manager_id INT NOT NULL PRIMARY KEY,
	manager_firstname VARCHAR (25) NOT NULL, 
	manager_surname VARCHAR(25) NOT NULL,
	manager_contact_number VARCHAR(20) NOT NULL,
	manager_image bytea,
	FOREIGN KEY (manager_id)
		REFERENCES manager_login(manager_id)
);

/*BASE TABLES FOR COACH*/
CREATE TABLE coach_login
(

	coach_id serial PRIMARY KEY,
	coach_email VARCHAR (50) NOT NULL,
	coach_password VARCHAR(150) NOT NULL
);

CREATE TABLE coach_info
(
	coach_id INT NOT NULL PRIMARY KEY,
	coach_firstname VARCHAR(25) NOT NULL,
	coach_surname VARCHAR(25) NOT NULL,
	coach_contact VARCHAR(25) NOT NULL,
	coach_image bytea,
	FOREIGN KEY (coach_id)
		REFERENCES coach_login(coach_id)
);

/*BASE TABLE FOR THE PHYSIO*/
CREATE TABLE IF NOT EXISTS physio_login
(
	physio_id serial PRIMARY KEY,
	physio_email VARCHAR(50) UNIQUE NOT NULL,
	physio_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS physio_info
(
	physio_id serial PRIMARY KEY,
	physio_firstname VARCHAR (30) NOT NULL,
	physio_surname VARCHAR (50) NOT NULL, 
	physio_contact_number VARCHAR(30) NOT NULL,
	physio_image bytea,
	FOREIGN KEY(physio_id)
		REFERENCES physio_login(physio_id)
);

ALTER TABLE physio_info 
ADD physio_image bytea ; 

/*TABLES NEEDED BEFORE TEAM CAN BE ADDED*/
CREATE TABLE IF NOT EXISTS sport
(
	sport_id serial PRIMARY KEY,
	sport_name VARCHAR(30)
);
CREATE TABLE IF NOT EXISTS league
(
	league_id serial PRIMARY KEY,
	league_name VARCHAR (50)
);

/*TEAM TABLE*/

CREATE TABLE IF NOT EXISTS team
(
	team_id serial PRIMARY KEY, 
	team_name VARCHAR(100) UNIQUE NOT NULL,
    team_location VARCHAR(30),
	team_logo bytea,
	manager_id INT NOT NULL,
	league_id INT NOT NULL,
	sport_id INT NOT NULL,
	FOREIGN KEY (manager_id)
		REFERENCES manager_info(manager_id),
	FOREIGN KEY (league_id)
		REFERENCES league (league_id),
	FOREIGN KEY (sport_id)
		REFERENCES sport(sport_id)
);

/*INJURIES TABLE*/
CREATE TABLE IF NOT EXISTS  injuries
(
	injury_id serial PRIMARY KEY,
	injury_type VARCHAR(50),
	expected_recovery_time VARCHAR(50),
	recovery_method VARCHAR(255)
);

/*RELATIONAL TABLES ORDER SHOULD NOT MATTER AS LONG AS ALL THE ABOVE ARE IN*/
CREATE TABLE IF NOT EXISTS team_physio
(
	team_id INT NOT NULL,
	physio_id INT NOT NULL, 
	PRIMARY KEY (team_id, physio_id),
	FOREIGN KEY (team_id) 
		REFERENCES team (team_id),
	FOREIGN KEY (physio_id)
		REFERENCES physio_info(physio_id)
);

CREATE TABLE IF NOT EXISTS player_team
(
	player_id INT NOT NULL,
	team_id INT NOT NULL, 
	team_position VARCHAR (30),
    player_team_number INT,
    playing_status VARCHAR(25),
    lineup_status VARCHAR(30),
	PRIMARY KEY (player_id, team_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id),
	FOREIGN KEY (team_id)
		REFERENCES team (team_id)
);

CREATE TABLE team_coach 
(
	coach_id INT NOT NULL,
	team_id INT NOT NULL,
	team_role VARCHAR(255),
	PRIMARY KEY(coach_id, team_id),
	FOREIGN KEY (coach_id)
		REFERENCES coach_info (coach_id),
	FOREIGN KEY (team_id)
		REFERENCES team(team_id)
);


CREATE TABLE IF NOT EXISTS  player_injuries 
(
	injury_id INT NOT NULL,
	date_of_injury DATE NOT NULL, 
	date_of_recovery DATE NOT NULL,
	player_id INT NOT NULL, 
	PRIMARY KEY(injury_id, player_id),
	FOREIGN KEY(injury_id)
		REFERENCES injuries(injury_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS schedule
(
	schedule_id serial PRIMARY KEY,
	schedule_type VARCHAR (100),
	schedule_start_time TIMESTAMP,
	schedule_end_time TIMESTAMP
	
);

CREATE TABLE team_schedule
(
	schedule_id INT NOT NULL,
	player_id INT NOT NULL,
	player_attending BOOLEAN NOT NULL,
	PRIMARY KEY (schedule_id, player_id),
	FOREIGN KEY (schedule_id)
		REFERENCES schedule(schedule_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id)

);
/*Anouncements Table*/
CREATE TABLE IF NOT EXISTS announcements
(
	announcements_id serial PRIMARY KEY,
	announcements_title VARCHAR(100) NOT NULL,
	announcements_desc VARCHAR(255), 
	announcements_date TIMESTAMP, 
	manager_id INT NOT NULL,
	schedule_id INT NOT NULL,
	FOREIGN KEY(manager_id)
		REFERENCES manager_info(manager_id),
	FOREIGN KEY(schedule_id)
		REFERENCES schedule(schedule_id)
);



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

/*--------------------------DUMMY DATA FOR TESTING QUERIES--------------------------------------------------*/
/*NEED TO BE ADDED BEFORE TEAM AND PLAYER*/
INSERT INTO league(league_name)
VALUES 
('Division One'),
('Division Two'),
('Division Three'),
('Division Four');

INSERT INTO sport(sport_name) VALUES
('Gaelic Football'),
('Hurling'),
('Football'),
('Rugby'),
('Camogie'); 

INSERT INTO injuries (injury_type, recovery_method, expected_recovery_time) VALUES
('Broken Foot','rest','4 Months');

/*INSERTING INTO PLAYER TABLES*/
INSERT INTO player_login (player_email, player_password) VALUES
('player1@gmail.com','password1'),
('player2@gmail.com','password2'),
('player3@gmail.com','password3');

INSERT INTO player_info(player_id, player_firstname, player_surname, player_DOB, player_contact_number,player_image) VALUES
(7,'Mark','Sheppard', '1999-05-31', '30888802', ''),
(8,'Peter','Langford', '1994-03-17', '40858802', ''),
(9,'Christopher','Smith', '2002-01-05', '0860709331', '');

INSERT INTO player_stats(matches_played, matches_started, matches_off_the_bench, injury_prone, minutes_played, player_id) VALUES
(30,20,10,TRUE,2000,7),
(10,10,0,FALSE,700,8),
(14,1,13,TRUE,480,9);

/*INSERTS FOR THE PHYSIO TABLES*/
INSERT INTO physio_login(physio_email, physio_password)  VALUES
('physio@gmail.com', 'passwordphysio'),
('physio2@gmail.com', 'physiopassword3');

INSERT INTO physio_info(physio_firstname, physio_surname, physio_contact_number, physio_id) VALUES
('Jennie', 'Gray', '003537612678', 3 ),
('Booker', 'DeWitt', '+4467009312',4);

/*INSERTS FOR MANAGER*/
INSERT INTO manager_login(manager_email, manager_password) VALUES
('manager@gmail.com', 'passwordm');

INSERT INTO manager_info(manager_id,manager_firstname, manager_surname, manager_contact_number, manager_image) VALUES
(1,'Robert', 'Singer', '0871751842', '');


/*INSERTS FOR COACH*/
INSERT INTO coach_login(coach_email, coach_password) VALUES
('coach@gmail.com', 'passwordc'),
('coach2@gmai.com', 'cpassword');

INSERT INTO coach_info(coach_id, coach_firstname, coach_surname, coach_contact, coach_image) VALUES
(1,'Frank', 'Zappa', '0871751654', ''),
(2,'Marie', 'Smyth', '0870961234','');


/*INSERT INTO TEAM --- BECAREFUL WITH THIS AS MY ID AND YOURS COULD BE DIFFERENT*/
INSERT INTO team (team_name, manager_id, league_id, sport_id, team_location) VALUES
('Forkhill GFC', 1, 9,11, 'Forkhill South Armagh');

/*RELATIONAL INSERTS AGAIN MY ID AND YOURS COULD BE DIFFERENT SO THIS MAY NEED TO BE CHANGED ON YOUR END*/
INSERT INTO player_team (player_id, team_id, team_position, player_team_number, playing_status) VALUES
(7,1, 'Goalkeeper', 1, 'Match Fit'),
(8,1, 'Full Foward', 15, 'Match Fit'),
(9,1, 'Corner Back', 4, 'Injuried');

INSERT INTO team_coach (coach_id, team_id, team_role) VALUES
(1,1,'Offence'),
(2,1,'Defense');

INSERT INTO team_physio(team_id, physio_id) VALUES
(1,3),
(1,4);

INSERT INTO player_injuries(injury_id,date_of_injury, date_of_recovery, player_id) VALUES
(3, '2023-12-06', '2024-03-06', 7);



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


/*A Query that Counts the number of training/match days that a player misses 
and shows what the players playing status was at the time of absences */



/*A Query for managers and coaches that will quickly display whether the player is fit, 
injured or be cautious with them A Queries that will count the amount of injuries that team has accumulated 
(it will also display what the injury type is as well)*/



/*Injury Queries*/

/*Query for Displaying what players are match fit (will include all their details*/


/*Same Query for players who are injured*/


/*Same Query for players who are on warning*/

 
/*A query that shows a specific players injury and their recovery time*/


/*A query that shows all the injury prone players on the team*/


/*A query that shows if the player has played over a certain amount of games and their current playing status*/
