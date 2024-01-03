import re
from sqlalchemy.orm import Session
from fastapi import Depends, FastAPI, HTTPException
from Backend.models import *
from Backend.schema import *
import bcrypt
from passlib.context import CryptContext

email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
password_regex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$'
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
    if re.fullmatch(name_regex, name):
        return True
    else:
        return False
    
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
    existing_user = get_user_by_email(db, "player", user.player_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.player_email or not user.player_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.player_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_email(user.player_email):
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
    db.commit()

    return {"detail": "Player Registered Successfully", "id": get_user_by_email(db,"player",user.player_email)}

def register_manager(db, user):
    existing_user = get_user_by_email(db, "manager", user.manager_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.manager_email or not user.manager_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.manager_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_email(user.manager_email):
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
    existing_user = get_user_by_email(db, user.user_type, user.user_email)
    
    if existing_user:
        if user.user_type == "manager" and verify_password(user.user_password, existing_user.manager_password):
            return {"user_email": True, "user_password": True}
        elif user.user_type == "player" and verify_password(user.user_password, existing_user.player_password):
            return {"user_email": True, "user_password": True}
        elif user.user_type == "physio" and verify_password(user.user_password, existing_user.physio_password):
            return {"user_email": True, "user_password": True}
        else:
            return {"user_email": True, "user_password": False}
    else:
        return {"user_email": False, "user_password": False}




   
    
def get_user_by_email(db:Session, type: str, email: str):
    # raise HTTPException(status_code=200, detail=email)

    try:
        if type == "manager":
            login_info = db.query(manager_login).filter_by(manager_email=email).first()
        elif type == "player":
            login_info = db.query(player_login).filter_by(player_email=email).first()
        elif type == "physio":
            login_info = db.query(physio_login).filter_by(physio_email=email).first()

       
        return login_info
    except Exception as e:
        return(f"Error retrieving from {type}s: {e}")


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

def update_player_by_id(db:Session, id: int, player: PlayerInfo):
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
        
        
        if player_stats_result:
            db.delete(player_stats_result)
            if player_info_result:
                db.delete(player_info_result)
            
            if player_injuries_result:
                db.delete(player_injuries_result)
        db.delete(player)
        db.commit()
        db.close()
        return {"message": f"Player with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")
    

def delete_player_by_email(db:Session, email: str):
    try:        
        player = db.query(player_login).filter_by(player_email=email).first()
        player_info = db.query(player_info).filter_by(player_id=id).first()
        player_stats = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries = db.query(player_injuries).filter_by(player_id=player.player_id).first()
        
        db.delete(player)
        if player_info:
            db.delete(player_info)
        if player_stats:
            db.delete(player_stats)
        if player_injuries:
            db.delete(player_injuries)
        db.commit()
        db.close()
        return {"message": f"Player with Email {email} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")



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
        db.query(player_stats).delete()
        db.query(player_injuries).delete()
        db.query(player_info).delete()
        db.query(player_login).delete()
        db.query(physio_info).delete()
        db.query(physio_login).delete()
        db.query(team).delete()
        db.query(league).delete()

        db.query(manager_info).delete()
        db.query(manager_login).delete()
        db.query(sport).delete()
        db.flush()

        db.execute("ALTER SEQUENCE manager_login_manager_id_seq RESTART WITH 1;")
        # db.execute("ALTER SEQUENCE manager_info RESTART WITH 1;") 
        db.execute("ALTER SEQUENCE league_league_id_seq RESTART WITH 1;") 

        db.execute("ALTER SEQUENCE player_login_player_id_seq RESTART WITH 1;")  
        # db.execute("ALTER SEQUENCE player_info RESTART WITH 1;")  

        db.execute("ALTER SEQUENCE team_team_id_seq RESTART WITH 1;")  

        db.execute("ALTER SEQUENCE sport_sport_id_seq RESTART WITH 1;")  


        # db.execute("ALTER SEQUENCE physio_login RESTART WITH 1;")  
        # db.execute("ALTER SEQUENCE physio_info RESTART WITH 1;") 


        db.commit()
        db.close()
        return {"message": "Finished Cleanup"}

    except Exception as e:
        return(f"Error cleaning up: {e}")

