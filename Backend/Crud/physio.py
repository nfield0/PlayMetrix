from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import physio_login, physio_info
from schema import Physio, PhysioInfo, PhysioNoID
from Crud.security import check_email, check_password_regex, encrypt_password, check_is_valid_name


#region physio
    
def get_all_physios(db: Session):
    try:
        result = db.query(physio_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving physios: {e}")
    
def get_physio_login_by_id(db: Session, id: int):
    try:
        result = db.query(physio_login).filter_by(physio_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving physio: {e}")
    
def get_physio_with_info_by_id(db: Session, id: int):
    try:
        result = db.query(physio_login).filter_by(physio_id=id).first()
        info_result = db.query(physio_info).filter_by(physio_id=id).first()

        if info_result:
            physio = PhysioNoID(physio_email=result.physio_email,physio_password="Hidden",
                                  physio_firstname=info_result.physio_firstname,physio_surname=info_result.physio_surname,
                                  physio_contact_number=info_result.physio_contact_number, physio_image=info_result.physio_image)
            return physio
        else:
            raise HTTPException(status_code=404, detail="Physio Info not found")
            
    except Exception as e:
        return(f"Error retrieving physio: {e}")
    

    

def update_physio_by_id(db:Session, physio: PhysioNoID, id: int):
    try:        
        if not check_email(str(physio.physio_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")    
        if not check_password_regex(str(physio.physio_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        if not check_is_valid_name(physio.physio_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(str(physio.physio_surname)):
            raise HTTPException(status_code=400, detail="Surname format invalid")

        #physio login section
        physio_to_update = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio_to_update:
            raise HTTPException(status_code=404, detail="Physio not found")
        physio_to_update.physio_email = physio.physio_email
        physio_to_update.physio_password = encrypt_password(physio.physio_password)
        db.commit()
        #physio info section
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()

        if not physio_info_to_update:
            new_physio_info = physio_info(physio_id=id,
                                        physio_firstname=physio.physio_firstname,
                                        physio_surname=physio.physio_surname,
                                        physio_contact_number=physio.physio_contact_number,
                                        physio_image = physio.physio_image)
            db.add(new_physio_info)
        else:
            physio_info_to_update.physio_firstname = physio.physio_firstname
            physio_info_to_update.physio_surname = physio.physio_surname
            physio_info_to_update.physio_contact_number = physio.physio_contact_number
            physio_info_to_update.physio_image = physio.physio_image
        
        db.commit()

        return {"message": f"Physio and physio info with ID {id} has been updated"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def update_physio_login_by_id(db:Session, physio: Physio, id: int):
    try:        
        physio_to_update = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio_to_update:
            raise HTTPException(status_code=404, detail="Physio not found")
        if not check_email(str(physio.physio_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        physio_to_update.physio_email = physio.physio_email
        if not check_password_regex(str(physio.physio_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        physio_to_update.physio_password = encrypt_password(physio.physio_password)
        
        db.commit()

        return {"message": f"Physio Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def update_physio_info_by_id(db:Session, physio: PhysioInfo, id: int):
    try:        
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()
        if not physio_info_to_update:
            raise HTTPException(status_code=404, detail="Physio Info not found")
        physio_info_to_update.physio_firstname = physio.physio_firstname
        physio_info_to_update.physio_surname = physio.physio_surname
        physio_info_to_update.physio_contact_number = physio.physio_contact_number
        physio_info_to_update.physio_image = physio.physio_image
        
        db.commit()

        return {"message": f"Physio Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def delete_physio_by_id(db:Session, id: int):
    try:        
        physio = db.query(physio_login).filter_by(physio_id= id).first()
        if not physio:
            raise HTTPException(status_code=404, detail="Physio not found")
        physio_info_result = db.query(physio_info).filter_by(physio_id= id).first()
        
        db.delete(physio)
        db.delete(physio_info_result)
        db.commit()
        db.close()
        return {"message": f"Physio and physio info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from physios: {e}")







#endregion
    