
from sqlalchemy.orm import Session
from fastapi import Depends, FastAPI, HTTPException
from PlayMetrix.Backend.models import *
from PlayMetrix.Backend.schema import *


def get_leagues(db: Session):
    try:
        leagues = db.query(league).all()
        return leagues
    except Exception as e:
        return(f"Error retrieving leagues: {e}")


    
def get_all_managers_login(db: Session):
    try:
        managers = db.query(manager_login).all()
        return managers
    except Exception as e:
        return(f"Error retrieving managers: {e}")
    
def get_user_by_email(db:Session, user: UserCreate):
    try:
        if user.user_type == "manager":
            login_info = db.query(manager_login).filter_by(manager_email=user.user_email).first()
        elif user.user_type == "player":
            login_info = db.query(player_login).filter_by(player_email=user.user_email).first()
        elif user.user_type == "physio":
            login_info = db.query(physio_login).filter_by(physio_email=user.user_email).first()
        return login_info
    except Exception as e:
        return(f"Error retrieving from {user.user_type}s: {e}")


#region team
        
def get_teams(db: Session):
    try:
        result = db.query(team).all()
        return result
    except Exception as e:
        return(f"Error retrieving teams: {e}")
    
def get_team_by_id(db: Session, id: int):
    try:
        result = db.query(team).filter_by(team_id=id)
        return result
    except Exception as e:
        return(f"Error retrieving teams: {e}")
       

def insert_new_team(db:Session, new_team: TeamBase):
    try:
        if new_team is not None:
            if get_manager_by_id(db, new_team.manager_id):
                new_team = team(team_name=new_team.team_name,
                    team_logo=new_team.team_logo,
                    manager_id=new_team.manager_id,
                    league_id=new_team.league_id,
                    sport_id=new_team.sport_id,
                    team_location=new_team.team_location)

                db.add(new_team)
                db.commit()
                db.refresh(new_team)

                return {"message": "Team inserted successfully", "team_id": new_team.team_id}
            raise HTTPException(status_code=400, detail="Manager ID Does not Exist")
        return {"message": "Team is empty or invalid"}
    except Exception as e:
        return (f"Error inserting team: {e}")

def update_team(db, team: TeamBase, id):
    try:        
        team_to_update = db.query(team).filter_by(team_id= id).first()
        
        if not team_to_update:
            raise HTTPException(status_code=404, detail="Team not found")
        
        team_to_update.team_name = team.team_name
        team_to_update.team_logo = team.team_logo
        team_to_update.manager_id = team.manager_id 
        team_to_update.league_id = team.league_id 
        team_to_update.sport_id = team.sport_id 
        team_to_update.team_location = team.team_location    

        return {"message": f"Team with ID {id} has been updated"}
    except Exception as e:
        return (f"Error updating Team: {e}")
    

def delete_team_by_id(db:Session, id: int):
    try:        
        team_to_delete = db.query(team).filter_by(team_id= id).first()
        
        if not team_to_delete:
            return {"message": f"Team didn't exist"}
        db.delete(team_to_delete)
        db.commit()
        db.close()
        return {"message": f"Team deleted successfully"}

    except Exception as e:
        return(f"Error deleting team: {e}")


#endregion 


#region managers

def get_manager_by_id(db:Session, id: int):
    try:        
        login_info = db.query(manager_login).filter_by(manager_login_id= id).first()
        return login_info
    except Exception as e:
        return(f"Error retrieving from managers: {e}")

    
def update_manager_by_id(db:Session, id: int, manager: Manager):
    try:        
        manager_to_update = db.query(manager_login).filter_by(manager_login_id= id).first()
        
        if not manager_to_update:
            raise HTTPException(status_code=404, detail="Manager not found")
        
        manager_to_update.manager_email = manager.manager_email
        manager_to_update.manager_password = manager.manager_password

        manager_info_to_update = db.query(manager_info).filter_by(manager_id= id).first()
        if not manager_info_to_update:
            raise HTTPException(status_code=404, detail="Manager Info not found")
        
        manager_info_to_update.manager_firstname = manager.manager_firstname
        manager_info_to_update.manager_surname = manager.manager_surname
        manager_info_to_update.manager_contact_number = manager.manager_contact_number
        manager_info_to_update.manager_image = manager.manager_image


        db.commit()

        return {"message": f"Manager and manager info with ID {id} has been updated"}
    except Exception as e:
        return (f"Error updating managers: {e}")


def delete_manager_by_id(db:Session, id: int):
    try:        
        manager = db.query(manager_login).filter_by(manager_login_id= id).first()
        manager_info = db.query(manager_info).filter_by(manager_id= id).first()
        if not manager:
            raise HTTPException(status_code=404, detail="Manager not found")
        db.delete(manager)
        db.delete(manager_info)
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
        players = []
        if result:
            for player in result:
                player_info_result = db.query(player_info).filter_by(player_id=player.player_login_id).first()
                player_stats_result = db.query(player_stats).filter_by(player_id=player.player_login_id).first()
                # player_injuries_result = db.query(player_injuries).filter_by(player_id=player.player_login_id).first()
                player_entity = PlayerBase(player.player_login_id, player.player_email, player.player_password,
                                        player_info_result.player_firstname, player_info_result.player_surname, player_info_result.player_DOB,
                                            player_info_result.player_contact_number, player_info_result.player_image,
                                            player_stats_result.matches_played, player_stats_result.matches_started,
                                            player_stats_result.matches_off_the_bench, player_stats_result.injury_prone,
                                            player_stats_result.minute_played )
                players.append(player_entity)
            
        return players
    except Exception as e:
        return(f"Error retrieving players: {e}")
    
    
def get_player_by_id(db: Session, id: int):
    try:
        player = db.query(player_login).filter_by(player_login_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player: {e}")
    

def get_player_info_by_id(db:Session, id: int):
    try:
        player = db.query(player_info).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player info: {e}")

def get_player_stats_by_id(db:Session, id: int):
    try:
        player = db.query(player_stats).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player stats: {e}")
    
def update_player_info_by_id(db:Session, id: int, player: PlayerInfo):
    try:
        player_info_to_update = db.query(player_info).filter_by(player_id=id).first()
        if not player_info_to_update:
            raise HTTPException(status_code=404, detail="Player info not found")
        player_info_to_update.player_firstname = player.player_firstname
        player_info_to_update.player_surname = player.player_surname
        player_info_to_update.player_dob = player.player_dob
        player_info_to_update.player_contact_number = player.player_contact_number
        player_info_to_update.player_image = player.player_image

        db.commit()

        return {"message": f"Player info with ID {id} has been updated"}
    except Exception as e:
                return(f"Error retrieving player stats: {e}")




def delete_player(db: Session, id: int):
    try:        
        player = db.query(player_login).filter_by(player_login_id=id).first()
        # remove during production, non-existence can return success
        if not player:
            raise HTTPException(status_code=404, detail="Player not found")
        player_info = db.query(player_info).filter_by(player_id=id).first()
        player_stats = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries = db.query(player_injuries).filter_by(player_id=player.player_login_id).first()
        
        db.delete(player)
        if player_info:
            db.delete(player_info)
        if player_stats:
            db.delete(player_stats)
        if player_injuries:
            db.delete(player_injuries)
        db.commit()
        db.close()
        return {"message": f"Player with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")

#
    # if player:
        #     player_info_result = db.query(player_info).filter_by(player_id=player.player_login_id).first()
        #     player_stats_result = db.query(player_stats).filter_by(player_id=player.player_login_id).first()
        #     #player_injuries_result = db.query(player_injuries).filter_by(player_id=player.player_login_id).first()
        #     player = PlayerBase(player.player_login_id, player.player_email, player.player_password,
        #                                 player_info_result.player_firstname, player_info_result.player_surname, player_info_result.player_DOB,
        #                                     player_info_result.player_contact_number, player_info_result.player_image,
        #                                     player_stats_result.matches_played, player_stats_result.matches_started,
        #                                     player_stats_result.matches_off_the_bench, player_stats_result.injury_prone,
        #                                     player_stats_result.minute_played )


#endregion

