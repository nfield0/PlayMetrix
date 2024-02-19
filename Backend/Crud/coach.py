from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import coach_login, coach_info, team_coach
from schema import Coach, CoachCreate, CoachInfo, TeamCoachBase
from Crud.crud import check_email, check_password_regex, check_is_valid_name, encrypt_password
from Crud.security import decrypt
#region coaches
    
def get_all_coaches(db: Session):
    try:
        result = db.query(coach_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving coaches: {e}")
    
def get_coach_login_by_id(db: Session, id: int):
    try:
        result = db.query(coach_login).filter_by(coach_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving coach: {e}")
    
def get_coach_with_info_by_id(db: Session, id: int):
    try:
        result = db.query(coach_login).filter_by(coach_id=id).first()
        info_result = db.query(coach_info).filter_by(coach_id=id).first()

        if info_result:
            print(type(info_result.coach_surname))
            coach = CoachCreate(coach_email=result.coach_email,coach_password="Hidden",
                                  coach_firstname=info_result.coach_firstname,coach_surname=str(decrypt(info_result.coach_surname)),
                                  coach_contact=info_result.coach_contact, coach_image=info_result.coach_image)
            return coach
        else:
            raise HTTPException(status_code=404, detail="Coach Info not found")
    except HTTPException as http_err:
        raise http_err        
    except Exception as e:
        print(f"Error retrieving coach: {e}")  
        raise
    

def update_coach_by_id(db:Session, coach: CoachCreate, id: int):
    try:        
        if not check_email(str(coach.coach_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")    
        if not check_password_regex(str(coach.coach_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        if not check_is_valid_name(coach.coach_firstname):
            raise HTTPException(status_code=400, detail="First name format invalid")
        if not check_is_valid_name(str(coach.coach_surname)):
            raise HTTPException(status_code=400, detail="Surname format invalid")

        #coach login section
        coach_to_update = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach_to_update:
            raise HTTPException(status_code=404, detail="Coach not found")
        coach_to_update.coach_email = coach.coach_email
        coach_to_update.coach_password = encrypt_password(coach.coach_password)
        #coach info section
        coach_info_to_update = db.query(coach_info).filter_by(coach_id= id).first()

        if not coach_info_to_update:
            new_coach_info = coach_info(coach_id=id,
                                        coach_firstname=coach.coach_firstname,
                                        coach_surname=coach.coach_surname,
                                        coach_contact=coach.coach_contact)
            db.add(new_coach_info)
        else:
            coach_info_to_update.coach_firstname = coach.coach_firstname
            coach_info_to_update.coach_surname = coach.coach_surname
            coach_info_to_update.coach_contact = coach.coach_contact

            # raise HTTPException(status_code=404, detail="Coach Info not found")
        
        db.commit()

        return {"message": f"Coach and coach info with ID {id} has been updated"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    
def update_coach_login_by_id(db:Session, coach: Coach, id: int):
    try:        
        coach_to_update = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach_to_update:
            raise HTTPException(status_code=404, detail="Coach not found")
        if not check_email(str(coach.coach_email)):
            raise HTTPException(status_code=400, detail="Email format invalid")
        coach_to_update.coach_email = coach.coach_email
        if not check_password_regex(str(coach.coach_password)):
            raise HTTPException(status_code=400, detail="Password format invalid")
        coach_to_update.coach_password = encrypt_password(coach.coach_password)
        
        db.commit()

        return {"message": f"Coach Login with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    
def update_coach_info_by_id(db:Session, coach: CoachInfo, id: int):
    try:        
        coach_info_to_update = db.query(coach_info).filter_by(coach_id= id).first()
        if not coach_info_to_update:
            raise HTTPException(status_code=404, detail="Coach Info not found")
        coach_info_to_update.coach_firstname = coach.coach_firstname
        coach_info_to_update.coach_surname = coach.coach_surname
        coach_info_to_update.coach_contact = coach.coach_contact
        if coach.coach_image is not None:
            coach_info_to_update.coach_image = coach.coach_image

        
        db.commit()

        return {"message": f"Coach Info with ID {id} has been updated"}
    except Exception as e:
        return {"message": f"Error updating coach: {e}"}
    

def delete_coach_by_id(db:Session, id: int):
    try:        
        coach = db.query(coach_login).filter_by(coach_id= id).first()
        if not coach:
            raise HTTPException(status_code=404, detail="Coach not found")
        coach_info_result = db.query(coach_info).filter_by(coach_id= id).first()
        
        db.delete(coach)
        db.delete(coach_info_result)
        db.commit()
        db.close()
        return {"message": f"Coach and coach info with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from coaches: {e}")

#endregion
    
#region team_coach
    
def get_team_coaches(db: Session, coach_id: int):
    try:
        result = db.query(team_coach).filter_by(coach_id=coach_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team coaches: {e}")

def get_coach_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_coach).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team coaches: {e}")
    
def insert_team_coach_by_team_id(db:Session, team_coach_obj: TeamCoachBase):
    try:
        new_team_coach = team_coach(team_id=team_coach_obj.team_id, coach_id=team_coach_obj.coach_id, team_role=team_coach_obj.team_role)
        db.add(new_team_coach)
        db.commit()
        return {"message": f"Coach with ID {team_coach_obj.coach_id} has been added to team with ID {team_coach_obj.team_id}"}
    except Exception as e:
        return(f"Error adding coach to team: {e}")
    
def update_team_coach_by_team_id(db:Session, team_coach: TeamCoachBase, id: int):
    try:
        team_to_update = db.query(team_coach).filter_by(team_id=id).first()
        if not team_to_update:
            raise HTTPException(status_code=404, detail="Team not found")
        team_to_update.coach_id = team_coach.coach_id
        db.commit()
        return {"message": f"Team with ID {team_coach.team_id} has been updated"}
    except Exception as e:
        return(f"Error updating team: {e}")
    
def delete_team_coach_by_team_id(db:Session, team_id: int, coach_id: int):
    try:        
        team_to_delete = db.query(team_coach).filter_by(team_id=team_id, coach_id=coach_id).first()
        if team_to_delete:
            db.delete(team_to_delete)
            db.commit()
        return {"message": f"Team with ID {id} has been deleted"}
    except Exception as e:
        return(f"Error deleting team coach: {e}")



#endregion
