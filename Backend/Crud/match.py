from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import matches
from schema import MatchBase
from models import player_stats
from sqlalchemy import and_

def get_match(db: Session, id: int):
    try:
        result = db.query(matches).filter_by(match_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving matches: {e}")
    

def get_match_by_schedule_player_id(db, id, player_id):
    try:
        result = db.query(matches).filter_by(schedule_id=id, player_id=player_id).first()
        return result
    except Exception as e:
        return(f"Error retrieving matches: {e}")
    
def get_match_by_player_id(db, id):
    try:
        result = db.query(matches).filter_by(player_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving matches: {e}")
    
def get_minutes_played_by_player_id(db, id):
    try:
        result = db.query(matches).filter_by(player_id=id).all()
        minutes_played = 0
        for match in result:
            minutes_played += match.minutes_played
        return minutes_played
    except Exception as e:
        return(f"Error retrieving matches: {e}")
    
def insert_match(db: Session, match: MatchBase):
    try:
        new_match = matches(**match.model_dump())
        db.add(new_match)
        db.commit()
        db.refresh(new_match)
        return {"message": "Player Match inserted successfully", "id": new_match.match_id}
    except Exception as e:
        return (f"Error inserting match: {e}")
    
def update_match(db: Session, match: MatchBase, pid: int, sid: int):
    try:
        db.query(matches).filter(match.player_id==pid, match.schedule_id==sid).update(match.model_dump())
        db.commit()
        return db.query(matches).filter(matches.match_id == id).first()
    except Exception as e:
        return(f"Error updating matches: {e}")
    
def update_minutes(db: Session, minutes: int, pid: int, sid: int):
    try:
        result = db.query(matches).filter_by(player_id=pid, schedule_id=sid).first()
        print(result.minutes_played)

        result.minutes_played = minutes
        db.commit()
        db.refresh(result)
        print(result.minutes_played)

        return {"message": "Minutes Updated Successfully to " + str(result.minutes_played)}
    except Exception as e:
        return(f"Error updating matches: {e}")

def delete_match(db: Session, id: int):
    try:
        db.query(matches).filter(matches.match_id == id).delete(synchronize_session=False)
        db.commit()
        return {"message": "Match deleted successfully"}
    except Exception as e:
        return(f"Error deleting matches: {e}")

def calculate_matches_played(db: Session, id: int):
    try:
        condition = and_(matches.player_id == id, matches.minutes_played >= 0)
        
        matches_played = db.query(matches).filter(condition).all()
        return len(matches_played)
    except Exception as e:
        return(f"Error retrieving matches: {e}")

def update_matches_played(db: Session, player_id: int):
    try:
        result = db.query(player_stats).filter_by(player_id=player_id).first()
        result.matches_played = calculate_matches_played(db, player_id)
        db.commit()
        return {"message": "Matches Played Updated Successfully"}
    except Exception as e:
        return(f"Error updating matches: {e}")