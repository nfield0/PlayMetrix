
from sqlalchemy.orm import Session
from fastapi import Depends, FastAPI, HTTPException
from models import *


def get_leagues(db: Session):
    try:
        leagues = db.query(league).all()
        return leagues
    except Exception as e:
        print(f"Error retrieving leagues: {e}")
        return []
    
# def delete_player(db: Session):
#     try:
#         users = db.query(player_login).all()
#         if not users:
#             raise HTTPException(status_code=404, detail="No Players found")
        
#         for user in users:
#             db.delete(user)
        
#         db.commit()
#         return {"message": "All Players deleted successfully"}
#     except Exception as e:
#         print(f"Error deleting players: {e}")
#         return []

