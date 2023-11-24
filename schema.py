from pydantic import BaseModel


class LeagueBase(BaseModel):
    league_id : int
    league_name : str

