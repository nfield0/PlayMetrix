from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import matches
from schema import MatchBase

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
    
def update_match(db: Session, match: MatchBase, id: int):
    try:
        db.query(matches).filter(matches.match_id == id).update(match.model_dump())
        db.commit()
        return db.query(matches).filter(matches.match_id == id).first()
    except Exception as e:
        return(f"Error updating matches: {e}")

def delete_match(db: Session, id: int):
    try:
        db.query(matches).filter(matches.match_id == id).delete(synchronize_session=False)
        db.commit()
        return {"message": "Match deleted successfully"}
    except Exception as e:
        return(f"Error deleting matches: {e}")
    
