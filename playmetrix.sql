CREATE DATABASE playmetrix;
/*ALTER DATABASE playmetric RENAME TO playmetrix;*/

/*DROP TABLE league, manager_login, manager_info, sport, player_login, player_info, player_stats, physio_login, physio_info, team, team_physio, player_team*/

/*SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'player_info';*/

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


/*MODIFICATIONS FOR THE PLAYER TABLES ONES YOU NEED TO ADD*/

ALTER TABLE player_info 
ADD player_height VARCHAR(10),
ADD player_gender VARCHAR(20);

/*PLAYER MODIFICATIONS IF YOU HAD V1 OF THE DATATBASE*/
ALTER TABLE player_info DROP player_login_id;
ALTER TABLE player_login RENAME player_login_id TO player_id;

ALTER TABLE player_info
ADD FOREIGN KEY(player_id)
	REFERENCES player_login(player_id);
	
ALTER TABLE player_stats DROP player_id;
ALTER TABLE player_stats RENAME player_stats_id TO player_id;
ALTER TABLE player_stats
ADD FOREIGN KEY(player_id)
	REFERENCES player_info(player_id);
	
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
		REFERENCES manager_login(manager_id);
);

/*MODIFICATIONS IF YOU ARE USING V1 OF DATABASE*/
/*YOU WILL ONLY NEED THE DELETES IF YOU HAVE ALREADY POPULATED THE TABLES*/
DELETE FROM team_physio;
DELETE FROM team_coach;
DELETE FROM player_team;
DELETE FROM manager_info;	
DELETE FROM manager_login;

ALTER TABLE manager_info DROP manager_login_id;
ALTER TABLE manager_login RENAME manager_login_id TO manager_id;
ALTER TABLE manager_info 
ADD FOREIGN KEY(manager_id)
REFERENCES manager_info(manager_id);


/*BASE TABLES FOR COACH*/
CREATE TABLE coach_login
(

	coach_login_id serial PRIMARY KEY,
	coach_email VARCHAR (50) NOT NULL,
	coach_password VARCHAR(150) NOT NULL
);

CREATE TABLE coach_info
(
	coach_id serial PRIMARY KEY,
	coach_firstname VARCHAR(25) NOT NULL,
	coach_surname VARCHAR(25) NOT NULL,
	coach_contact VARCHAR(25) NOT NULL,
	coach_login_id INT NOT NULL,
	coach_image bytea,
	FOREIGN KEY (coach_login_id)
		REFERENCES coach_login(coach_login_id)
);

/*MODIFICATIONS FOR THE COACH TABLE*/
/*YOU WILL ONLY NEED THE DELETES IF YOU HAVE ALREADY POPULATED THE TABLES*/

DELETE FROM coach_info;
DELETE FROM coach_login;

ALTER TABLE coach_info DROP coach_login_id;
ALTER TABLE coach_login RENAME coach_login_id TO coach_id;
ALTER TABLE coach_info ADD FOREIGN KEY (coach_id) REFERENCES coach_login(coach_id);


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
	FOREIGN KEY(physio_id)
		REFERENCES physio_login(physio_id)
);

/*MODIFICATIONS FOR THE PHYSIO TABLES*/
ALTER TABLE physio_info DROP physio_login_id;
ALTER TABLE physio_login rename physio_login_id to physio_id;
ALTER TABLE physio_info ADD FOREIGN KEY (physio_id) REFERENCES physio_login(physio_id);

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

/*MODIFICATION FOR TEAM*/
ALTER TABLE team
ADD team_location VARCHAR(30);


/*INJURIES TABLE*/
CREATE TABLE IF NOT EXISTS  injuries
(
	injury_id serial PRIMARY KEY,
	injury_type VARCHAR(50),
	expected_recovery_time VARCHAR(50),
	recovery_method VARCHAR(255)
);

/*MODIFICATIONS FOR INJURIES TABLE NOT NEEDED IF YOU ARE NOT USING V1*/
ALTER TABLE injuries DROP expected_recovery_time
ALTER TABLE injuries ADD COLUMN expected_recovey_time VARCHAR(50);


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
	position VARCHAR (30),
	PRIMARY KEY (player_id, team_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id),
	FOREIGN KEY (team_id)
		REFERENCES team (team_id)
);

/*ADJUSTEMENTS TO PLAYER_TEAM*/
ALTER TABLE player_team 
RENAME position TO team_position;

ALTER TABLE player_team 
ADD player_team_number INT
ADD playing_status VARCHAR (25);


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
	calendar_id serial PRIMARY KEY
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

SELECT playerLogin.player_email, playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.team_position 
FROM player_login playerLogin, player_info playerInfo, player_stats playerStats, player_team playerTeam
WHERE playerLogin.player_id = playerInfo.player_id
AND playerInfo.player_id = playerStats.player_id 
AND playerInfo.player_id = playerTeam.player_id;

SELECT playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.team_position 
FROM player_info playerInfo, player_stats playerStats, player_team playerTeam
WHERE playerInfo.player_id = playerStats.player_id 
AND playerInfo.player_id = playerTeam.player_id;

SELECT player_surname AS SURNAME, COUNT(injury_id) AS numOfInjuries
FROM player_info 
JOIN player_injuries USING(player_id)
GROUP BY player_surname;

SELECT player_surname, injury_prone FROM player_info 
JOIN player_stats USING (player_id);

SELECT player_surname, team_id, team_position, player_team_number, playing_status
FROM player_team JOIN player_info 
USING(player_id);

LECT playerInfo.player_surname, teamInfo.team_name 
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

SE


/*BASIC PHYSIO QUERIES*/
SELECT * FROM physio_login;
SELECT * FROM physio_info;
SELECT * FROM physio_info INNER JOIN physio_login USING(physio_id);

SELECT physioInfo.physio_firstname, physioInfo.physio_surname, teamInfo.team_name, teamInfo.team_location
FROM physio_info physioInfo, team teamInfo, team_physio teamPhysio
WHERE physioInfo.physio_id = teamPhysio.physio_id AND teamInfo.team_id = teamPhysio.team_id;

SELECT physio_email, physio_contact_number FROM physio_login JOIN physio_info 
USING (physio_id);


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
(1,'Mark','Sheppard', '1999-05-31', '30888802', ''),
(2,'Peter','Langford', '1994-03-17', '40858802', ''),
(3,'Christopher','Smith', '2002-01-05', '0860709331', '');

INSERT INTO player_stats(matches_played, matches_started, matches_off_the_bench, injury_prone, minutes_played, player_id) VALUES
(30,20,10,TRUE,2000,1),
(10,10,0,FALSE,700,3),
(14,1,13,TRUE,480,2);

/*INSERTS FOR THE PHYSIO TABLES*/
INSERT INTO physio_login(physio_email, physio_password)  VALUES
('physio@gmail.com', 'passwordphysio'),
('physio2@gmail.com', 'physiopassword3');

INSERT INTO physio_info(physio_firstname, physio_surname, physio_contact_number, physio_login_id) VALUES
('Jennie', 'Gray', '003537612678', 1 ),
('Booker', 'DeWitt', '+4467009312',2);

/*INSERTS FOR MANAGER*/
INSERT INTO manager_login(manager_email, manager_password) VALUES
('manager@gmail.com', 'passwordm');

INSERT INTO manager_info(manager_id,manager_firstname, manager_surname, manager_contact_number, manager_image) VALUES
(4,'Robert', 'Singer', '0871751842', '');


/*INSERTS FOR COACH*/
INSERT INTO coach_login(coach_email, coach_password) VALUES
('coach@gmail.com', 'passwordc'),
('coach2@gmai.com', 'cpassword');

INSERT INTO coach_info(coach_id, coach_firstname, coach_surname, coach_contact, coach_image) VALUES
(5,'Frank', 'Zappa', '0871751654', ''),
(6,'Marie', 'Smyth', '0870961234','');


/*INSERT INTO TEAM --- BECAREFUL WITH THIS AS MY ID AND YOURS COULD BE DIFFERENT*/
INSERT INTO team (team_name, manager_id, league_id, sport_id, team_location) VALUES
("Forkhill GFC", 4, 1,1, 'Forkhill South Armagh');

/*RELATIONAL INSERTS AGAIN MY ID AND YOURS COULD BE DIFFERENT SO THIS MAY NEED TO BE CHANGED ON YOUR END*/
INSERT INTO player_team (player_id, team_id, team_position, player_team_number, playing_status) VALUES
(1,3, 'Goalkeeper', 1, 'Match Fit'),
(2,3, 'Full Foward', 15, 'Match Fit'),
(3,3, 'Corner Back', 4, 'Injuried');

INSERT INTO team_coach (coach_id, team_id, team_role) VALUES
(5,3,'Offence'),
(6,3,'Defense');

INSERT INTO team_physio(team_id, physio_id) VALUES
(3,1),
(3,2);

INSERT INTO player_injuries(injury_id,date_of_injury, date_of_recovery, player_id) VALUES
('1', '2023-12-06', '2024-03-06', 1);


