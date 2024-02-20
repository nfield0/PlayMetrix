CREATE DATABASE playmetrix;

/*
DROP TABLE 
player_login, player_info, player_stats,
manager_login, manager_info,
coach_login, coach_info,
physio_login, physio_info,
sport, league, team, 
injuries, team_physio, player_team, team_coach, player_physio,
player_injuries, schedule, player_schedule, team_schedule,
announcements, notifications;
*/


/* Tables For the Main Users of the Database */
/*PLAYER TABLES*/
CREATE TABLE IF NOT EXISTS player_login
(
	player_id serial PRIMARY KEY,
	player_email VARCHAR(280) UNIQUE NOT NULL,
	player_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS player_info 
(
	player_id INT NOT NULL PRIMARY KEY,
	player_firstname VARCHAR(25) NOT NULL, 
	player_surname VARCHAR(280) NOT NULL,
	player_DOB DATE NOT NULL,
	player_contact_number VARCHAR(280),
    player_height VARCHAR(10),
    player_gender VARCHAR(280),
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



/*CREATE TABLE IF NOT EXISTS player_stats 
(
	player_id INT NOT NULL PRIMARY KEY,
	matches_played INT NOT NULL, 
	matches_started INT NOT NULL,
	matches_off_the_bench INT NOT NULL, 
	total_attempts INT ,
	total_points_scored INT,
	total_goals_scored INT ,
	total_misses INT, 
	toal_passes INT,
	total_kick_passes INT,
	total_hand_passes INT,
	injury_prone BOOLEAN NOT NULL,
	minutes_played INT NOT NULL,
	FOREIGN KEY(player_id)
		REFERENCES player_info(player_id)
);*/

/*MANAGER TABLES*/
CREATE TABLE IF NOT EXISTS manager_login
(
	manager_id serial PRIMARY KEY,
	manager_email VARCHAR (280) NOT NULL, 
	manager_password VARCHAR (150) NOT NULL
);

CREATE TABLE IF NOT EXISTS manager_info
(
	manager_id INT NOT NULL PRIMARY KEY,
	manager_firstname VARCHAR (25) NOT NULL, 
	manager_surname VARCHAR(280) NOT NULL,
	manager_contact_number VARCHAR(280),
	manager_image bytea,
	FOREIGN KEY (manager_id)
		REFERENCES manager_login(manager_id)
);

/*COACHES TABLE*/
CREATE TABLE IF NOT EXISTS coach_login
(

	coach_id serial PRIMARY KEY,
	coach_email VARCHAR (280) NOT NULL,
	coach_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS coach_info
(
	coach_id INT NOT NULL PRIMARY KEY,
	coach_firstname VARCHAR(25) NOT NULL,
	coach_surname VARCHAR(280) NOT NULL,
	coach_contact VARCHAR(280) NOT NULL,
	coach_image bytea,
	FOREIGN KEY (coach_id)
		REFERENCES coach_login(coach_id)
);

/*PHYSIO TABLES*/
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
	physio_surname VARCHAR (280) NOT NULL, 
	physio_contact_number VARCHAR(280) NOT NULL,
	physio_image bytea,
	FOREIGN KEY(physio_id)
		REFERENCES physio_login(physio_id)
);

/*Tables Needed for the Team Information*/
/*SPORT*/
CREATE TABLE IF NOT EXISTS sport
(
	sport_id serial PRIMARY KEY,
	sport_name VARCHAR(30)
);

/*League*/
CREATE TABLE IF NOT EXISTS league
(
	league_id serial PRIMARY KEY,
	league_name VARCHAR (50)
);

/*Team Tables*/
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


/*These Tables can be added at anytime after the main tables above are added in the database*/


/*Tables Relating to Injuries*/
CREATE TABLE IF NOT EXISTS  injuries
(
	injury_id serial PRIMARY KEY,
	injury_type VARCHAR(50),
    injury_location VARCHAR(20),
	recovery_method VARCHAR(255),
    expected_recovery_time VARCHAR(70)
);


/*TABLES RELATING TO THE TEAM*/
CREATE TABLE IF NOT EXISTS player_physio
(
	player_id INT NOT NULL,
	physio_id INT NOT NULL, 
	report_id serial PRIMARY KEY,
	player_injury_reports bytea,
	FOREIGN KEY (player_id) 
		REFERENCES player_info (player_id),
	FOREIGN KEY (physio_id)
		REFERENCES physio_info(physio_id)
);


CREATE TABLE IF NOT EXISTS player_injuries 
(
	report_id INT,
	injury_id INT NOT NULL,
	date_of_injury DATE NOT NULL, 
	date_of_recovery DATE NOT NULL,
	player_id INT NOT NULL,
	FOREIGN KEY (report_id)
		REFERENCES player_physio(report_id), 
	FOREIGN KEY(injury_id)
		REFERENCES injuries(injury_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id),
	FOREIGN KEY(report_id)
		REFERENCES player_physio(report_id)
);

CREATE TABLE IF NOT EXISTS team_physio
(
	team_id INT NOT NULL,
	physio_id INT NOT NULL, 
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

CREATE TABLE IF NOT EXISTS team_coach 
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


/*TABLES RELEATING TO SCHEDULE AND ANNOUNCEMENTS*/
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

CREATE TABLE IF NOT EXISTS player_schedule
(
	schedule_id INT NOT NULL,
	player_id INT NOT NULL,
	player_attending BOOLEAN,
	PRIMARY KEY (schedule_id, player_id),
	FOREIGN KEY (schedule_id)
		REFERENCES schedule(schedule_id),
	FOREIGN KEY (player_id)
		REFERENCES player_info(player_id)

);

CREATE TABLE IF NOT EXISTS team_schedule
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
    schedule_id INT NOT NULL,
    poster_id INT NOT NULL,
    poster_type VARCHAR(50),
  FOREIGN KEY (schedule_id)
   REFERENCES schedule (schedule_id)
);

/*Notifications Table*/
CREATE TABLE IF NOT EXISTS notifications
(
	notification_id serial PRIMARY KEY,
	notification_title VARCHAR(200) NOT NULL,
	/*notification_type VARCHAR(50),*/
	notification_date TIMESTAMP,
	notification_desc VARCHAR(255),
	team_id INT NOT NULL,
	user_type VARCHAR(50),
	FOREIGN KEY (team_id)
		REFERENCES team(team_id)
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

INSERT INTO injuries (injury_type, injury_location, recovery_method, expected_recovery_time) 
VALUES
('Rotar Cuff','Shoulder','Rest, Physiotherapy, Surgery Depedning on Severity', '6 Weeks - 9 Months'),
('Shoulder Impingement','Shoulder','Physiotherapy', '3- 6 Months'),
('Instability','Shoulder','Physiotherapy', '3-6 Months Should not lift heavy weight between 6 weeks - 3 Months'),
('Shoulder Dislocation','Shoulder','Closed Reduction & Rest', '12-16 Weeks'),
('Runners Knee','Knee','Rest & Icing Your Knee', '4-6 Weeks'),
('Kneecap Fractures','Knee','Physiotherapy, Occupational Therapy Surgery', '3-6 Months for a Full Recovery'),
('Knee Dislocation','Knee','Rest, Knee Exercises', '6-8 Weeks'),
('Torn ligament','Knee','Knee Exercises, Rest', 'Grade 1: 4-6 Weeks Grade 2: 6-10 Weeks Grade 3: Surgery'),
('Meniscal Tear','Knee','Rest, Ice, Compression & Elevation', '4-12 Weeks'),
('Tendon Tear','Knee','Knee Brace for 6-12 Weeks, Physiotherapy', '5-8 Months'),
('Groin Pull','Leg','Rest, Light Exercise', '4-8 Weeks'),
('Hamstring Strain','Leg','Rest, Ice, Compression & Elevation', '3-8 Weeks Grade 3: 3 Months'),
('Shin Splints','Leg','Rest, Ice, Compression & Elevation', '2-4 Weeks'),
('Ankle Sprain','Ankle','Rest, Ice, Compression & Elevation', '8-12 Weeks'),
('Achilles Tendinitis','Ankle','Rest, Ice, Compression & Elevation', '12 Weeks'),
('Anterior Cruicate Ligament','Knee','Surgery, Rehab', 'Up to a Year'),
('Concussion','Head','Rest', '2 Weeks'),
('Overuse Injuries','Anywhere','Rest, Physiotherapy', 'Weeks to Months (Depending on Serverity)'),
('Broken Foot','Foot','Rest, Physiotherapy', '3-6 Months'),
('Broken Arm','Arm','Rest, Immobilisation', '6 -8 Weeks'),
('Broken Leg','Leg','Rest, Immobilisation, Potential for Surgery if Serere', '6-8 Weeks More serious fracture 3-6 Months'),
('Torn Quad Muscle','Leg','Rest, Ice, Compression, Elevation, Physiotherapy', '3-6 Months for a Full Recovery 10-12 Weeks before healing begins'),
('Torn Calf Muscle','Leg','Rest, Ice, Compression, Elevation, Physiotherapy', '2-4 Weeks'),
('Torn Abbuctor ','Leg','Rest, Ice, Compression, Elevation, Physiotherapy', '12-16 Weeks');









