from sqlalchemy.orm import Session
from models import *
from schema import *
from Crud.crud import *
from Crud.user import *
from Crud.manager import *
from Crud.player import *
from Crud.physio import *

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