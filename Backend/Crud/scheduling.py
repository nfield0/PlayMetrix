from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import schedule, team_schedule, player_schedule
from schema import ScheduleBase, ScheduleBaseNoID, TeamScheduleBase, PlayerScheduleBase
from Crud.teams import get_team_by_id
from Crud.player import get_player_by_id
from Crud.match import matches
from Crud.announcement import announcements

#region schedules
    

def get_schedules(db: Session):
    try:
        result = db.query(schedule).all()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")
    
def get_team_schedules_by_type(db: Session, type: str, id: int):
    try:
        result = db.query(team_schedule).filter_by(team_id=id).all()
        if result:
            #due to the way db table is structured for schedule, need to extract ids from second table correctly
            result_schedule_ids = []
            for item in result:
                schedule_id = item.schedule_id
                if schedule_id is not None:
                    result_schedule_ids.append(schedule_id)

            schedules = db.query(schedule).filter(schedule.schedule_id.in_(result_schedule_ids), schedule.schedule_type == type).all()
            selected_schedule = []
            for sch in schedules:
                if sch.schedule_type == type:
                    selected_schedule.append(sch)
            return selected_schedule
        raise HTTPException(status_code=404, detail="No schedules found")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return(f"Error retrieving schedules: {e}")
    
def get_team_schedules_by_date(db: Session, team_id: int, date: str):
    try:
        result = db.query(schedule).filter_by(team_id=team_id, schedule_start_time=date).all()
        return result
    except Exception as e:
        return(f"Error retrieving schedules: {e}")
    
def get_team_schedules_by_location(db: Session, team_id: int, location: str):
    try:
        result = db.query(schedule).filter_by(team_id=team_id, schedule_location=location).all()
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


def insert_new_schedule(db:Session, req_schedule: ScheduleBaseNoID):
    try:
        if req_schedule is not None:
            new_schedule = schedule(
                                    schedule_type=req_schedule.schedule_type,
                                    schedule_location=req_schedule.schedule_location,
                                    schedule_title=req_schedule.schedule_title,
                                    schedule_start_time=req_schedule.schedule_start_time,
                                    schedule_end_time=req_schedule.schedule_end_time,
                                    schedule_alert_time=req_schedule.schedule_alert_time)
            db.add(new_schedule)
            db.commit()
            db.refresh(new_schedule)
            new_team_schedule = team_schedule(schedule_id=new_schedule.schedule_id, team_id=req_schedule.team_id)
            db.add(new_team_schedule)
            db.commit()
            db.refresh(new_team_schedule)
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
        team_schedule_to_delete = db.query(team_schedule).filter_by(schedule_id=id).first()
        player_schedule_to_delete = db.query(player_schedule).filter_by(schedule_id=id).all()
        matches_to_delete = db.query(matches).filter_by(schedule_id=id).all()
        announcements_to_delete = db.query(announcements).filter_by(schedule_id=id).all()
        if team_schedule_to_delete:
            db.delete(team_schedule_to_delete)
            db.commit()
        
        if player_schedule_to_delete:
            db.delete(player_schedule_to_delete)
            db.commit()
        if matches_to_delete:
            db.delete(matches_to_delete)
            db.commit()
        if announcements_to_delete:
            db.delete(announcements_to_delete)
            db.commit()
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
        result = db.query(player_schedule).filter_by(schedule_id=id).all()
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
    
def delete_player_schedule_by_id(db:Session, delete_player_id: int, delete_schedule_id: int):
    try:        
        player_schedule_to_delete = db.query(player_schedule).filter_by(player_id=delete_player_id, schedule_id=delete_schedule_id).first()
        if player_schedule_to_delete:
            db.delete(player_schedule_to_delete)
            db.commit()
        db.close()
        return {"message": f"Player with ID {delete_player_id} Schedule deleted successfully"}

    except Exception as e:
        return(f"Error deleting player schedule: {e}")


#endregion
