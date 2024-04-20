from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import announcements
from schema import AnnouncementBase, AnnouncementBaseNoID
from Crud.user import get_user_by_id_type
from security import check_is_valid_team_name
#region announcements
    
def get_announcement(db: Session, id: int):
    try:
        result = db.query(announcements).filter_by(announcements_id=id).first()
        return result
    except Exception as e:
        error_message = f"Error retrieving announcement with ID {id}: {e}"
        return error_message

def get_announcement(db: Session, id: int):
    try:
        result = db.query(announcements).filter_by(schedule_id=id).all()
        result.sort(key=lambda x: x.announcements_date, reverse=True)
        return result
    except Exception as e:
        error_message = f"Error retrieving announcement with ID {id}: {e}"
        return error_message
    
def insert_new_announcement(db:Session, new_announcement: AnnouncementBaseNoID):
    try:
        if new_announcement is None:
            raise HTTPException(status_code=400, detail="Announcement is empty or invalid")
        
        if get_user_by_id_type(db, new_announcement.poster_id, new_announcement.poster_type) is None:
            raise HTTPException(status_code=400, detail="{new_announcement.poster_type} ID Does not Exist")

        announcement = announcements(announcements_title=new_announcement.announcements_title,
                                        announcements_desc=new_announcement.announcements_desc,
                                        announcements_date=new_announcement.announcements_date,
                                        schedule_id=new_announcement.schedule_id,
                                        poster_id=new_announcement.poster_id,
                                        poster_type=new_announcement.poster_type)
        db.add(announcement)
        db.commit()
        db.refresh(announcement)
        return {"message": "Announcement inserted successfully", "id": announcement.announcements_id}

    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return (f"Error inserting announcement: {e}")
    
def update_announcement(db, updated_announcement: AnnouncementBase, id: int):

    try:        
        announcement_to_update = db.query(announcements).filter_by(announcements_id= id).first()
        
        if not announcement_to_update:
            raise HTTPException(status_code=404, detail="Announcement not found")
        if get_user_by_id_type(db, updated_announcement.poster_id, updated_announcement.poster_type) is None:
            raise HTTPException(status_code=400, detail="{updated_announcement.poster_type} ID Does not Exist")
        
        announcement_to_update.announcements_title = updated_announcement.announcements_title
        announcement_to_update.announcements_desc = updated_announcement.announcements_desc
        announcement_to_update.announcements_date = updated_announcement.announcements_date
        announcement_to_update.schedule_id = updated_announcement.schedule_id
        announcement_to_update.poster_id = updated_announcement.poster_id
        announcement_to_update.poster_type = updated_announcement.poster_type
        
        db.commit()
        return {"message": f"Announcement with ID {id} has been updated"}
    except Exception as e:
        return(f"Error updating announcement: {e}")
    
def delete_announcement_by_id(db:Session, id: int):
    try:        
        announcement_to_delete = db.query(announcements).filter_by(announcements_id=id).first()
        if announcement_to_delete:
            db.delete(announcement_to_delete)
            db.commit()
        db.close()
        return {"message": "Announcement deleted successfully"}

    except Exception as e:
        return(f"Error deleting announcement: {e}")



#endregion