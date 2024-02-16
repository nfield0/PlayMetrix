import re
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import text
import os
from fastapi import Depends, FastAPI, HTTPException
from models import *
from schema import *
import bcrypt
from passlib.context import CryptContext
from Crud.user import *
from Crud.teams import *
from Crud.manager import *
from Crud.player import *
from Crud.physio import *
from Crud.injuries import *
from Crud.scheduling import *

    
def cleanup(db: Session):
    try:       
        db.query(team_schedule).delete()
        db.query(player_schedule).delete()
        db.query(announcements).delete()
        db.query(schedule).delete()
        
        db.query(team_coach).delete()
        db.query(team_physio).delete()
        db.query(team_player).delete()

        db.query(player_injuries).delete()
        db.query(injuries).delete()
        db.query(team).delete()
        db.query(league).delete()
        db.query(sport).delete()

        db.query(physio_info).delete()
        db.query(physio_login).delete()
        

        db.query(manager_info).delete()
        db.query(manager_login).delete()


        db.query(player_stats).delete()

        db.query(player_info).delete()
        db.query(player_login).delete()

        db.query(coach_info).delete()
        db.query(coach_login).delete()



        db.flush()

        db.execute(text("ALTER SEQUENCE manager_login_manager_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE physio_info_physio_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE league_league_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE player_login_player_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE team_team_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE sport_sport_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE coach_login_coach_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE injuries_injury_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE physio_login_physio_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE announcements_announcements_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE schedule_schedule_id_seq RESTART WITH 1;"))


        db.commit()
        db.close()
        return {"message": "Finished Cleanup"}

    except SQLAlchemyError as e:
        # Log the exception for debugging
        print(f"Cleanup failed: {e}")
        db.rollback()  # Rollback changes in case of an error
        db.close()  # Close the connection
        return {"error": "Cleanup failed, check logs for details"}
