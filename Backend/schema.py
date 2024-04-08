from pydantic import BaseModel
from typing import Optional


class LeagueBase(BaseModel):
    league_name : str

class UserLoginBase(BaseModel):
    user_id: int
    user_type: str
    user_email: bool
    user_password: bool

class UserType(BaseModel):
    user_type: str
    user_email: str

class UserCreate(BaseModel):
    user_type: str
    user_email: str
    user_password: str
    user_2fa: bool

class User(BaseModel):
    user_email: str
    user_password: str

class User2FA(BaseModel):
    user_email: str
    user_2fa: bool

class ChangeUserPassword(BaseModel):
    user_email: str
    old_user_password: str
    new_user_password: str

class PlayerCreate(BaseModel):
    player_2fa: bool
    player_email: str
    player_password: str
    player_firstname: str 
    player_surname: str 
    player_dob: str 
    player_height: str
    player_gender: str
    player_contact_number: str
    player_image: Optional[bytes] = None

class SportBase(BaseModel):
    sport_name : str

class ManagerCreate(BaseModel):
    manager_2fa: bool
    manager_email: str
    manager_password: str
    manager_firstname: str 
    manager_surname: str 
    manager_contact_number: str
    manager_image: Optional[bytes] = None

class PhysioCreate(BaseModel):
    physio_email: str
    physio_password: str
    physio_firstname: str 
    physio_surname: str 
    physio_contact_number: str
    physio_image: Optional[bytes] = None
    physio_2fa: bool


class CoachCreate(BaseModel):
    coach_email: str
    coach_password: str
    coach_firstname: str
    coach_surname: str
    coach_contact: str
    coach_image: Optional[bytes] = None
    coach_2fa: bool


class Coach(BaseModel):
    coach_id: int
    coach_email: str
    coach_password: str
    coach_2fa: bool

class CoachInfo(BaseModel):
    coach_id: int
    coach_firstname: str
    coach_surname: str
    coach_contact: str
    coach_image: Optional[bytes] = None


class Manager(BaseModel):
    manager_id: int
    manager_email: str
    manager_password: str
    manager_2fa: bool

class ManagerInfo(BaseModel):
    manager_id: int
    manager_firstname: str
    manager_surname: str
    manager_contact_number: str
    manager_image: Optional[bytes] = None

class ManagerNoID(BaseModel):
    manager_email: str
    manager_password: str
    manager_firstname: str
    manager_surname: str
    manager_contact_number: str
    manager_image: Optional[bytes] = None
    manager_2fa: bool

class Physio(BaseModel):
    physio_id: int
    physio_email: str
    physio_password: str
    physio_2fa: bool
    
class PhysioInfo(BaseModel):
    physio_id: int
    physio_firstname: str
    physio_surname: str
    physio_contact_number: str
    physio_image: Optional[bytes] = None

class PhysioNoID(BaseModel):
    physio_email: str
    physio_password: str
    physio_firstname: str
    physio_surname: str
    physio_contact_number: str
    physio_image: Optional[bytes] = None
    physio_2fa: bool

class TeamBase(BaseModel):
    team_name: str
    team_logo: Optional[bytes] = None
    manager_id: int
    league_id: int
    sport_id: int
    team_location: str

class PlayerLogin(BaseModel):
    player_email: str
    player_password: str

class PlayerBase(BaseModel):
    player_id: int
    player_email: str
    player_password: str
    player_2fa: bool
    # player_firstname: str 
    # player_surname: str 
    # player_dob: str 
    # player_contact_number: str
    # player_image: bytes
    # matches_played: int
    # matches_started: int 
    # matches_off_the_bench: int
    # injury_prone: bool
    # minutes_played: int

class PlayerInfo(BaseModel):
    player_id: int
    player_firstname: str 
    player_surname: str 
    player_dob: str 
    player_contact_number: str
    player_image: Optional[bytes] = None
    player_height: str
    player_gender: str

class PlayerStat(BaseModel): 
    player_id: int
    matches_played: int
    matches_started: int
    matches_off_the_bench: int
    injury_prone: bool
    
class InjuryBase(BaseModel):
    injury_type: str
    injury_name_and_grade: str
    injury_location: str
    potential_recovery_method_1: str
    potential_recovery_method_2: str
    potential_recovery_method_3: str
    expected_minimum_recovery_time: int
    expected_maximum_recovery_time: int

class PlayerInjuryBaseNOID(BaseModel):
    player_id: int
    physio_id: int
    injury_id: int
    date_of_injury: str
    expected_date_of_recovery: str
    player_injury_report: Optional[bytes] = None

class PlayerInjuryBase(BaseModel):
    player_injury_id: int
    player_id: int
    physio_id: int
    injury_id: int
    date_of_injury: str
    expected_date_of_recovery: str
    player_injury_report: Optional[bytes] = None
    

class TeamPlayerBase(BaseModel):
    team_id: int
    player_id: int
    team_position: str
    player_team_number: int
    playing_status: str
    reason_for_status: str
    lineup_status: str

class TeamCoachBase(BaseModel):
    team_id: int
    coach_id: int
    team_role: str
    
class TeamPhysioBase(BaseModel):
    team_id: int
    physio_id: int
    
# class PhysioPlayerBase(BaseModel):
#     physio_id: int
#     player_id: int
#     player_injury_reports: Optional[bytes]

class TeamPlayerDelete(BaseModel):
    team_id: int
    player_id: int

class ScheduleBase(BaseModel):
    schedule_id: int
    schedule_title: str
    schedule_location: str
    schedule_type: str
    schedule_start_time: str
    schedule_end_time: str
    schedule_alert_time: str

class PlayerScheduleBase(BaseModel):
    schedule_id: int
    player_id: int
    player_attending: Optional[bool]

class ScheduleBaseNoID(BaseModel):
    schedule_title: str
    schedule_location: str
    schedule_type: str
    schedule_start_time: str
    schedule_end_time: str
    schedule_alert_time: str
    team_id: int


class TeamScheduleBase(BaseModel):
    schedule_id: int
    team_id: int
    #schedule_date: str

class AnnouncementBase(BaseModel):
    announcements_id: int
    announcements_title: str
    announcements_desc: str
    announcements_date: str
    schedule_id: int
    poster_id: int
    poster_type: str

class AnnouncementBaseNoID(BaseModel):
    announcements_title: str
    announcements_desc: str
    announcements_date: str
    schedule_id: int
    poster_id: int
    poster_type: str

class NotificationBase(BaseModel):
    notification_title: str
    notification_type: str
    notification_date: str
    notification_desc: str
    team_id: int
    user_type: str

class MatchBase(BaseModel):
    player_id: int
    schedule_id: int
    minutes_played: int


