from pydantic import BaseModel


class LeagueBase(BaseModel):
    league_id : int
    league_name : str

class UserCreate(BaseModel):
    user_type: str
    user_email: str
    user_password: str

