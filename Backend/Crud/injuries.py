from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import injuries, player_injuries
from schema import InjuryBase, PlayerInjuryBase
from Crud.crud import check_is_valid_name

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
                                  injury_location=new_injury.injury_location,
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
            injury_to_update.injury_location = updated_injury.injury_location
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
        result = db.query(player_injuries).filter_by(player_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving player injuries: {e}")
    
def insert_new_player_injury(db:Session, new_player_injury: PlayerInjuryBase):
    try:
        if new_player_injury is not None:
            new_player_injury = player_injuries(player_id=new_player_injury.player_id,
                                                date_of_injury=new_player_injury.date_of_injury,
                                                date_of_recovery=new_player_injury.date_of_recovery,
                                                injury_id=new_player_injury.injury_id,
                                                report_id = new_player_injury.report_id)
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
            player_injury_to_update.date_of_injury = updated_player_injury.date_of_injury
            player_injury_to_update.date_of_recovery = updated_player_injury.date_of_recovery
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
