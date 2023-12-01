
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
        
    
def get_managers_login(db: Session):
    try:
        managers = db.query(manager_login).all()
        return managers
    except Exception as e:
        return(f"Error retrieving managers: {e}")
        
    
# def get_managers_login_by_id(db: Session, id):
#     try:
#         managers = db.query(manager_login).filter_by(manager_login_id == id)
#         return managers
#     except Exception as e:
#         print(f"Error retrieving managers: {e}")
#         return []    


    
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

        return {"message": f"Manager and manager info with ID {id} has been updated"}
    except Exception as e:
        return (f"Error retrieving from managers: {e}")


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
        
    


    
def delete_player(db: Session):
    try:
        num_rows_deleted = db.session.query(player_login).delete()
        print(num_rows_deleted)
        db.commit()

        # db.query(player_login).delete()
        # # if not users:
        # #     raise HTTPException(status_code=404, detail="No Players found")
        
        # # for user in users:
        # #     db.delete(user)
        
        # db.commit()
        return {"message": "All Players deleted successfully"}
    except Exception as e:
        print(f"Error deleting players: {e}")
        return []

