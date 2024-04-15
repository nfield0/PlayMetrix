
from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import manager_login, manager_info
from schema import Manager, ManagerInfo, ManagerNoID
from security import check_email, check_password_regex, encrypt_password, decrypt_hex, encrypt, check_is_valid_name

#region managers

def get_manager_by_id(db:Session, id: int):
    try:        
        login_info = db.query(manager_login).filter_by(manager_id= id).first()


        return login_info
    except Exception as e:
        return(f"Error retrieving from managers: {e}")
    
def get_all_manager_info_by_id(db:Session, id: int):
    try:        
        login_info = db.query(manager_login).filter_by(manager_id= id).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= id).first()

        if manager_info_result:
            manager = ManagerNoID(manager_email=login_info.manager_email,manager_password="Hidden",
                                  manager_firstname=manager_info_result.manager_firstname,manager_surname=decrypt_hex(manager_info_result.manager_surname),
                                  manager_contact_number=decrypt_hex(manager_info_result.manager_contact_number),manager_image=manager_info_result.manager_image,
                                  manager_2fa=login_info.manager_2fa)
            
        else:
            manager = Manager(manager_id=login_info.manager_id,manager_email=login_info.manager_email,manager_password="Hidden")
        return manager
    except Exception as e:
        return(f"Error retrieving from managers: {e}")
    
def get_all_managers_login(db: Session):
    try:
        managers = db.query(manager_login).all()
        return managers
    except Exception as e:
        return(f"Error retrieving managers: {e}")
    
def update_manager_by_id(db:Session, manager: ManagerNoID, id: int):
    try:        
        manager_to_update = db.query(manager_login).filter_by(manager_id= id).first()
        
        if not manager_to_update:
            raise HTTPException(status_code=404, detail="Manager not found")
        
        if check_email(str(manager.manager_email)):
            manager_to_update.manager_email = manager.manager_email
        else:
                raise HTTPException(status_code=400, detail="Email format invalid")

        if check_password_regex(str(manager.manager_password)):
            manager_to_update.manager_password = encrypt_password(manager.manager_password)
        else:
            raise HTTPException(status_code=400, detail="Password format invalid")
        
        if not check_is_valid_name(manager.manager_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(manager.manager_surname):
            raise HTTPException(status_code=400, detail="Surname format invalid")

        manager_info_to_update = db.query(manager_info).filter_by(manager_id= id).first()

        if not manager_info_to_update:
            new_manager_info = manager_info(manager_id=id,
                                        manager_firstname=manager.manager_firstname,
                                        manager_surname=encrypt(manager.manager_surname),
                                        manager_contact_number=encrypt(manager.manager_contact_number),
                                        manager_image = manager.manager_image,
                                        manager_2fa=manager_to_update.manager_2fa)
            db.add(new_manager_info)
        else:
            manager_info_to_update.manager_firstname = manager.manager_firstname
            manager_info_to_update.manager_surname = encrypt(manager.manager_surname)
            manager_info_to_update.manager_contact_number = encrypt(manager.manager_contact_number)
            manager_info_to_update.manager_image = manager.manager_image
            manager_info_to_update.manager_2fa = manager_to_update.manager_2fa

            # raise HTTPException(status_code=404, detail="Manager Info not found")
        
        db.commit()

        return {"message": f"Manager and manager info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}

def update_manager_login_by_id(db:Session, manager: Manager, id: int):
    try:        
        manager_to_update = db.query(manager_login).filter_by(manager_id= id).first()
        
        if not manager_to_update:
            raise HTTPException(status_code=404, detail="Manager not found")
        
        if not check_email(str(manager.manager_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        manager_to_update.manager_email = manager.manager_email

        if not check_password_regex(str(manager.manager_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        manager_to_update.manager_password = encrypt_password(manager.manager_password)
        manager_to_update.manager_2fa = manager.manager_2fa
        
        db.commit()

        return {"message": f"Manager Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}
    
def update_manager_info_by_id(db:Session, manager: ManagerInfo, id: int):
    try:        
        manager_info_to_update = db.query(manager_info).filter_by(manager_id= id).first()
        
        if not manager_info_to_update:
            raise HTTPException(status_code=404, detail="Manager Info not found")
        
        if not check_is_valid_name(manager.manager_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(manager.manager_surname):
            raise HTTPException(status_code=400, detail="Surname format invalid")
        
        manager_info_to_update.manager_firstname = manager.manager_firstname
        manager_info_to_update.manager_surname = encrypt(manager.manager_surname)
        manager_info_to_update.manager_contact_number = encrypt(manager.manager_contact_number)
        manager_info_to_update.manager_image = manager.manager_image
        
        db.commit()

        return {"message": f"Manager Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating managers: {e}"}


def delete_manager_by_id(db:Session, id: int):
    try:        
        manager = db.query(manager_login).filter_by(manager_id= id).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= id).first()
        if not manager:
            raise HTTPException(status_code=404, detail="Manager not found")
        if manager_info_result:
            db.delete(manager_info_result)
        if manager: 
            db.delete(manager)
        db.commit()
        db.close()
        return {"message": f"Manager and manager info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from managers: {e}")
        
def delete_manager_by_email(db:Session, email: str):
    try:        
        manager = db.query(manager_login).filter_by(manager_email=email).first()
        manager_info_result = db.query(manager_info).filter_by(manager_id= manager.manager_id).first()
        if not manager:
            raise HTTPException(status_code=404, detail="Manager not found")
        if manager_info_result:
            db.delete(manager_info_result)
        if manager: 
            db.delete(manager)
        db.commit()
        db.close()
        return {"message": f"Manager and manager info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from managers: {e}")

#endregion
