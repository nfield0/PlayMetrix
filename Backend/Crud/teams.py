from sqlalchemy.orm import Session
from models import *
from schema import *
from Crud.crud import *
from Crud.user import *
from Crud.manager import *

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