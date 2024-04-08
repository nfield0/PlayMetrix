from sqlalchemy.orm import Session
from models import *
from database import SessionLocal, Base, engine
from fastapi import Depends, FastAPI, HTTPException, Response
from fastapi.responses import RedirectResponse
from schema import *
import Crud.crud as crud
import pytest
from sqlalchemy.orm import sessionmaker
from tavern.core import run
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from schema import NotificationBase
import os
from fastapi.security import OAuth2PasswordBearer
import requests
import jwt
from Crud.user import get_user_details_by_email, check_user_exists_by_email, change_2fa_option

Base.metadata.create_all(bind=engine)

app = FastAPI()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

### SETUP WITH CODE BELOW ###

# ctrl+shift+p in vscode to create venv

# .venv/scripts/activate
        
        
## To install requirements
# python -m pip install -r requirements.txt

## Requires .env file in root directory that uses DB_CONNECTION that matches postgresql database details!

## To Run Uvicorn in Root directory
# python -m uvicorn Backend.main:app --reload


### Testing Code ###

## For Interactive Documentation (Swagger UI)
# http://127.0.0.1:8000/docs
# /redoc for ReDoc Documentation

## For testing
# python -m pytest

2
GOOGLE_CLIENT_ID =  os.getenv("CLIENT_ID")
GOOGLE_CLIENT_SECRET =  os.getenv("CLIENT_SECRET")
GOOGLE_REDIRECT_URI = os.getenv("REDIRECT_URI")

@app.get("/login/google")
async def login_google():
    return {
        "url": f"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id={GOOGLE_CLIENT_ID}&redirect_uri={GOOGLE_REDIRECT_URI}&scope=openid%20profile%20email&access_type=offline"
    }
    #return RedirectResponse(url="https://accounts.google.com/o/oauth2/auth?response_type=code&client_id={GOOGLE_CLIENT_ID}&redirect_uri={GOOGLE_REDIRECT_URI}&scope=openid%20profile%20email&access_type=offline")


@app.get("/auth/google")
async def auth_google(code: str, db: Session = Depends(get_db)):
    token_url = "https://accounts.google.com/o/oauth2/token"
    data = {
        "code": code,
        "client_id": GOOGLE_CLIENT_ID,
        "client_secret": GOOGLE_CLIENT_SECRET,
        "redirect_uri": GOOGLE_REDIRECT_URI,
        "grant_type": "authorization_code",
    }
    response = requests.post(token_url, data=data)
    access_token = response.json().get("access_token")
    user_info = requests.get("https://www.googleapis.com/oauth2/v1/userinfo", headers={"Authorization": f"Bearer {access_token}"})
    print(user_info.json().get("email"))

    if user_info.json().get("email") == None:
        return {"error": "Invalid email"}
    elif check_user_exists_by_email(db, user_info.json().get("email")):
        return get_user_details_by_email(db, user_info.json().get("email"))
    else:
        return {"error": "User does not exist"}

@app.get("/users")
async def get_users(email: str, db: Session = Depends(get_db)):
    return crud.get_user_details_by_email(db, email)




@app.get("/token")
async def get_token(token: str = Depends(oauth2_scheme)):
    return jwt.decode(token, GOOGLE_CLIENT_SECRET, algorithms=["HS256"])



@app.get("/")
def read_root():
    return {"message:", "Landing Page"}


#region authentication and registration

# @app.post("/register")
# def register_user(user: UserCreate, db: Session = Depends(get_db)):
#     return crud.register_user(db, user)

@app.post("/users")
def get_user_by_email(user: UserType, db:Session = Depends(get_db)):
    return crud.get_user_by_type(db, user)

@app.post("/register_player")
def register_player(user: PlayerCreate, db: Session = Depends(get_db)):
    return crud.register_player(db, user)

@app.post("/register_manager")
def register_manager(user: ManagerCreate, db: Session = Depends(get_db)):
    return crud.register_manager(db, user)

@app.post("/register_physio")
def register_physio(user: PhysioCreate, db: Session = Depends(get_db)):
    return crud.register_physio(db, user)

@app.post("/register_coach")
def register_physio(user: CoachCreate, db: Session = Depends(get_db)):
    return crud.register_coach(db, user)
    

@app.post("/login")
def login_user(user: User, db: Session = Depends(get_db)):
    return crud.login(db, user)

@app.put("/change_password")
def change_password(user: ChangeUserPassword, db: Session = Depends(get_db)):
    return crud.change_password(db, user)    

@app.put("/update_two_factor")
def change_2fa_opt(user: User2FA, db: Session = Depends(get_db)):
    return crud.change_2fa_option(db, user)


@app.get("/logout")
def logout():
  # clear tokens
  SessionLocal.close_all()
  return RedirectResponse(url="/login"), HTTPException(status_code=200)

@app.post("/check_email_exists")
def check_email_exists(email: str, db: Session = Depends(get_db)):
    return crud.check_user_exists_by_email(db, email)

#endregion

#region managers


@app.get("/managers")
def read_managers(db:Session = Depends(get_db)):
    return crud.get_all_managers_login(db)

@app.get("/managers/{id}")
def read_managers(id: int, db:Session = Depends(get_db)):
    return crud.get_all_manager_info_by_id(db, id)

@app.put("/managers/{id}")
def update_managers(manager: ManagerNoID, id: int,  db:Session = Depends(get_db)):
    return crud.update_manager_by_id(db=db, id=id, manager=manager)

@app.put("/managers/login/{id}")
def update_managers(manager: Manager, id: int,  db:Session = Depends(get_db)):
    return crud.update_manager_login_by_id(db=db, id=id, manager=manager)

@app.put("/managers/info/{id}")
def update_managers_info(manager: ManagerInfo, id: int,  db:Session = Depends(get_db)):
    return crud.update_manager_info_by_id(db=db, id=id, manager=manager)

@app.delete("/managers/{id}")
def delete_manager(id, db:Session = Depends(get_db)):
    return crud.delete_manager_by_id(db, id)

@app.delete("/managers")
def delete_manager_by_email(email: str, db:Session = Depends(get_db)):
    return crud.delete_manager_by_email(db, email)



#endregion

#region teams


@app.get("/teams")
def read_teams(db:Session = Depends(get_db)):
    return crud.get_teams(db)

@app.get("/teams/{id}")
def read_team(id: int, db:Session = Depends(get_db)):
    return crud.get_team_by_id(db, id)

@app.post("/teams")
def insert_team(team: TeamBase, db:Session = Depends(get_db)):
    return crud.insert_new_team(db, team)

@app.put("/teams/{id}")
def update_team(id: int, team: TeamBase, db:Session = Depends(get_db)):
    return crud.update_team(db, team, id)

@app.delete("/teams/{id}")
def delete_team(id: int, db:Session = Depends(get_db)):
    return crud.delete_team_by_id(db, id)



#endregion


#region schedules

@app.get("/schedules")
def read_schedules(db:Session = Depends(get_db)):
    return crud.get_schedules(db)

@app.get("/schedules/{team_id}/type/{type}")
def read_schedules(team_id: int, type: str, db:Session = Depends(get_db)):
    return crud.get_team_schedules_by_type(db, type, team_id)

@app.get("/schedules/{team_id}/date/{date}")
def read_schedules(team_id: int, date: str, db:Session = Depends(get_db)):
    return crud.get_team_schedules_by_date(db, team_id, date)

@app.get("/schedules/{team_id}/location/{location}")
def read_schedules(team_id: int, location: str, db:Session = Depends(get_db)):
    return crud.get_team_schedules_by_location(db, team_id, location)

@app.get("/schedules/{id}")
def read_schedule(id: int, db:Session = Depends(get_db)):
    return crud.get_schedule_by_id(db, id)

@app.post("/schedules")
def insert_schedule(schedule: ScheduleBaseNoID, db:Session = Depends(get_db)):
    return crud.insert_new_schedule(db, schedule)

@app.put("/schedules/{id}")
def update_schedule(id: int, schedule: ScheduleBase, db:Session = Depends(get_db)):
    return crud.update_schedule(db, schedule, id)

@app.delete("/schedules/{id}")
def delete_schedule(id: int, db:Session = Depends(get_db)):
    return crud.delete_schedule_by_id(db, id)

#team schedules

@app.get("/team_schedules/{team_id}")
def read_team_schedules(team_id: int, db:Session = Depends(get_db)):
    return crud.get_team_schedules(db, team_id)

@app.get("/team_schedules/{id}")
def read_team_schedule(id: int, db:Session = Depends(get_db)):
    return crud.get_team_schedule_by_id(db, id)

# now redundant
@app.post("/team_schedules")
def insert_team_schedule(schedule: TeamScheduleBase, db:Session = Depends(get_db)):
    return crud.insert_new_team_schedule(db, schedule)

@app.put("/team_schedules/{id}")
def update_team_schedule(id: int, schedule: TeamScheduleBase, db:Session = Depends(get_db)):
    return crud.update_team_schedule(db, schedule, id)

@app.delete("/team_schedules/{id}")
def delete_team_schedule(id: int, db:Session = Depends(get_db)):
    return crud.delete_team_schedule_by_id(db, id)

#endregion

#region player_schedules

@app.get("/player_schedules/{schedule_id}")
def read_player_schedules(schedule_id: int, db:Session = Depends(get_db)):
    return crud.get_player_schedules(db, schedule_id)

@app.post("/player_schedules")
def insert_player_schedule(schedule: PlayerScheduleBase, db:Session = Depends(get_db)):
    return crud.insert_new_player_schedule(db, schedule)

@app.put("/player_schedules/{player_id}")
def update_player_schedule(player_id: int, schedule: PlayerScheduleBase, db:Session = Depends(get_db)):
    return crud.update_player_schedule(db, schedule, player_id)

@app.delete("/player_schedules/{player_id}/schedule/{schedule_id}")
def delete_player_schedule(player_id: int, schedule_id: int, db:Session = Depends(get_db)):
    return crud.delete_player_schedule_by_id(db, player_id, schedule_id)


#endregion

#region announcements

@app.get("/announcements/{id}")
def read_announcement(id: int, db:Session = Depends(get_db)):
    return crud.get_announcement(db, id)

@app.get("/announcements/schedule/{id}")
def read_announcement(id: int, db:Session = Depends(get_db)):
    return crud.get_announcement(db, id)

@app.post("/announcements")
def insert_announcement(announcement: AnnouncementBaseNoID, db:Session = Depends(get_db)):
    return crud.insert_new_announcement(db, announcement)

@app.put("/announcements/{id}")
def update_announcement(id: int, announcement: AnnouncementBase, db:Session = Depends(get_db)):
    return crud.update_announcement(db, announcement, id)

@app.delete("/announcements/{id}")
def delete_announcement(id: int, db:Session = Depends(get_db)):
    return crud.delete_announcement_by_id(db, id)



#endregion

#region players


@app.get("/players")
def read_players(db:Session = Depends(get_db)):
    return crud.get_players(db)

@app.get("/players/{id}")
def read_player(id: int, db:Session = Depends(get_db)):
    return crud.get_player_by_id(db, id)

@app.get("/players/stats/{id}")
def read_player(id: int, db:Session = Depends(get_db)):
    return crud.get_player_stats_by_id(db, id)

@app.get("/players/info/{id}")
def read_player(id: int, db:Session = Depends(get_db)):
    return crud.get_player_info_by_id(db, id)

@app.post("/players/info/{id}")
def read_player(id: int, db:Session = Depends(get_db)):
    return crud.create_player_info_by_id(db, id)

# @app.post("/players/")
# def insert_player(player: PlayerBase, db:Session = Depends(get_db)):
#     return crud.insert_new_player(db, player)

@app.put("/players/login/{id}")
def update_player_login(id: int, player: PlayerBase, db:Session = Depends(get_db)):
    return crud.update_player_by_id(db, player, id)

@app.put("/players/info/{id}")
def update_player_info(id: int, player: PlayerInfo, db:Session = Depends(get_db)):
    return crud.update_player_info_by_id(db, player, id)

@app.put("/players/stats/{id}")
def update_player_stats(id: int, player: PlayerStat, db:Session = Depends(get_db)):
    return crud.update_player_stat_by_id(db, player, id)

@app.delete("/players/{id}")
def delete_player(id: int, db:Session = Depends(get_db)):
    return crud.delete_player(db, id)

@app.delete("/players/")
def delete_player_email(email: str, db:Session = Depends(get_db)):
    return crud.delete_player_by_email(db, email)


# @app.put("/players/stats/{id}/minutes_played/{minutes_played}")
# def update_minutes_played(id: int, minutes_played: int, db:Session = Depends(get_db)):
#     return crud.update_minutes_played(db, minutes_played, id)



#endregion

#region physio
@app.get("/physio")
def read_physios(db:Session = Depends(get_db)):
    return crud.get_all_physios(db)

@app.get("/physio/{id}")
def read_physio(id: int, db:Session = Depends(get_db)):
    return crud.get_physio_login_by_id(db, id)

@app.get("/physio/info/{id}")
def read_physio_with_info(id: int, db:Session = Depends(get_db)):
    return crud.get_physio_with_info_by_id(db, id)

@app.put("/physio/{id}")
def update_physio(id: int, physio: PhysioNoID, db:Session = Depends(get_db)):
    return crud.update_physio_by_id(db, physio, id)

@app.put("/physio/login/{id}")
def update_physio_login(id: int, physio: Physio, db:Session = Depends(get_db)):
    return crud.update_physio_login_by_id(db, physio, id)

@app.put("/physio/info/{id}")
def update_physio_info(id: int, physio: PhysioInfo, db:Session = Depends(get_db)):
    return crud.update_physio_info_by_id(db, physio, id)

@app.delete("/physio/{id}")
def delete_physio(id: int, db:Session = Depends(get_db)):
    return crud.delete_physio_by_id(db, id)





#endregion

#region coaches

@app.get("/coaches")
def read_coaches(db:Session = Depends(get_db)):
    return crud.get_all_coaches(db)

@app.get("/coaches/{id}")
def read_coach(id: int, db:Session = Depends(get_db)):
    return crud.get_coach_login_by_id(db, id)

@app.get("/coaches/info/{id}")
def read_coach_with_info(id: int, db:Session = Depends(get_db)):
    return crud.get_coach_with_info_by_id(db, id)

@app.put("/coaches/{id}")
def update_coach(id: int, coach: CoachCreate, db:Session = Depends(get_db)):
    return crud.update_coach_by_id(db, coach, id)

@app.put("/coaches/login/{id}")
def update_coach_login(id: int, coach: Coach, db:Session = Depends(get_db)):
    return crud.update_coach_login_by_id(db, coach, id)

@app.put("/coaches/info/{id}")
def update_coach_info(id: int, coach: CoachInfo, db:Session = Depends(get_db)):
    return crud.update_coach_info_by_id(db, coach, id)


@app.delete("/coaches/{id}")
def delete_coach(id: int, db:Session = Depends(get_db)):
    return crud.delete_coach_by_id(db, id)


#endregion

#region team_coaches

@app.get("/coaches_team/{coach_id}")
def read_team_coaches(coach_id: int, db:Session = Depends(get_db)):
    return crud.get_team_coaches(db, coach_id)

@app.get("/team_coach/{team_id}")
def read_team_coach(team_id: int, db:Session = Depends(get_db)):
    return crud.get_coach_by_team_id(db, team_id)

@app.post("/team_coach")
def insert_team_coach(team_coach: TeamCoachBase, db:Session = Depends(get_db)):
    return crud.insert_team_coach_by_team_id(db, team_coach)

@app.put("/team_coach/{team_id}")
def update_team_coach(team_id: int, team_coach: TeamCoachBase, db:Session = Depends(get_db)):
    return crud.update_team_coach_by_team_id(db, team_coach, team_id)

@app.delete("/team_coach/{team_id}/{coach_id}")
def delete_coach_team_id(team_id: int, coach_id:int, db:Session = Depends(get_db)):
    return crud.delete_team_coach_by_team_id(db, team_id, coach_id)




#endregion


#region team_physio

@app.get("/physios_team/{physio_id}")
def read_team_phyiso(physio_id: int, db:Session = Depends(get_db)):
    return crud.get_team_physio(db, physio_id)

@app.get("/team_physio/{team_id}")
def read_team_physio(team_id: int, db:Session = Depends(get_db)):
    return crud.get_physio_by_team_id(db, team_id)

# @app.get("/team_physio/{team_id}/physio/{physio_id}")
# def read_team_physio(physio_id, team_id: int, db:Session = Depends(get_db)):
#     return crud.get_physio_by_team_id(db, team_id, physio_id)

@app.post("/team_physio")
def insert_team_physio(team_physio: TeamPhysioBase, db:Session = Depends(get_db)):
    return crud.insert_team_physio_by_team_id(db, team_physio)

# @app.put("/team_physio/{id}")
# def update_team_physio(physio_id: int, team_id: int, db:Session = Depends(get_db)):
#     return crud.update_team_physio_by_team_id(db, team_id, physio_id)


#may prove redundant
@app.delete("/team_physio/{team_id}")
def delete_physio_team_id(team_id: int, db:Session = Depends(get_db)):
    return crud.delete_physio_team_id(db, team_id)

@app.delete("/team_physio/{teams_id}/physio/{physios_id}")
def delete_physio_team_id(teams_id: int, physios_id:int, db:Session = Depends(get_db)):
    return crud.delete_physio_from_team(db, teams_id, physios_id)

#endregion

# @app.get("/player_physio/{player_id}")
# def read_player_physio(player_id: int, db:Session = Depends(get_db)):
#     return crud.get_physio_by_player_id(db, player_id)

# @app.post("/player_physio")
# def insert_player_physio(player_physio: PhysioPlayerBase, db:Session = Depends(get_db)):
#     return crud.insert_player_physio(db, player_physio)





#region team_player

@app.get("/players_team/{player_id}")
def read_team_players(player_id: int, db:Session = Depends(get_db)):
    return crud.get_team_players(db, player_id)

@app.get("/team_player/{team_id}")
def read_team_player(team_id: int, db:Session = Depends(get_db)):
    return crud.get_players_by_team_id(db, team_id)

@app.post("/team_player")
def add_team_player(team_player: TeamPlayerBase, db:Session = Depends(get_db)):
    return crud.add_player_to_team(db, team_player)

@app.put("/team_player")
def update_team_player(team_player: TeamPlayerBase, db:Session = Depends(get_db)):
    return crud.update_player_on_team(db, team_player)

@app.delete("/team_player/{team_id}/{player_id}")
def delete_team_player(team_id: int, player_id: int, db:Session = Depends(get_db)):
    return crud.delete_player_from_team(db, player_id, team_id)


#endregion


#region injuries

@app.get("/injuries")
def read_injuries(db:Session = Depends(get_db)):
    return crud.get_injuries(db)

@app.get("/injuries/{id}")
def read_injury(id: int, db:Session = Depends(get_db)):
    return crud.get_injury_by_id(db, id)

@app.post("/injuries/")
def insert_injury(injury: InjuryBase, db:Session = Depends(get_db)):
    return crud.insert_injury(db, injury)

@app.put("/injuries/{id}")
def update_injury(id: int, injury: InjuryBase, db:Session = Depends(get_db)):
    return crud.update_injury(db, injury, id)

@app.delete("/injuries/{id}")
def delete_injury(id: int, db:Session = Depends(get_db)):
    return crud.delete_injury(db, id)


#endregion

#region player_injuries

@app.get("/player_injuries")
def read_player_injuries(db:Session = Depends(get_db)):
    return crud.get_player_injuries(db)

@app.get("/player_injuries/{id}")
def read_player_injury(id: int, db:Session = Depends(get_db)):
    return crud.get_player_injury_by_id(db, id)

@app.get("/player_injuries/player_injury/{player_injury_id}")
def read_player_injury(player_injury_id: int, db:Session = Depends(get_db)):
    return crud.get_player_injury_by_player_injury_id(db, player_injury_id)


@app.get("/player_injuries/{player_id}/date/{date}/injury/{injury}")
def read_player_injury(player_id:int, date, injury:int, db:Session = Depends(get_db)):
    return crud.get_player_injury_by_date(db, date, injury, player_id)

@app.post("/player_injuries/")
def insert_player_injury(player_injury: PlayerInjuryBaseNOID, db:Session = Depends(get_db)):
    return crud.insert_new_player_injury(db, player_injury)

@app.put("/player_injuries/{id}")
def update_player_injury(id: int, player_injury: PlayerInjuryBaseNOID, db:Session = Depends(get_db)):
    return crud.update_player_injury(db, player_injury, id)

@app.delete("/player_injuries/{id}")
def delete_player_injury(id: int, db:Session = Depends(get_db)):
    return crud.delete_player_injury(db, id)

#endregion

#region leagues
@app.get("/leagues/")
def read_leagues(db:Session = Depends(get_db)):
    return crud.get_leagues(db)

@app.get("/leagues/{id}")
def read_leagues(id: int, db:Session = Depends(get_db)):
    return crud.get_league_by_id(db, id)

@app.post("/leagues/")
def create_leagues(league: LeagueBase, db:Session = Depends(get_db)):
    return crud.insert_league(db, league)

@app.put("/leagues/{id}")
def update_leagues(id: int, league: LeagueBase, db:Session = Depends(get_db)):
    return crud.update_league(db, league, id)

@app.delete("/leagues/{id}")
def delete_league(id: int, db:Session = Depends(get_db)):
    return crud.delete_league_by_id(db, id)




#endregion

#region sports

@app.get("/sports")
def get_sports(db:Session = Depends(get_db)):
    return crud.get_sports(db)

@app.get("/sports/{id}")
def get_sport(id: int, db:Session = Depends(get_db)):
    return crud.get_sport(db, id)

@app.post("/sports/")
def create_sports(sport: SportBase, db:Session = Depends(get_db)):
    return crud.insert_sport(db, sport)

@app.put("/sports/{id}")
def update_sports(id: int, sport: SportBase, db:Session = Depends(get_db)):
    return crud.update_sport(db, sport, id)

@app.delete("/sports/{id}")
def delete_sports(id: int, db:Session = Depends(get_db)):
    return crud.delete_sport(db, id)



#endregion

#region notifs
@app.get("/notification")
def get_notifications(db:Session = Depends(get_db)):
    return crud.get_notifications(db)

@app.get("/notification/{id}")
def get_notification(id: int, db:Session = Depends(get_db)):
    return crud.get_notification_by_id(db, id)

@app.get("/notification/{team_id}/{user_type}")
def get_notification_by_team_type(team_id: int, user_type: str, db:Session = Depends(get_db)):
    return crud.get_notification_by_team_id_type(db, team_id, user_type)


@app.post("/notification")
def create_notification(notification: NotificationBase, db:Session = Depends(get_db)):
    return crud.insert_notification(db, notification)

@app.put("/notification/{id}")
def update_notification(id: int, notification: NotificationBase, db:Session = Depends(get_db)):
    return crud.update_notification(db, notification, id)

@app.delete("/notification/{id}")
def delete_notification(id: int, db:Session = Depends(get_db)):
    return crud.delete_notification(db, id)



#endregion

#region matches

@app.get("/match/{id}")
def get_matches(id:int, db:Session = Depends(get_db)):
    return crud.get_match(db, id)

@app.get("/match/schedule/{schedule_id}/player/{player_id}")
def get_matches(schedule_id:int, player_id:int, db:Session = Depends(get_db)):
    return crud.get_match_by_schedule_player_id(db, schedule_id, player_id)

@app.get("/match/player/{id}")
def get_matches_by_player(id:int, db:Session = Depends(get_db)):
    return crud.get_match_by_player_id(db, id)

@app.get("/match/player/{id}/minutes_played")
def get_minutes_by_player(id:int, db:Session = Depends(get_db)):
    return crud.get_minutes_played_by_player_id(db, id)



@app.post("/match")
def create_match(match: MatchBase, db:Session = Depends(get_db)):
    return crud.insert_match(db, match)



#redundant?
@app.put("/match/schedule/{schedule_id}/player/{player_id}/minutes/{minutes}")
def update_match(schedule_id: int, player_id: int, minutes: int, db:Session = Depends(get_db)):
    return crud.update_minutes(db, minutes, player_id, schedule_id)


@app.delete("/match/{id}")
def delete_match(id: int, db:Session = Depends(get_db)):
    return crud.delete_match(db, id)


@app.put("/calculate_matches_played/{player_id}")
def calculate_matches_played(player_id: int, db:Session = Depends(get_db)):
    return crud.update_matches_played(db, player_id)


#endregion


#region test_routes



@app.delete("/cleanup_tests")
def cleanup(db:Session = Depends(get_db)):
    return crud.cleanup(db)


#endregion



if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True, log_level="debug")
    
