from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import notifications
from schema import NotificationBase

#region notification
    
def get_notifications(db: Session):
    try:
        result = db.query(notifications).all()
        return result
    except Exception as e:
        return(f"Error retrieving notifications: {e}")

def get_notification_by_id(db: Session, id: int):
    try:
        result = db.query(notifications).filter_by(notification_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving notification: {e}")
    
def insert_notification(db: Session, new_notification: NotificationBase):
    try:
        if new_notification is not None:
            new_notification_obj = notifications(
                notification_title=new_notification.notification_title,
                notification_date=new_notification.notification_date,
                notification_desc=new_notification.notification_desc,
                team_id=new_notification.team_id,
                user_type=new_notification.user_type
            )
            db.add(new_notification_obj)
            db.commit()
            db.refresh(new_notification_obj)
            return {"message": f"Notification inserted successfully", "id": new_notification_obj.notification_id}
        return {"message": f"Notification is empty or invalid"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error inserting notification: {e}")

def update_notification(db, updated_notification: NotificationBase, id):
    try:
        notification_to_update = db.query(notifications).filter_by(notification_id = id).first()
        if notification_to_update:
            notification_to_update.notification_title = updated_notification.notification_title
            notification_to_update.notification_date = updated_notification.notification_date
            notification_to_update.notification_desc = updated_notification.notification_desc
            notification_to_update.team_id = updated_notification.team_id
            notification_to_update.user_type = updated_notification.user_type
            db.commit()
            return {"message": f"Notification with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=404, detail="Notification not found")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:  
        raise HTTPException(status_code=500, detail=f"Error updating notification: {e}")
    
def delete_notification(db:Session, id: int):
    try:        
        notification_to_delete = db.query(notifications).filter_by(notification_id=id).first()
        if notification_to_delete:
            db.delete(notification_to_delete)
            db.commit()
        db.close()
        return {"message": "Notification deleted successfully"}

    except Exception as e:
        return(f"Error deleting notification: {e}")

#endregion