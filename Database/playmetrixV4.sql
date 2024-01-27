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
	schedule_title VARCHAR(50),
	schedule_location VARCHAR(50),
	schedule_type VARCHAR (100),
	schedule_start_time TIMESTAMP,
	schedule_end_time TIMESTAMP,
	schedule_alert_time VARCHAR(50)
);

CREATE TABLE player_schedule
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

CREATE TABLE team_schedule
(
    schedule_id INT NOT NULL,
    team_id INT NOT NULL,
    PRIMARY KEY (schedule_id, team_id),
    FOREIGN KEY (schedule_id)
        REFERENCES schedule(schedule_id),
    FOREIGN KEY (team_id)
        REFERENCES team(team_id)
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
  FOREIGN KEY (schedule_id)
   REFERENCES schedule (schedule_id)
);

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