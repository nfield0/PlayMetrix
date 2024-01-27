from typing import Union, Annotated
from sqlalchemy import Column, Integer, String, Text, Date, LargeBinary, Boolean
from database import Base


# class Item(BaseModel):
#     name: str
#     price: float
#     is_offer: Union[bool, None] = None

class player_login(Base):
	__tablename__ = "player_login"
	player_id = Column(Integer, primary_key = True, index = True)
	player_email = Column(String(50), index = True, unique = True)
	player_password = Column(String(150), index = True)

class player_info(Base): 
	__tablename__ = "player_info"
	player_id = Column(Integer, primary_key = True, index = True)
	player_firstname = Column(String(25), index= True) 
	player_surname = Column(String(25), index= True) 
	player_dob = Column(Date, index= True) 
	player_contact_number = Column(String(20), index= True)
	player_image = Column(LargeBinary, index= True)
	player_height = Column(String(10))
	player_gender = Column(String(20))   

class player_injuries(Base): 
    __tablename__ = "player_injuries"
    injury_id = Column(Integer, primary_key = True, index = True)
    date_of_injury = Column(Date, index = True)
    date_of_recovery = Column(Date, index = True)
    player_id = Column(Integer, index = True)

class injuries(Base): 
    __tablename__ = "injuries"
    injury_id = Column(Integer, primary_key = True, index = True)
    injury_type = Column(String(50), index = True)
    expected_recovery_time = Column(String(50), index = True)
    recovery_method = Column(String(255), index = True)

class player_stats(Base):
	__tablename__ = "player_stats"
	player_id = Column(Integer, primary_key = True, index = True)
	matches_played = Column(Integer, index = True)
	matches_started = Column(Integer, index = True)
	matches_off_the_bench = Column(Integer, index = True)
	injury_prone = Column(Boolean, index = True)
	minutes_played = Column(Integer, index = True)

class manager_login(Base):
    __tablename__ = "manager_login"
    manager_id = Column(Integer, primary_key = True, index = True)
    manager_email = Column(String(50), index= True)
    manager_password = Column(String(150), index= True)

class manager_info(Base):
    __tablename__ = "manager_info"
    manager_id = Column(Integer, primary_key = True, index = True)
    manager_firstname = Column(String(25), index= True)
    manager_surname = Column(String(25), index= True)
    manager_contact_number = Column(String(20), index= True)
    manager_image = Column(LargeBinary, index= True)

class sport(Base):
    __tablename__ = "sport"
    sport_id = Column(Integer, primary_key = True, index = True)
    sport_name = Column(String(30), index= True)
    
class league(Base):
	__tablename__ = "league"
	league_id = Column(Integer, primary_key = True, index = True)
	league_name = Column(String(50), index = True, unique = True)

	

class team(Base):
	__tablename__ = "team"
	team_id = Column(Integer, primary_key = True, index = True)
	team_name = Column(String(100), index = True, unique = True)
	team_logo = Column(LargeBinary)
	manager_id = Column(Integer, index = True)
	league_id = Column(Integer, index = True)
	sport_id = Column(Integer, index = True)
	team_location = Column(String(30))

class physio_login(Base):
	__tablename__ = "physio_login"
	physio_id = Column(Integer, primary_key = True, index = True)
	physio_email = Column(String(50), index = True, unique = True)
	physio_password = Column(String(150), index = True)
 
class physio_info(Base):
	__tablename__ = "physio_info"
	physio_id = Column(Integer, primary_key = True, index = True)
	physio_firstname = Column(String(25), index = True)
	physio_surname = Column(String(25), index = True)
	physio_contact_number = Column(String(20), index = True)
	physio_image = Column(LargeBinary, index = True)

class team_physio(Base):
	__tablename__ = "team_physio"
	physio_id = Column(Integer, primary_key = True, index = True)
	team_id = Column(Integer, primary_key = True, index = True)
 
class team_player(Base):
	__tablename__ = "player_team"
	player_id = Column(Integer, primary_key = True, index = True)
	team_id = Column(Integer, primary_key = True, index = True)
	team_position = Column(String(30), index = True)
	player_team_number = Column(Integer, index = True)
	playing_status = Column(String(25), index = True)
	lineup_status = Column(String(30), index = True)

class team_coach(Base):
	__tablename__ = "team_coach"
	coach_id = Column(Integer, primary_key = True, index = True)
	team_id = Column(Integer, primary_key = True, index = True)
	team_role = Column(String(255), index = True)

class coach_login(Base):
	__tablename__ = "coach_login"
	coach_id = Column(Integer, primary_key = True, index = True)
	coach_email = Column(String(50), index = True, unique = True)
	coach_password = Column(String(150), index = True)

class coach_info(Base):
	__tablename__ = "coach_info"
	coach_id = Column(Integer, primary_key = True, index = True)
	coach_firstname = Column(String(25), index = True)
	coach_surname = Column(String(25), index = True)
	coach_contact = Column(String(25), index = True)
	coach_image = Column(LargeBinary, index = True)



class schedule(Base):
	__tablename__ = "schedule"
	schedule_id = Column(Integer, primary_key = True, index = True)
	schedule_title = Column(String(50), index = True)
	schedule_location = Column(String(50), index = True)
	schedule_type = Column(String(100), index = True)
	schedule_start_time = Column(String(10), index = True)
	schedule_end_time = Column(String(10), index = True)
	schedule_alert_time = Column(String(50), index = True)

class player_schedule(Base):
	__tablename__ = "player_schedule"
	schedule_id = Column(Integer, primary_key = True, index = True)
	player_id = Column(Integer, primary_key = True, index = True)
	player_attending = Column(Boolean, index = True)

class team_schedule(Base):
	__tablename__ = "team_schedule"
	schedule_id = Column(Integer, primary_key = True, index = True)
	team_id = Column(Integer, primary_key = True, index = True)
	#schedule_date = Column(Date, index = True)


class announcements(Base):
	__tablename__ = "announcements"
	announcements_id = Column(Integer, primary_key = True, index = True)
	announcements_title = Column(String(100), index = True)
	announcements_desc = Column(String(255), index = True)
	announcements_date = Column(Date, index = True)
	manager_id = Column(Integer, index = True)
	schedule_id = Column(Integer, index = True)


