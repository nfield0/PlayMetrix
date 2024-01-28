import re
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import text

from fastapi import Depends, FastAPI, HTTPException
from models import *
from schema import *
import bcrypt
from passlib.context import CryptContext

#region regex_and_encryption

email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
password_regex = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
name_regex = r'^[A-Za-z]+(?:\s+[A-Za-z]+)*$'
team_name_regex = r'^[A-Za-z0-9\s]*$'

def check_email(email : str):
    if re.fullmatch(email_regex, email):
       return True
    else:
        return False 
        
    
def check_password_regex(password : str):
    if re.fullmatch(password_regex, password):
        return True
    else:
        return False

def check_is_valid_name(name: str):
    if not re.match(name_regex, name):
        raise HTTPException(status_code=400, detail="Name format is invalid")
    else:
        return True
    
def check_is_valid_team_name(name: str):
    if re.fullmatch(team_name_regex, name):
        return True
    else:
        return False

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def encrypt_password(password):
    return pwd_context.hash(password)

# def encrypt_password(password : str):
#     password = password.encode()
#     password = bcrypt.hashpw(password, bcrypt.gensalt())
#     return password

# def check_password(plain_password, hashed_password):
#     return bcrypt.checkpw(plain_password.encode(), hashed_password)

#endregion

#region user
# def register_user(db, user):
#     # if user.user_type != "player" or "manager" or "coach" or "physio":
#     #     raise HTTPException(status_code=400, detail="Invalid user type")
#     existing_user = get_user_by_email(db, user.user_type, user.user_email)
#     if existing_user:
#         raise HTTPException(status_code=400, detail="Email already registered")
#     if not user.user_email or not user.user_password:
#         raise HTTPException(status_code=400, detail="Email and password are required")
        
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Email format invalid")
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Password format invalid")
    
#     if user.user_type == "player":
#         new_user = player_login(player_email=user.user_email, player_password=encrypt_password(user.user_password))
#     elif user.user_type == "manager":
#         new_user = manager_login(manager_email=user.user_email, manager_password=encrypt_password(user.user_password))
#     elif user.user_type == "physio":
#         new_user = physio_login(physio_email=user.user_email, physio_password=encrypt_password(user.user_password))

#     db.add(new_user)
#     db.commit()
#     db.refresh(new_user)
#     return {"detail": f"{user.user_type.capitalize()} Registered Successfully", "id": get_user_by_email(db,user.user_type,user.user_email)}

def register_player(db, user):
    existing_user = check_user_exists_by_email(db, user.player_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.player_email or not user.player_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.player_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.player_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    
    new_user = player_login(player_email=user.player_email, player_password=encrypt_password(user.player_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_id = get_user_by_email(db,"player",user.player_email)
    new_user_info = player_info(player_id=new_user_id.player_id, player_firstname=user.player_firstname,player_surname=user.player_surname,
                                player_dob=user.player_dob,player_contact_number=user.player_contact_number,
                                player_image=user.player_image,player_height=user.player_height,player_gender=user.player_gender)
                                   
    db.add(new_user_info)

    new_user_stats = player_stats(player_id=new_user_id.player_id, matches_played=0, matches_started=0, 
                                  matches_off_the_bench=0, injury_prone=False, minutes_played=0)
    db.add(new_user_stats)
    db.commit()
    db.refresh(new_user_stats)

    return {"detail": "Player Registered Successfully", "id": new_user.player_id}

def register_manager(db, user):
    existing_user = check_user_exists_by_email(db, user.manager_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.manager_email or not user.manager_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.manager_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.manager_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    

    new_user = manager_login(manager_email=user.manager_email, manager_password=encrypt_password(user.manager_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_id = get_user_by_email(db,"manager",user.manager_email)
    new_user_info = manager_info(manager_id=new_user_id.manager_id, manager_firstname=user.manager_firstname,manager_surname=user.manager_surname,
                                manager_contact_number=user.manager_contact_number,
                                manager_image=user.manager_image)              
                      
    db.add(new_user_info)  
    db.commit()
    
    return {"detail": "Manager Registered Successfully", "id": get_user_by_email(db,"manager",user.manager_email)}

def register_physio(db, user):
    existing_user = check_user_exists_by_email(db, user.physio_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.physio_email or not user.physio_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.physio_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.physio_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    if not check_is_valid_name(user.physio_firstname):
        raise HTTPException(status_code=400, detail="First name format invalid")
    if not check_is_valid_name(str(user.physio_surname)):
        raise HTTPException(status_code=400, detail="Surname format invalid")
    
    new_user = physio_login(physio_email=user.physio_email, physio_password=encrypt_password(user.physio_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_info = physio_info(physio_id=new_user.physio_id, physio_firstname=user.physio_firstname,physio_surname=user.physio_surname,
                                physio_contact_number=user.physio_contact_number, physio_image=user.physio_image)
                                   
    db.add(new_user_info)  
    db.commit()

    return {"detail": "Physio Registered Successfully", "id": new_user.physio_id}

def register_coach(db, user):
    try:
        existing_user = check_user_exists_by_email(db, user.coach_email)
        if existing_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        if not user.coach_email or not user.coach_password:
            raise HTTPException(status_code=400, detail="Email and password are required")
            
        if not check_email(user.coach_email):
            raise HTTPException(status_code=400, detail="Email format invalid")
        if not check_email(user.coach_email):
            raise HTTPException(status_code=400, detail="Password format invalid")
        
        new_user = coach_login(coach_email=user.coach_email, coach_password=encrypt_password(user.coach_password))
        
        db.add(new_user)
        
        db.commit()
        db.refresh(new_user)
        
        new_user_id = get_user_by_email(db,"coach",user.coach_email)
        new_user_info = coach_info(coach_id=new_user_id.coach_id, coach_firstname=user.coach_firstname,coach_surname=user.coach_surname,
                                    coach_contact=user.coach_contact, coach_image=user.coach_image)
                                    
        db.add(new_user_info)  
        db.commit()

        return {"detail": "Coach Registered Successfully", "id": get_user_by_email(db,"coach",user.coach_email)}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return(f"Error registering coaches: {e}")

    
# def register_user_with_info(db, user):
#     # if user.user_type != "player" or "manager" or "coach" or "physio":
#     #     raise HTTPException(status_code=400, detail="Invalid user type")
#     existing_user = get_user_by_email(db, user.user_type, user.user_email)
#     if existing_user:
#         raise HTTPException(status_code=400, detail="Email already registered")
#     if not user.user_email or not user.user_password:
#         raise HTTPException(status_code=400, detail="Email and password are required")
        
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Email format invalid")
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Password format invalid")
    
#     if user.user_type == "player":
#         new_user = player_login(player_email=user.user_email, player_password=user.user_password)
#         new_user_info = player_info(player_firstname="",player_surname="",player_dob="",player_contact_number="",
#                                     player_image=b"",player_height="",player_gender="")
#     elif user.user_type == "manager":
#         new_user = manager_login(manager_email=user.user_email, manager_password=user.user_password)
#         new_user_info = manager_info(manager_firstname="",manager_surname="",manager_contact_number="",manager_image=b"")
#     elif user.user_type == "physio":
#         new_user = physio_login(physio_email=user.user_email, physio_password=user.user_password)
#         new_user_info = physio_info(physio_firstname="",physio_surname="",physio_contact_number="",physio_image=b"")

#     db.add(new_user)
#     db.add(new_user_info)
#     db.commit()
#     db.refresh(new_user)
#     return {"detail": f"{user.user_type.capitalize()} Registered Successfully", "id": get_user_by_email(db,user.user_type,user.user_email)}

    
def login(db, user):
    return get_user_details_by_email_password(db, user.user_email, user.user_password)
    
    # if existing_user:
    #     if user.user_type == "manager" and verify_password(user.user_password, existing_user.manager_password):
    #         return {"user_email": True, "user_password": True}
    #     elif user.user_type == "player" and verify_password(user.user_password, existing_user.player_password):
    #         return {"user_email": True, "user_password": True}
    #     elif user.user_type == "physio" and verify_password(user.user_password, existing_user.physio_password):
    #         return {"user_email": True, "user_password": True}
    #     else:
    #         return {"user_email": True, "user_password": False}
    # else:
    #     return {"user_email": False, "user_password": False}



def get_user_details_by_email_password(db:Session, email: str, password: str):
    # raise HTTPException(status_code=200, detail=email)

    try:
        manager_login_result = db.query(manager_login).filter_by(manager_email=email).first()
        player_login_result = db.query(player_login).filter_by(player_email=email).first()
        physio_login_result = db.query(physio_login).filter_by(physio_email=email).first()
        coach_login_result = db.query(coach_login).filter_by(coach_email=email).first()


        if manager_login_result:
            return UserLoginBase(user_id=manager_login_result.manager_id, user_type="manager", user_email=True, user_password=verify_password(password, manager_login_result.manager_password))
        elif player_login_result:
            return UserLoginBase(user_id=player_login_result.player_id, user_type="player", user_email=True, user_password=verify_password(password, player_login_result.player_password))
        elif physio_login_result:
            return UserLoginBase(user_id=physio_login_result.physio_id, user_type="physio", user_email=True, user_password=verify_password(password, physio_login_result.physio_password))
        elif coach_login_result:
            return UserLoginBase(user_id=coach_login_result.coach_id, user_type="coach", user_email=True, user_password=verify_password(password, coach_login_result.coach_password))
        else:
            raise HTTPException(status_code=400, detail="No user found")
        
    except Exception as e:
        return(f"Error retrieving user: {e}")

def get_user_by_type(db:Session, user: UserType):
    return get_user_by_email(db, user.user_type, user.user_email)

def check_user_exists_by_email(db:Session, email: str):
    try:
        manager_login_result = db.query(manager_login).filter_by(manager_email=email).first()
        player_login_result = db.query(player_login).filter_by(player_email=email).first()
        physio_login_result = db.query(physio_login).filter_by(physio_email=email).first()
        coach_login_result = db.query(coach_login).filter_by(coach_email=email).first()


        if manager_login_result:
            return True
        elif player_login_result:
            return True
        elif physio_login_result:
            return True
        elif coach_login_result:
            return True
        else:
            return False
        
    except Exception as e:
        return(f"Error retrieving user: {e}")
def get_user_by_email(db:Session, type: str, email: str):
    # raise HTTPException(status_code=200, detail=email)

    try:
        if type == "manager":
            login_info = db.query(manager_login).filter_by(manager_email=email).first()
        elif type == "player":
            login_info = db.query(player_login).filter_by(player_email=email).first()
        elif type == "physio":
            login_info = db.query(physio_login).filter_by(physio_email=email).first()
        elif type == "coach":
            login_info = db.query(coach_login).filter_by(coach_email=email).first()
        else:
            raise HTTPException(status_code=400, detail="Invalid user type")
        
        return login_info
    except Exception as e:
        return(f"Error retrieving from {type}s: {e}")
    

#endregion

#region team
        
def get_teams(db: Session):
    try:
        result = db.query(team).all()
        return result
    except Exception as e:
        return(f"Error retrieving teams: {e}")
    
def get_team_by_id(db: Session, id: int):
    try:
        result = db.query(team).filter_by(team_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving teams: {e}")
       

def insert_new_team(db:Session, new_team: TeamBase):
    try:
        if new_team is not None:
            if check_is_valid_team_name(new_team.team_name):
        
                if get_all_manager_info_by_id(db, new_team.manager_id):
                    new_team = team(team_name=new_team.team_name,
                        team_logo=new_team.team_logo,
                        manager_id=new_team.manager_id,
                        league_id=new_team.league_id,
                        sport_id=new_team.sport_id,
                        team_location=new_team.team_location)

                    db.add(new_team)
                    db.commit()
                    db.refresh(new_team)

                    return {"message": "Team inserted successfully", "id": new_team.team_id}
                raise HTTPException(status_code=400, detail="Manager ID Does not Exist")
            raise HTTPException(status_code=400, detail="Team name is incorrect")
        return {"message": "Team is empty or invalid"}
    except Exception as e:
        return (f"Error inserting team: {e}")

def update_team(db, updated_team: TeamBase, id):
    try:        
        if check_is_valid_team_name(updated_team.team_name):
            team_to_update = db.query(team).filter_by(team_id= id).first()
            
            if not team_to_update:
                raise HTTPException(status_code=404, detail="Team not found")
            
            team_to_update.team_name = updated_team.team_name
            team_to_update.team_logo = updated_team.team_logo
            team_to_update.manager_id = updated_team.manager_id 
            team_to_update.league_id = updated_team.league_id 
            team_to_update.sport_id = updated_team.sport_id 
            team_to_update.team_location = updated_team.team_location    
            db.commit()
            return {"message": f"Team with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=400, detail="Team name is incorrect")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating team: {e}")
    

def delete_team_by_id(db:Session, id: int):
    try:        
        team_to_delete = db.query(team).filter_by(team_id=id).first()
        if team_to_delete:
            db.delete(team_to_delete)
            db.commit()
        db.close()
        return {"message": "Team deleted successfully"}

    except Exception as e:
        return(f"Error deleting team: {e}")


#endregion 

#region schedules
    

def get_schedules(db: Session):
    try:
        result = db.query(schedule).all()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")

def get_schedule_by_id(db: Session, id: int):
    try:
        result = db.query(schedule).filter_by(schedule_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")
    
def get_schedule_by_team_id(db: Session, id: int):
    try:
        result = db.query(schedule).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")

def get_schedule_by_team_id_and_date(db: Session, id: int, date: str):
    try:
        result = db.query(schedule).filter_by(team_id=id, schedule_date=date).first()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")
    
def get_schedule_by_team_id_and_type(db: Session, id: int, type: str):
    try:
        result = db.query(schedule).filter_by(team_id=id, schedule_type=type).all()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")


def insert_new_schedule(db:Session, new_schedule: ScheduleBaseNoID):
    try:
        if new_schedule is not None:
            new_schedule = schedule(schedule_title=new_schedule.schedule_title,schedule_location=new_schedule.schedule_location,
                                    schedule_type=new_schedule.schedule_type,
                                    schedule_start_time=new_schedule.schedule_start_time,
                                    schedule_end_time=new_schedule.schedule_end_time,
                                    schedule_alert_time=new_schedule.schedule_alert_time)
            db.add(new_schedule)
            db.commit()
            db.refresh(new_schedule)
            return {"message": "Schedule inserted successfully", "id": new_schedule.schedule_id}
            
        return {"message": "Schedule is empty or invalid"}
    except Exception as e:
        return (f"Error inserting schedule: {e}")
    
def update_schedule(db, updated_schedule: ScheduleBase, id):
    try:        
        schedule_to_update = db.query(schedule).filter_by(schedule_id= id).first()
        
        if not schedule_to_update:
            raise HTTPException(status_code=404, detail="Schedule not found")
        
        schedule_to_update.schedule_title = updated_schedule.schedule_title
        schedule_to_update.schedule_location = updated_schedule.schedule_location
        schedule_to_update.schedule_type = updated_schedule.schedule_type
        schedule_to_update.schedule_start_time = updated_schedule.schedule_start_time
        schedule_to_update.schedule_end_time = updated_schedule.schedule_end_time
        schedule_to_update.schedule_alert_time = updated_schedule.schedule_alert_time
        
        db.commit()
        return {"message": f"Schedule with ID {id} has been updated"}
    except Exception as e:
        return(f"Error updating schedule: {e}")
    
def delete_schedule_by_id(db:Session, id: int):
    try:        
        schedule_to_delete = db.query(schedule).filter_by(schedule_id=id).first()
        if schedule_to_delete:
            db.delete(schedule_to_delete)
            db.commit()
        db.close()
        return {"message": "Schedule deleted successfully"}

    except Exception as e:
        return(f"Error deleting schedule: {e}")
    
# team schedules
    
def get_team_schedules(db: Session, id:int):
    try:
        result = db.query(team_schedule).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team schedules: {e}")
    
def get_team_schedule_by_id(db: Session, id: int):
    try:
        result = db.query(team_schedule).filter_by(schedule_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving team schedules: {e}")

def insert_new_team_schedule(db:Session, new_team_schedule: TeamScheduleBase):
    try:
        if new_team_schedule is not None:
            if not get_schedule_by_id(db, new_team_schedule.schedule_id):
                raise HTTPException(status_code=400, detail="Schedule ID already exists")
            if not get_team_by_id(db, new_team_schedule.team_id):
                raise HTTPException(status_code=400, detail="Team ID Does not Exist")
            else:
                new_team_schedule = team_schedule(schedule_id=new_team_schedule.schedule_id,
                                        team_id=new_team_schedule.team_id)
                db.add(new_team_schedule)
                db.commit()
                db.refresh(new_team_schedule)
                return {"message": "Team Schedule inserted successfully", "id": new_team_schedule.schedule_id}
            
        return {"message": "Team Schedule is empty or invalid"}
    except Exception as e:
        return (f"Error inserting team schedule: {e}")

def update_team_schedule(db, updated_team_schedule: TeamScheduleBase, id):
    try:        
        team_schedule_to_update = db.query(team_schedule).filter_by(schedule_id= id).first()
        
        if not team_schedule_to_update:
            raise HTTPException(status_code=404, detail="Team Schedule not found")
        
        team_schedule_to_update.schedule_id = updated_team_schedule.schedule_id
        team_schedule_to_update.team_id = updated_team_schedule.team_id
        
        db.commit()
        return {"message": f"Team Schedule with ID {id} has been updated"}
    except Exception as e:
        return(f"Error updating team schedule: {e}")
    
def delete_team_schedule_by_id(db:Session, id: int):
    try:        
        team_schedule_to_delete = db.query(team_schedule).filter_by(schedule_id=id).first()
        if team_schedule_to_delete:
            db.delete(team_schedule_to_delete)
            db.commit()
        db.close()
        return {"message": "Team Schedule deleted successfully"}

    except Exception as e:
        return(f"Error deleting team schedule: {e}")
    
    
#endregion
    
#region player schedules

def get_player_schedules(db: Session, id:int):
    try:
        result = db.query(player_schedule).filter_by(player_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving player schedules: {e}")
    
def insert_new_player_schedule(db: Session, new_player_schedule: PlayerScheduleBase):
    try:
        if new_player_schedule is not None:
            if get_player_by_id(db, new_player_schedule.player_id):
                new_schedule = player_schedule(schedule_id=new_player_schedule.schedule_id,
                                              player_id=new_player_schedule.player_id,
                                              player_attending=new_player_schedule.player_attending)
                db.add(new_schedule)
                db.commit()
                db.refresh(new_schedule)
                return {"message": "Player Schedule inserted successfully", "id": new_schedule.schedule_id}
            raise HTTPException(status_code=400, detail="Player ID Does not Exist")
        return {"message": "Player Schedule is empty or invalid"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return f"Error inserting player schedule: {e}"
    
def update_player_schedule(db, updated_player_schedule: PlayerScheduleBase, player_id: int):
    try:        
        player_schedule_to_update = db.query(player_schedule).filter_by(player_id=player_id).first()
        
        if not player_schedule_to_update:
            raise HTTPException(status_code=404, detail="Player Schedule not found")
        
        player_schedule_to_update.schedule_id = updated_player_schedule.schedule_id
        player_schedule_to_update.player_id = updated_player_schedule.player_id
        player_schedule_to_update.player_attending = updated_player_schedule.player_attending
        
        db.commit()
        return {"message": f"Player with ID {player_id} Schedule has been updated"}
    except Exception as e:
        return(f"Error updating player schedule: {e}")
    
def delete_player_schedule_by_id(db:Session, delete_player_id: int):
    try:        
        player_schedule_to_delete = db.query(player_schedule).filter_by(player_id=delete_player_id).first()
        if player_schedule_to_delete:
            db.delete(player_schedule_to_delete)
            db.commit()
        db.close()
        return {"message": f"Player with ID {delete_player_id} Schedule deleted successfully"}

    except Exception as e:
        return(f"Error deleting player schedule: {e}")


#endregion


#region announcements
    
def get_announcement(db: Session, id: int):
    try:
        result = db.query(announcements).filter_by(announcements_id=id).first()
        return result
    except Exception as e:
        error_message = f"Error retrieving announcement with ID {id}: {e}"
        return error_message
    
def insert_new_announcement(db:Session, new_announcement: AnnouncementBaseNoID):
    try:
        if new_announcement is None:
            raise HTTPException(status_code=400, detail="Announcement is empty or invalid")
        
        if get_manager_by_id(db, new_announcement.manager_id) is None:
            raise HTTPException(status_code=400, detail="Manager ID Does not Exist")

        announcement = announcements(announcements_title=new_announcement.announcements_title,
                                        announcements_desc=new_announcement.announcements_desc,
                                        announcements_date=new_announcement.announcements_date,
                                        manager_id=new_announcement.manager_id,
                                        schedule_id=new_announcement.schedule_id)
        db.add(announcement)
        db.commit()
        db.refresh(announcement)
        return {"message": "Announcement inserted successfully", "id": announcement.announcements_id}

    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return (f"Error inserting announcement: {e}")
    
def update_announcement(db, updated_announcement: AnnouncementBase, id: int):

    try:        
        announcement_to_update = db.query(announcements).filter_by(announcements_id= id).first()
        
        if not announcement_to_update:
            raise HTTPException(status_code=404, detail="Announcement not found")
        
        announcement_to_update.announcements_title = updated_announcement.announcements_title
        announcement_to_update.announcements_desc = updated_announcement.announcements_desc
        announcement_to_update.announcements_date = updated_announcement.announcements_date
        announcement_to_update.manager_id = updated_announcement.manager_id
        announcement_to_update.schedule_id = updated_announcement.schedule_id
        
        db.commit()
        return {"message": f"Announcement with ID {id} has been updated"}
    except Exception as e:
        return(f"Error updating announcement: {e}")
    
def delete_announcement_by_id(db:Session, id: int):
    try:        
        announcement_to_delete = db.query(announcements).filter_by(announcements_id=id).first()
        if announcement_to_delete:
            db.delete(announcement_to_delete)
            db.commit()
        db.close()
        return {"message": "Announcement deleted successfully"}

    except Exception as e:
        return(f"Error deleting announcement: {e}")



#endregion

#region managers

def get_manager_by_id(db:Session, id: int):
    try:        
        login_info = db.query(manager_login).filter_by(manager_id= id).first()


        return login_info
    except Exception as e:
        return(f"Error retrieving from managers: {e}")
    
def get_all_manager_info_by_id(db:Session, id: int):
    try:        
        login_info = db.query(manager_login).filter_by(manager_id= id).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= id).first()

        if manager_info_result:
            manager = ManagerNoID(manager_email=login_info.manager_email,manager_password="Hidden",
                                  manager_firstname=manager_info_result.manager_firstname,manager_surname=manager_info_result.manager_surname,
                                  manager_contact_number=manager_info_result.manager_contact_number,manager_image=manager_info_result.manager_image)
            
        else:
            manager = Manager(manager_id=login_info.manager_id,manager_email=login_info.manager_email,manager_password="Hidden")
        return manager
    except Exception as e:
        return(f"Error retrieving from managers: {e}")
    
def get_all_managers_login(db: Session):
    try:
        managers = db.query(manager_login).all()
        return managers
    except Exception as e:
        return(f"Error retrieving managers: {e}")
    
def update_manager_by_id(db:Session, manager: ManagerNoID, id: int):
    try:        
        manager_to_update = db.query(manager_login).filter_by(manager_id= id).first()
        
        if not manager_to_update:
            raise HTTPException(status_code=404, detail="Manager not found")
        
        if check_email(str(manager.manager_email)):
            manager_to_update.manager_email = manager.manager_email
        else:
            print("Invalid email format")
            raise HTTPException(status_code=400, detail="Email format invalid")

        if check_password_regex(str(manager.manager_password)):
            manager_to_update.manager_password = encrypt_password(manager.manager_password)
        else:
            print("Invalid password format")
            raise HTTPException(status_code=400, detail="Password format invalid")


        manager_info_to_update = db.query(manager_info).filter_by(manager_id= id).first()

        if not manager_info_to_update:
            new_manager_info = manager_info(manager_id=id,
                                        manager_firstname=manager.manager_firstname,
                                        manager_surname=manager.manager_surname,
                                        manager_contact_number=manager.manager_contact_number,
                                        manager_image = manager.manager_image)
            db.add(new_manager_info)
        else:
            manager_info_to_update.manager_firstname = manager.manager_firstname
            manager_info_to_update.manager_surname = manager.manager_surname
            manager_info_to_update.manager_contact_number = manager.manager_contact_number
            manager_info_to_update.manager_image = manager.manager_image

            # raise HTTPException(status_code=404, detail="Manager Info not found")
        
        db.commit()

        return {"message": f"Manager and manager info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}

def update_manager_login_by_id(db:Session, manager: Manager, id: int):
    try:        
        manager_to_update = db.query(manager_login).filter_by(manager_id= id).first()
        
        if not manager_to_update:
            raise HTTPException(status_code=404, detail="Manager not found")
        
        if not check_email(str(manager.manager_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        manager_to_update.manager_email = manager.manager_email

        if not check_password_regex(str(manager.manager_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        manager_to_update.manager_password = encrypt_password(manager.manager_password)
        
        db.commit()

        return {"message": f"Manager Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}
    
def update_manager_info_by_id(db:Session, manager: ManagerInfo, id: int):
    try:        
        manager_info_to_update = db.query(manager_info).filter_by(manager_id= id).first()
        
        if not manager_info_to_update:
            raise HTTPException(status_code=404, detail="Manager Info not found")
        
        manager_info_to_update.manager_firstname = manager.manager_firstname
        manager_info_to_update.manager_surname = manager.manager_surname
        manager_info_to_update.manager_contact_number = manager.manager_contact_number
        manager_info_to_update.manager_image = manager.manager_image
        
        db.commit()

        return {"message": f"Manager Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}


def delete_manager_by_id(db:Session, id: int):
    try:        
        manager = db.query(manager_login).filter_by(manager_id= id).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= id).first()
        if not manager:
            raise HTTPException(status_code=404, detail="Manager not found")
        if manager_info_result:
            db.delete(manager_info_result)
        db.delete(manager)
        db.commit()
        db.close()
        return {"message": f"Manager and manager info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from managers: {e}")
        
def delete_manager_by_email(db:Session, email: str):
    try:        
        manager = db.query(manager_login).filter_by(manager_email=email).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= manager.manager_id).first()
        if not manager:
            raise HTTPException(status_code=404, detail="Manager not found")
        db.delete(manager)
        db.delete(manager_info_result)
        db.commit()
        db.close()
        return {"message": f"Manager and manager info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from managers: {e}")

#endregion


#region players

def get_players(db: Session):
    try:
        result = db.query(player_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving players: {e}")
    
    # player_info_result = db.query(player_info).filter_by(player_id=player.player_id).first()
    #             player_stats_result = db.query(player_stats).filter_by(player_id=player.player_id).first()
    #             # player_injuries_result = db.query(player_injuries).filter_by(player_id=player.player_id).first()
    #             player_entity = PlayerBase(player.player_id, player.player_email, player.player_password,
    #                                     player_info_result.player_firstname, player_info_result.player_surname, player_info_result.player_DOB,
    #                                         player_info_result.player_contact_number, player_info_result.player_image,
    #                                         player_stats_result.matches_played, player_stats_result.matches_started,
    #                                         player_stats_result.matches_off_the_bench, player_stats_result.injury_prone,
    #                                         player_stats_result.minute_played )
    #             players.append(player_entity)
    
def get_player_by_id(db: Session, id: int):
    try:
        player = db.query(player_login).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player: {e}")
    


def get_player_info_by_id(db:Session, id: int):
    try:
        player = db.query(player_info).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player info: {e}")
    
def create_player_info_by_id(db:Session, id: int):
    try:
        player_info = PlayerInfo(id, "","","","","","")
        db.add(player_info)
        return
    except Exception as e:
        return(f"Error retrieving player info: {e}")

def get_player_stats_by_id(db:Session, id: int):
    try:
        player = db.query(player_stats).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player stats: {e}")
    
def update_player_info_by_id(db:Session, player: PlayerInfo, id: int):
    try:
        player_info_to_update = db.query(player_info).filter_by(player_id=id).first()
        new_player_info = player_info(player_id=player.player_id,
                                      player_firstname=player.player_firstname,
                                      player_surname=player.player_surname,
                                      player_dob=player.player_dob,
                                      player_contact_number=player.player_contact_number,
                                      player_image=player.player_image,
                                      player_height=player.player_height,
                                      player_gender=player.player_gender
                                      )
	
        if not player_info_to_update:
            db.add(new_player_info)
        else:
        
            player_info_to_update.player_firstname = player.player_firstname
            player_info_to_update.player_surname = player.player_surname
            player_info_to_update.player_dob = player.player_dob
            player_info_to_update.player_contact_number = player.player_contact_number
            player_info_to_update.player_image = player.player_image
            player_info_to_update.player_height = player.player_height
            player_info_to_update.player_gender = player.player_gender


        db.commit()

        return {"message": f"Player info with ID {id} has been updated"}

    except Exception as e:
        return(f"Error retrieving player info: {e}")


def update_player_stat_by_id(db:Session, player: PlayerStat,id: int ):
    try:
        player_stat_to_update = db.query(player_stats).filter_by(player_id=id).first()

        
        
        if not player_stat_to_update:
            new_player_stat = player_stats(player_id = player.player_id,
            matches_played = player.matches_played,
            matches_started = player.matches_started,
            matches_off_the_bench = player.matches_off_the_bench,
            injury_prone = player.injury_prone,
            minutes_played = player.minutes_played)
            # raise HTTPException(status_code=404, detail="Player info not found")
            db.add(new_player_stat)
        else:
            player_stat_to_update.player_id = player.player_id
            player_stat_to_update.matches_played = player.matches_played
            player_stat_to_update.matches_started = player.matches_started
            player_stat_to_update.matches_off_the_bench = player.matches_off_the_bench
            player_stat_to_update.injury_prone = player.injury_prone
            player_stat_to_update.minutes_played = player.minutes_played

        db.commit()

        return {"message": f"Player stats with ID {id} has been updated"}
    except Exception as e:
                return(f"Error retrieving player stats: {e}")

def update_player_by_id(db:Session,  player: PlayerBase, id: int):
    try:
        player_to_update = db.query(player_login).filter_by(player_id=id).first()
        if not player_to_update:
            raise HTTPException(status_code=404, detail="Player Login not found")
        player_to_update.player_email = player.player_email
        player_to_update.player_password = encrypt_password(player.player_password)

        db.commit()

        return {"message": f"Player Login with ID {id} has been updated"}
    except Exception as e:
        return(f"Error retrieving player login: {e}")

def delete_player(db: Session, id: int):
    try:        
        player = db.query(player_login).filter_by(player_id=id).first()
        player_info_result = db.query(player_info).filter_by(player_id=id).first()
        player_stats_result = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries_result = db.query(player_injuries).filter_by(player_id=id).first()
        
        print(player_stats_result)

        if player_injuries_result:
            db.delete(player_injuries_result) 
            db.commit()
        if player_stats_result:
            db.delete(player_stats_result)
            db.commit()
        if player_info_result:
            db.delete(player_info_result)
            db.commit()
        db.delete(player)
        db.commit()
        db.close()
        return {"message": f"Player with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")
    

def delete_player_by_email(db:Session, email: str):
    try:        
        player = db.query(player_login).filter_by(player_email=email).first()
        player_info_result = db.query(player_info).filter_by(player_id=id).first()
        player_stats_result = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries_result = db.query(player_injuries).filter_by(player_id=player.player_id).first()
        
        if player_injuries_result:
            db.delete(player_injuries_result) 
        if player_stats_result:
            db.delete(player_stats_result)
        if player_info_result:
            db.delete(player_info_result)
        
        db.delete(player)
        db.commit()
        db.close()
        return {"message": f"Player with Email {email} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")



#endregion

#region physio
    
def get_all_physios(db: Session):
    try:
        result = db.query(physio_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving physios: {e}")
    
def get_physio_login_by_id(db: Session, id: int):
    try:
        result = db.query(physio_login).filter_by(physio_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving physio: {e}")
    
def get_physio_with_info_by_id(db: Session, id: int):
    try:
        result = db.query(physio_login).filter_by(physio_id=id).first()
        info_result = db.query(physio_info).filter_by(physio_id=id).first()

        if info_result:
            physio = PhysioNoID(physio_email=result.physio_email,physio_password="Hidden",
                                  physio_firstname=info_result.physio_firstname,physio_surname=info_result.physio_surname,
                                  physio_contact_number=info_result.physio_contact_number, physio_image=info_result.physio_image)
            return physio
        else:
            raise HTTPException(status_code=404, detail="Physio Info not found")
            
    except Exception as e:
        return(f"Error retrieving physio: {e}")
    

    

def update_physio_by_id(db:Session, physio: PhysioNoID, id: int):
    try:        
        if not check_email(str(physio.physio_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")    
        if not check_password_regex(str(physio.physio_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        if not check_is_valid_name(physio.physio_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(str(physio.physio_surname)):
            raise HTTPException(status_code=400, detail="Surname format invalid")

        #physio login section
        physio_to_update = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio_to_update:
            raise HTTPException(status_code=404, detail="Physio not found")
        physio_to_update.physio_email = physio.physio_email
        physio_to_update.physio_password = encrypt_password(physio.physio_password)
        db.commit()
        #physio info section
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()

        if not physio_info_to_update:
            new_physio_info = physio_info(physio_id=id,
                                        physio_firstname=physio.physio_firstname,
                                        physio_surname=physio.physio_surname,
                                        physio_contact_number=physio.physio_contact_number,
                                        physio_image = physio.physio_image)
            db.add(new_physio_info)
        else:
            physio_info_to_update.physio_firstname = physio.physio_firstname
            physio_info_to_update.physio_surname = physio.physio_surname
            physio_info_to_update.physio_contact_number = physio.physio_contact_number
            physio_info_to_update.physio_image = physio.physio_image
        
        db.commit()

        return {"message": f"Physio and physio info with ID {id} has been updated"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def update_physio_login_by_id(db:Session, physio: Physio, id: int):
    try:        
        physio_to_update = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio_to_update:
            raise HTTPException(status_code=404, detail="Physio not found")
        if not check_email(str(physio.physio_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        physio_to_update.physio_email = physio.physio_email
        if not check_password_regex(str(physio.physio_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        physio_to_update.physio_password = encrypt_password(physio.physio_password)
        
        db.commit()

        return {"message": f"Physio Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def update_physio_info_by_id(db:Session, physio: PhysioInfo, id: int):
    try:        
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()
        if not physio_info_to_update:
            raise HTTPException(status_code=404, detail="Physio Info not found")
        physio_info_to_update.physio_firstname = physio.physio_firstname
        physio_info_to_update.physio_surname = physio.physio_surname
        physio_info_to_update.physio_contact_number = physio.physio_contact_number
        physio_info_to_update.physio_image = physio.physio_image
        
        db.commit()

        return {"message": f"Physio Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def delete_physio_by_id(db:Session, id: int):
    try:        
        physio = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio:
            raise HTTPException(status_code=404, detail="Physio not found")
        physio_info_result = db.query(physio_info).filter_by(physio_id= id).first()
        
        db.delete(physio)
        db.delete(physio_info_result)
        db.commit()
        db.close()
        return {"message": f"Physio and physio info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from physios: {e}")







#endregion
    

#region coaches
    
def get_all_coaches(db: Session):
    try:
        result = db.query(coach_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving coaches: {e}")
    
def get_coach_login_by_id(db: Session, id: int):
    try:
        result = db.query(coach_login).filter_by(coach_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving coach: {e}")
    
def get_coach_with_info_by_id(db: Session, id: int):
    try:
        result = db.query(coach_login).filter_by(coach_id=id).first()
        info_result = db.query(coach_info).filter_by(coach_id=id).first()

        if info_result:
            coach = CoachCreate(coach_email=result.coach_email,coach_password="Hidden",
                                  coach_firstname=info_result.coach_firstname,coach_surname=info_result.coach_surname,
                                  coach_contact=info_result.coach_contact, coach_image=info_result.coach_image)
            return coach
        else:
            raise HTTPException(status_code=404, detail="Coach Info not found")
            
    except Exception as e:
        return(f"Error retrieving coach: {e}")

def update_coach_by_id(db:Session, coach: CoachCreate, id: int):
    try:        
        if not check_email(str(coach.coach_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")    
        if not check_password_regex(str(coach.coach_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        if not check_is_valid_name(coach.coach_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(str(coach.coach_surname)):
            raise HTTPException(status_code=400, detail="Surname format invalid")

        #coach login section
        coach_to_update = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach_to_update:
            raise HTTPException(status_code=404, detail="Coach not found")
        coach_to_update.coach_email = coach.coach_email
        coach_to_update.coach_password = encrypt_password(coach.coach_password)
        #coach info section
        coach_info_to_update = db.query(coach_info).filter_by(coach_id= id).first()

        if not coach_info_to_update:
            new_coach_info = coach_info(coach_id=id,
                                        coach_firstname=coach.coach_firstname,
                                        coach_surname=coach.coach_surname,
                                        coach_contact=coach.coach_contact)
            db.add(new_coach_info)
        else:
            coach_info_to_update.coach_firstname = coach.coach_firstname
            coach_info_to_update.coach_surname = coach.coach_surname
            coach_info_to_update.coach_contact = coach.coach_contact

            # raise HTTPException(status_code=404, detail="Coach Info not found")
        
        db.commit()

        return {"message": f"Coach and coach info with ID {id} has been updated"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    
def update_coach_login_by_id(db:Session, coach: Coach, id: int):
    try:        
        coach_to_update = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach_to_update:
            raise HTTPException(status_code=404, detail="Coach not found")
        if not check_email(str(coach.coach_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        coach_to_update.coach_email = coach.coach_email
        if not check_password_regex(str(coach.coach_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        coach_to_update.coach_password = encrypt_password(coach.coach_password)
        
        db.commit()

        return {"message": f"Coach Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    
def update_coach_info_by_id(db:Session, coach: CoachInfo, id: int):
    try:        
        coach_info_to_update = db.query(coach_info).filter_by(coach_id= id).first()
        if not coach_info_to_update:
            raise HTTPException(status_code=404, detail="Coach Info not found")
        coach_info_to_update.coach_firstname = coach.coach_firstname
        coach_info_to_update.coach_surname = coach.coach_surname
        coach_info_to_update.coach_contact = coach.coach_contact
        if coach.coach_image is not None:
            coach_info_to_update.coach_image = coach.coach_image

        
        db.commit()

        return {"message": f"Coach Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    

def delete_coach_by_id(db:Session, id: int):
    try:        
        coach = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach:
            raise HTTPException(status_code=404, detail="Coach not found")
        coach_info_result = db.query(coach_info).filter_by(coach_id= id).first()
        
        db.delete(coach)
        db.delete(coach_info_result)
        db.commit()
        db.close()
        return {"message": f"Coach and coach info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from coaches: {e}")

#endregion
    
#region team_coach
    
def get_team_coaches(db: Session, coach_id: int):
    try:
        result = db.query(team_coach).filter_by(coach_id=coach_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team coaches: {e}")

def get_coach_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_coach).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team coaches: {e}")
    
def insert_team_coach_by_team_id(db:Session, team_coach_obj: TeamCoachBase):
    try:
        new_team_coach = team_coach(team_id=team_coach_obj.team_id, coach_id=team_coach_obj.coach_id, team_role=team_coach_obj.team_role)
        db.add(new_team_coach)
        db.commit()
        return {"message": f"Coach with ID {team_coach_obj.coach_id} has been added to team with ID {team_coach_obj.team_id}"}
    except Exception as e:
        return(f"Error adding coach to team: {e}")
    
def update_team_coach_by_team_id(db:Session, team_coach: TeamCoachBase, id: int):
    try:
        team_to_update = db.query(team_coach).filter_by(team_id=id).first()
        if not team_to_update:
            raise HTTPException(status_code=404, detail="Team not found")
        team_to_update.coach_id = team_coach.coach_id
        db.commit()
        return {"message": f"Team with ID {team_coach.team_id} has been updated"}
    except Exception as e:
        return(f"Error updating team: {e}")
    
def delete_team_coach_by_team_id(db:Session, team_id: int, coach_id: int):
    try:        
        team_to_delete = db.query(team_coach).filter_by(team_id=team_id, coach_id=coach_id).first()
        if team_to_delete:
            db.delete(team_to_delete)
            db.commit()
        return {"message": f"Team with ID {id} has been deleted"}
    except Exception as e:
        return(f"Error deleting team coach: {e}")



#endregion


#region team_physio

def get_team_physio(db: Session, physio_id: int):
    try:
        result = db.query(team_physio).filter_by(physio_id=physio_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team physio: {e}")


def get_physio_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_physio).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team physio: {e}")
    
def insert_team_physio_by_team_id(db:Session, team_physio_obj: TeamPhysioBase):
    try:
        if not get_physio_login_by_id(db, team_physio_obj.physio_id):
            raise HTTPException(status_code=400, detail="Physio ID Does not Exist")
        if not get_team_by_id(db, team_physio_obj.team_id):
            raise HTTPException(status_code=400, detail="Team ID Does not Exist")
        
        new_team_physio = team_physio(team_id= team_physio_obj.team_id, physio_id= team_physio_obj.physio_id)
        db.add(new_team_physio)
        db.commit()
        return {"message": f"Physio with ID {team_physio_obj.physio_id} has been added to team with ID { team_physio_obj.team_id}"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return(f"Error adding physio to team: {e}")
    
# def update_team_physio_by_team_id(db:Session,  team_physio: ):
#     try:
#         team_to_update = db.query(team_physio).filter_by(team_id=team_id).first()
#         if not team_to_update:
#             raise HTTPException(status_code=404, detail="Team not found")
#         team_to_update.physio_id = physio_id
#         db.commit()
#         return {"message": f"Team with ID {team_id} has been updated"}
#     except Exception as e:
#         return(f"Error updating team: {e}")

def delete_physio_team_id(db:Session, id: int):
    try:        
        team_to_delete = db.query(team_physio).filter_by(team_id=id).first()
        if team_to_delete:
            db.delete(team_to_delete)
            db.commit()
        return {"message": f"Physio from Team with ID {id} has been deleted"}
    except Exception as e:
        return(f"Error deleting team physio: {e}")
    
#endregion

#region team_player

def get_team_players(db: Session, player_id: int):
    try:
        result = db.query(team_player).filter_by(player_id=player_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team players: {e}")

def get_players_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_player).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team players: {e}")
    
def add_player_to_team(db:Session, team_player_obj: TeamPlayerBase):
    try:
        new_team_player = team_player(team_id=team_player_obj.team_id, player_id=team_player_obj.player_id, team_position=team_player_obj.team_position, player_team_number=team_player_obj.player_team_number,
                                       playing_status=team_player_obj.playing_status, lineup_status=team_player_obj.lineup_status)
        db.add(new_team_player)
        db.commit()
        return {"message": f"Player with ID {str(team_player_obj.player_id)} has been added to team with ID {str(team_player_obj.team_id)}"}
    except Exception as e:
        return(f"Error adding player to team: {e}")
    
def update_player_on_team(db:Session, team_player_obj: TeamPlayerBase):
    try:
        player_to_update = db.query(team_player).filter_by(team_id=team_player_obj.team_id, player_id=team_player_obj.player_id).first()
        if not player_to_update:
            raise HTTPException(status_code=404, detail="Player not found")
        player_to_update.team_position = team_player_obj.team_position
        player_to_update.player_team_number = team_player_obj.player_team_number
        player_to_update.playing_status = team_player_obj.playing_status
        player_to_update.lineup_status = team_player_obj.lineup_status
        db.commit()
        return {"message": f"Player with ID {str(team_player_obj.player_id)} has been updated"}
    except Exception as e:
        return(f"Error updating player position: {e}")


def delete_player_from_team(db:Session, player_id: int, team_id: int ):
    try:        
        player_to_delete = db.query(team_player).filter_by(team_id=team_id, player_id=player_id).first()
        if player_to_delete:
            db.delete(player_to_delete)
            db.commit()
        return {"message": f"Player with ID {player_id} has been deleted from team with ID {team_id}"}
    except Exception as e:
        return(f"Error deleting player from team: {e}")
    

#endregion

#region injuries
    
def get_injuries(db: Session):
    try:
        result = db.query(injuries).all()
        return result
    except Exception as e:
        return(f"Error retrieving injuries: {e}")
    
def get_injury_by_id(db: Session, id: int):
    try:
        result = db.query(injuries).filter_by(injury_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving injuries: {e}")
    
def insert_injury(db:Session, new_injury: InjuryBase):
    try:
        if new_injury is None:
            raise HTTPException(status_code=404, detail="Injury is empty or invalid")
        if not check_is_valid_name(new_injury.injury_type):
            raise HTTPException(status_code=400, detail="Injury type is incorrect")
        else:
            new_injury = injuries(injury_type=new_injury.injury_type,
                               expected_recovery_time=new_injury.expected_recovery_time,
                               recovery_method=new_injury.recovery_method)
            db.add(new_injury)
            db.commit()
            db.refresh(new_injury)
        return {"message": "Injury inserted successfully", "id": new_injury.injury_id}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return (f"Error inserting injury: {e}")

def update_injury(db, updated_injury: InjuryBase, id):
    try:
        injury_to_update = db.query(injuries).filter_by(injury_id= id).first()
        if injury_to_update:
            injury_to_update.injury_type = updated_injury.injury_type
            injury_to_update.expected_recovery_time = updated_injury.expected_recovery_time
            injury_to_update.recovery_method = updated_injury.recovery_method
            db.commit()
            return {"message": f"Injury with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=404, detail="Injury not found")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:  
        raise HTTPException(status_code=500, detail=f"Error updating injury: {e}")
    
def delete_injury(db:Session, id: int):
    try:        
        injury_to_delete = db.query(injuries).filter_by(injury_id=id).first()
        if injury_to_delete:
            db.delete(injury_to_delete)
            db.commit()
        db.close()
        return {"message": "Injury deleted successfully"}

    except Exception as e:
        return(f"Error deleting injury: {e}")
    

#endregion
    

#region player_injuries
    
def get_player_injuries(db: Session):
    try:
        result = db.query(player_injuries).all()
        return result
    except Exception as e:
        return(f"Error retrieving player injuries: {e}")
    
def get_player_injury_by_id(db: Session, id: int):
    try:
        result = db.query(player_injuries).filter_by(injury_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving player injuries: {e}")
    
def insert_new_player_injury(db:Session, new_player_injury: PlayerInjuryBase):
    try:
        if new_player_injury is not None:
            new_player_injury = player_injuries(player_id=new_player_injury.player_id,
                                                date_of_injury=new_player_injury.date_of_injury,
                                                date_of_recovery=new_player_injury.date_of_recovery,
                                                injury_id=new_player_injury.injury_id)
            db.add(new_player_injury)
            db.commit()
            db.refresh(new_player_injury)
            return {"message": "Player Injury inserted successfully", "id": new_player_injury.injury_id}
        return {"message": "Player Injury is empty or invalid"}
    except Exception as e:
        return (f"Error inserting player injury: {e}")

def update_player_injury(db, updated_player_injury: PlayerInjuryBase, id):
    try:
        player_injury_to_update = db.query(player_injuries).filter_by(injury_id= id).first()
        if player_injury_to_update:
            player_injury_to_update.player_id = updated_player_injury.player_id
            player_injury_to_update.injury_id = updated_player_injury.injury_id
            db.commit()
            return {"message": f"Player Injury with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=404, detail="Player Injury not found")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:  
        raise HTTPException(status_code=500, detail=f"Error updating player injury: {e}")
    
def delete_player_injury(db:Session, id: int): 
    try:        
        player_injury_to_delete = db.query(player_injuries).filter_by(injury_id=id).first()
        if player_injury_to_delete:
            db.delete(player_injury_to_delete)
            db.commit()
        db.close()
        return {"message": "Player Injury deleted successfully"}

    except Exception as e:
        return(f"Error deleting player injury: {e}")
    

#endregion



#region leagues


def get_leagues(db: Session):
    try:
        leagues = db.query(league).all()
        return leagues
    except Exception as e:
        return(f"Error retrieving leagues: {e}")
    
def get_league_by_id(db: Session, id: int):
    try:
        leagues = db.query(league).filter_by(league_id=id).first()
        return leagues
    except Exception as e:
        return(f"Error retrieving leagues: {e}")    
    
def insert_league(db:Session, league_input: LeagueBase):
    try:
        if check_is_valid_name(league_input.league_name):
            new_league = league(league_name=league_input.league_name)
            db.add(new_league)
            db.commit()
            db.refresh(new_league)
            return {"message": f"League inserted successfully", "id": new_league.league_id}
        else:
            raise HTTPException(status_code=400, detail="League name is incorrect")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating league: {e}")
    
def update_league(db:Session, league_input: LeagueBase, id: int):
    try:
        if check_is_valid_name(league_input.league_name):
            league_result = db.query(league).filter_by(league_id=id).first()
            if league_result:
                league_result.league_name = league_input.league_name
                db.commit()
                return {"message": f"League with ID {id} has been updated"}

            else:
                raise HTTPException(status_code=404, detail="League not found")
        else:
            raise HTTPException(status_code=400, detail="League name is incorrect")
    except Exception as e:
        return(f"Error updating league: {e}")
    
def delete_league_by_id(db:Session, id: int):
    try:        
        league_to_delete = db.query(league).filter_by(league_id=id).first()
        if league_to_delete:
            db.delete(league_to_delete)
            db.commit()
        db.close()
        return {"message": "League deleted successfully"}

    except Exception as e:
        return(f"Error deleting League: {e}")

#endregion
    

#region sport

def get_sports(db: Session):
    try:
        result = db.query(sport).all()
        return result
    except Exception as e:
        return(f"Error retrieving sports: {e}")
    
def get_sport(db: Session, id : int):
    try:
        result = db.query(sport).filter_by(sport_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving sport: {e}")


def insert_sport(db:Session, new_sport: SportBase):
    try:
        if check_is_valid_name(new_sport.sport_name):
            new = sport(sport_name=new_sport.sport_name)
            db.add(new)
            db.commit()
            db.refresh(new)
            return {"message": f"Sport inserted successfully", "id": new.sport_id}
        else:
            raise HTTPException(status_code=400, detail="Sport name is incorrect")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating Sport: {e}")
    
def update_sport(db:Session, new_sport: SportBase, id: int):
    try:
        if check_is_valid_name(new_sport.sport_name):
            sport_result = db.query(sport).filter_by(sport_id=id).first()
            sport_result.sport_name = new_sport.sport_name

            db.commit()
            db.refresh(sport_result)
            return {"message": f"Sport with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=400, detail="Sport name is incorrect")
    except HTTPException as http_err:
            raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating Sport: {e}")
    
def delete_sport(db:Session, id: int):
    try:       
        sport_to_delete = db.query(sport).filter_by(sport_id=id).first()
        if sport_to_delete:
            db.delete(sport_to_delete)
            db.commit()
        db.close()
        return {"message": "Sport deleted successfully"}

    except Exception as e:
        return(f"Error deleting Sport: {e}")

#endregion

    

    
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
