from pydantic import BaseModel


class LeagueBase(BaseModel):
    league_id : int
    league_name : str

class UserCreate(BaseModel):
    user_type: str
    user_email: str
    user_password: str

class Manager(BaseModel):
    manager_login_id: int
    manager_email: str
    manager_password: str
    manager_firstname: str
    manager_surname: str
    manager_contact_number: str
    manager_image: bytes

class TeamBase(BaseModel):
    team_name: str
    team_logo: bytes
    manager_id: int
    league_id: int
    sport_id: int
    team_location: str
