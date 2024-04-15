from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import physio_login, physio_info, team_physio, player_injuries
from schema import Physio, PhysioInfo, PhysioNoID
from security import check_email, check_password_regex, encrypt_password, check_is_valid_name, encrypt, decrypt_hex


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
                                  physio_firstname=info_result.physio_firstname,physio_surname=decrypt_hex(info_result.physio_surname),
                                  physio_contact_number=decrypt_hex(info_result.physio_contact_number), physio_image=info_result.physio_image,
                                  physio_2fa=result.physio_2fa)
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
        physio_to_update.physio_2fa = physio.physio_2fa
        db.commit()
        #physio info section
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()

        if not physio_info_to_update:
            new_physio_info = physio_info(physio_id=id,
                                        physio_firstname=physio.physio_firstname,
                                        physio_surname=encrypt(physio.physio_surname),
                                        physio_contact_number=encrypt(physio.physio_contact_number),
                                        physio_image = physio.physio_image, physio_2fa=physio_to_update.physio_2fa)
            db.add(new_physio_info)
        else:
            physio_info_to_update.physio_firstname = physio.physio_firstname
            physio_info_to_update.physio_surname = encrypt(physio.physio_surname)
            physio_info_to_update.physio_contact_number = encrypt(physio.physio_contact_number)
            physio_info_to_update.physio_image = physio.physio_image
            physio_info_to_update.physio_2fa = physio_to_update.physio_2fa
        
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
        physio_to_update.physio_2fa = physio.physio_2fa
        db.commit()

        return {"message": f"Physio Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating physio: {e}"}
    
def update_physio_info_by_id(db:Session, physio: PhysioInfo, id: int):
    try:        
        if not check_is_valid_name(physio.physio_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(str(physio.physio_surname)):
            raise HTTPException(status_code=400, detail="Surname format invalid")
        physio_info_to_update = db.query(physio_info).filter_by(physio_id= id).first()
        if not physio_info_to_update:
            raise HTTPException(status_code=404, detail="Physio Info not found")
        physio_info_to_update.physio_firstname = physio.physio_firstname
        physio_info_to_update.physio_surname = encrypt(physio.physio_surname)
        physio_info_to_update.physio_contact_number = encrypt(physio.physio_contact_number)
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
        team_physio_result = db.query(team_physio).filter_by(physio_id= id).all()  
        player_injuries_result = db.query(player_injuries).filter_by(physio_id= id).all()
        
        if player_injuries_result:
            for player_injury in player_injuries_result:
                player_injury.physio_id = 1
                
            db.commit()
            db.refresh(player_injuries_result)
        if physio_info_result:
            db.delete(physio_info_result)
        if team_physio_result:
            db.delete(team_physio_result)
        if physio:
            db.delete(physio)
        db.commit()
        db.close()
        return {"message": f"Physio and physio info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from physios: {e}")




# def get_physio_by_player_id(db: Session, id: int):
#     try:
#         result = db.query(player_physio).filter_by(player_id=id).all()
#         return result
#     except Exception as e:
#         return(f"Error retrieving physio: {e}")
    
# def insert_player_physio(db:Session, player_physio_obj: PhysioPlayerBase):
#     try:
#         if not get_physio_login_by_id(db, player_physio_obj.physio_id):
#             raise HTTPException(status_code=400, detail="Physio ID Does not Exist")
#         if not get_player_by_id(db, player_physio_obj.player_id):
#             raise HTTPException(status_code=400, detail="Player ID Does not Exist")
        
#         new_player_physio = player_physio(report_id = player_physio_obj.report_id, player_id= player_physio_obj.player_id, physio_id= player_physio_obj.physio_id, player_injury_reports= player_physio_obj.player_injury_reports)
#         db.add(new_player_physio)
#         db.commit()
#         return {"message": f"Physio with ID {player_physio_obj.physio_id} has been added to player with ID { player_physio_obj.player_id}"}
#     except HTTPException as http_err:
#         raise http_err
#     except Exception as e:
#         return(f"Error adding physio to player: {e}")

# def get_player_by_id(db: Session, id: int):
#     try:
#         result = db.query(player_info).filter_by(player_id=id).first()
#         return result
#     except Exception as e:
#         return(f"Error retrieving player: {e}")
    
#endregion
    