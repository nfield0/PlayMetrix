CREATE DATABASE playmetrix;
/*ALTER DATABASE playmetric RENAME TO playmetrix;*/

/*DROP TABLE league, manager_login, manager_info, sport, player_login, player_info, player_stats, physio_login, physio_info, team, team_physio, player_team*/

/*SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'player_info';*/



CREATE TABLE IF NOT EXISTS player_login
(
	player_login_id serial PRIMARY KEY,
	player_email VARCHAR(50) UNIQUE NOT NULL,
	player_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS player_info 
(
	player_id serial PRIMARY KEY,
	player_firstname VARCHAR(25) NOT NULL, 
	player_surname VARCHAR(25) NOT NULL,
	player_DOB DATE NOT NULL,
	player_contact_number VARCHAR(20),
	player_image bytea,
	player_login_id INT NOT NULL,
	FOREIGN KEY(player_login_id)
		REFERENCES player_login(player_login_id)
);

CREATE TABLE IF NOT EXISTS player_stats 
(
	player_stats_id serial PRIMARY KEY,
	matches_played INT NOT NULL, 
	matches_started INT NOT NULL,
	matches_off_the_bench INT NOT NULL, 
	injury_prone BOOLEAN NOT NULL,
	minutes_played INT NOT NULL,
	player_id INT NOT NULL,
	FOREIGN KEY(player_id)
		REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS manager_login
(
	manager_login_id serial PRIMARY KEY,
	manager_email VARCHAR (50) NOT NULL, 
	manager_password VARCHAR (150) NOT NULL
);

CREATE TABLE IF NOT EXISTS manager_info
(
	manager_id serial PRIMARY KEY,
	manager_firstname VARCHAR (25) NOT NULL, 
	manager_surname VARCHAR(25) NOT NULL,
	manager_contact_number VARCHAR(20) NOT NULL,
	manager_image bytea
);

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

CREATE TABLE IF NOT EXISTS physio_login
(
	physio_login_id serial PRIMARY KEY,
	physio_email VARCHAR(50) UNIQUE NOT NULL,
	physio_password VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS physio_info
(
	physio_id serial PRIMARY KEY,
	physio_firstname VARCHAR (30) NOT NULL,
	physio_surname VARCHAR (50) NOT NULL, 
	physio_contact_number VARCHAR(30) NOT NULL,
	physio_login_id INT NOT NULL,
	FOREIGN KEY(physio_login_id)
		REFERENCES physio_login(physio_login_id)
);

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


/*Need to be added when the relations are in */


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

CREATE TABLE IF NOT EXISTS  injuries
(
	injury_id serial PRIMARY KEY,
	injury_type VARCHAR(50),
	expected_recovery_time DATE,
	recovery_method VARCHAR(255)



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

INSERT INTO league(league_name)
VALUES ('division one');

select * from league;

INSERT INTO sport(sport_name) VALUES
('Gaelic Football'),
('Hurling'),
('Football'),
('Rugby'),
('Camogie'); 



/*BASIC QUERIES TO TEST ALL DATA*/

SELECT * FROM player_info;
SELECT * FROM player_injuries;
SELECT * FROM player_login; 
SELECT * FROM player_team;
SELECT * FROM player_stats;


/*MINOR ADJUSTMENT TO THE DATABASE ---- NATHAN YOU WILL NEED THESE*/

ALTER TABLE player_info 
ADD player_height VARCHAR(10),
ADD player_gender VARCHAR(20);

ALTER TABLE player_team 
RENAME position TO team_position;

ALTER TABLE player_team 
ADD player_team_number INT
ADD playing_status VARCHAR (25);


/*PLAYER QUERIES*/
SELECT player_surname, player_image FROM player_info;

SELECT player_firstname, player_surname, injury_type
FROM player_info 
JOIN player_injuries USING(player_id)
JOIN injuries USING(injury_id);

SELECT player_surname AS SURNAME, player_team_number AS KITNUM, team_position AS POSITION
FROM player_info 
JOIN player_team USING(player_id)
ORDER BY player_team_number ASC;

SELECT playerLogin.player_email, playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.position 
FROM player_login playerLogin, player_info playerInfo, player_stats playerStats, player_team playerTeam
WHERE playerLogin.player_login_id = playerInfo.player_login_id
AND playerInfo.player_id = playerStats.player_id 
AND playerInfo.player_id = playerTeam.player_id;

SELECT playerInfo.player_firstname, playerInfo.player_surname, playerStats.matches_played, playerTeam.position 
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