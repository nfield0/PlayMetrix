from sqlalchemy.orm import Session
from models import *
from schema import *
import Crud.crud as crud
from Crud.security import *
#region user
# def register_user(db, user):
#     # if user.user_type != "player" or "manager" or "coach" or "physio":
#     #     raise HTTPException(status_code=400, detail="Invalid user type")
#     existing_user = get_user_by_email(db, user.user_type, user.user_email)
#     if existing_user:
#         raise HTTPException(status_code=400, detail="Email already registered")
#     if not user.user_email or not user.user_password:
#         raise HTTPException(status_code=400, detail="Email and password are required")
        
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Email format invalid")
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Password format invalid")
    
#     if user.user_type == "player":
#         new_user = player_login(player_email=user.user_email, player_password=encrypt_password(user.user_password))
#     elif user.user_type == "manager":
#         new_user = manager_login(manager_email=user.user_email, manager_password=encrypt_password(user.user_password))
#     elif user.user_type == "physio":
#         new_user = physio_login(physio_email=user.user_email, physio_password=encrypt_password(user.user_password))

#     db.add(new_user)
#     db.commit()
#     db.refresh(new_user)
#     return {"detail": f"{user.user_type.capitalize()} Registered Successfully", "id": get_user_by_email(db,user.user_type,user.user_email)}

def change_password(db, user):
    user.user_email = user.user_email.lower()
    existing_user = get_user_details_by_email_password(db, user.user_email, user.old_user_password)

    if not existing_user:
        raise HTTPException(status_code=400, detail="User details incorrect")
    if existing_user.user_password == False:
        raise HTTPException(status_code=400, detail="User details incorrect")
    if not user.user_email or not user.old_user_password or not user.new_user_password:
        raise HTTPException(status_code=400, detail="Email and both passwords are required")
    if not check_email(user.user_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.old_user_password) or not check_password_regex(user.new_user_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    if user.old_user_password == user.new_user_password:
        raise HTTPException(status_code=400, detail="New password cannot be the same as the old password")

    user_details = get_user_by_email(db, existing_user.user_type, user.user_email)
    if existing_user.user_type == "manager":
        user_details.manager_password = encrypt_password(user.new_user_password)
    elif existing_user.user_type == "player":
        user_details.player_password = encrypt_password(user.new_user_password)
    elif existing_user.user_type == "physio":
        user_details.physio_password = encrypt_password(user.new_user_password)
    elif existing_user.user_type == "coach":
        user_details.coach_password = encrypt_password(user.new_user_password)
    else:
        raise HTTPException(status_code=400, detail="Invalid user type") 
    db.commit()
    return {"detail": "Password Changed Successfully"}



#20MB encodes larger so allow some excess
max_image_size_bytes = 23087450




def register_player(db, user):
    user.player_email = user.player_email.lower()
    existing_user = check_user_exists_by_email(db, user.player_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.player_email or not user.player_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.player_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.player_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    
    if len(user.player_image) > max_image_size_bytes:
        raise HTTPException(status_code=400, detail="Image size exceeds the maximum allowed size")
    
    new_user = player_login(player_email=user.player_email, player_password=encrypt_password(user.player_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_id = get_user_by_email(db,"player",user.player_email)
    new_user_info = player_info(player_id=new_user_id.player_id, player_firstname=user.player_firstname,player_surname=encrypt(user.player_surname),
                                player_dob=user.player_dob,player_contact_number=encrypt(user.player_contact_number),
                                player_image=user.player_image,player_height=user.player_height,player_gender=user.player_gender)
                                   
    db.add(new_user_info)

    new_user_stats = player_stats(player_id=new_user_id.player_id, matches_played=0, matches_started=0, 
                                  matches_off_the_bench=0, injury_prone=False)
    db.add(new_user_stats)
    db.commit()
    db.refresh(new_user_stats)

    return {"detail": "Player Registered Successfully", "id": new_user.player_id}

def register_manager(db, user):
    user.manager_email = user.manager_email.lower()
    existing_user = check_user_exists_by_email(db, user.manager_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.manager_email or not user.manager_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.manager_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.manager_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    if len(user.manager_image) > max_image_size_bytes:
        raise HTTPException(status_code=400, detail="Image size exceeds the maximum allowed size")

    new_user = manager_login(manager_email=user.manager_email, manager_password=encrypt_password(user.manager_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_id = get_user_by_email(db,"manager",user.manager_email)
    new_user_info = manager_info(manager_id=new_user_id.manager_id, manager_firstname=user.manager_firstname,manager_surname=encrypt(user.manager_surname),
                                manager_contact_number=encrypt(user.manager_contact_number),
                                manager_image=user.manager_image)              
                      
    db.add(new_user_info)  
    db.commit()
    
    return {"detail": "Manager Registered Successfully", "id": get_user_by_email(db,"manager",user.manager_email)}

def register_physio(db, user):
    user.physio_email = user.physio_email.lower()
    existing_user = check_user_exists_by_email(db, user.physio_email)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if not user.physio_email or not user.physio_password:
        raise HTTPException(status_code=400, detail="Email and password are required")
        
    if not check_email(user.physio_email):
        raise HTTPException(status_code=400, detail="Email format invalid")
    if not check_password_regex(user.physio_password):
        raise HTTPException(status_code=400, detail="Password format invalid")
    if not check_is_valid_name(user.physio_firstname):
        raise HTTPException(status_code=400, detail="First name format invalid")
    if not check_is_valid_name(str(user.physio_surname)):
        raise HTTPException(status_code=400, detail="Surname format invalid")
    if len(user.physio_image) > max_image_size_bytes:
        raise HTTPException(status_code=400, detail="Image size exceeds the maximum allowed size")
    new_user = physio_login(physio_email=user.physio_email, physio_password=encrypt_password(user.physio_password))
    
    db.add(new_user)
    
    db.commit()
    db.refresh(new_user)
    new_user_info = physio_info(physio_id=new_user.physio_id, physio_firstname=user.physio_firstname,physio_surname=encrypt(user.physio_surname),
                                physio_contact_number=encrypt(user.physio_contact_number), physio_image=user.physio_image)
                                   
    db.add(new_user_info)  
    db.commit()

    return {"detail": "Physio Registered Successfully", "id": new_user.physio_id}

def register_coach(db, user):
    try:
        user.coach_email = user.coach_email.lower()
        existing_user = check_user_exists_by_email(db, user.coach_email)
        if existing_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        if not user.coach_email or not user.coach_password:
            raise HTTPException(status_code=400, detail="Email and password are required")
            
        if not check_email(user.coach_email):
            raise HTTPException(status_code=400, detail="Email format invalid")
        if not check_email(user.coach_email):
            raise HTTPException(status_code=400, detail="Password format invalid")
        print(len(user.coach_image))
        if len(user.coach_image) > max_image_size_bytes:
            raise HTTPException(status_code=400, detail="Image size exceeds the maximum allowed size")
        new_user = coach_login(coach_email=user.coach_email, coach_password=encrypt_password(user.coach_password))
        
        db.add(new_user)
        
        db.commit()
        db.refresh(new_user)
        
        surname = encrypt(user.coach_surname)

        new_user_id = get_user_by_email(db,"coach",user.coach_email)
        new_user_info = coach_info(coach_id=new_user_id.coach_id, coach_firstname=user.coach_firstname,coach_surname=surname,
                                    coach_contact=encrypt(user.coach_contact), coach_image=user.coach_image)
                                    
        db.add(new_user_info)  
        db.commit()

        return {"detail": "Coach Registered Successfully", "id": get_user_by_email(db,"coach",user.coach_email)}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return(f"Error registering coaches: {e}")

    
# def register_user_with_info(db, user):
#     # if user.user_type != "player" or "manager" or "coach" or "physio":
#     #     raise HTTPException(status_code=400, detail="Invalid user type")
#     existing_user = get_user_by_email(db, user.user_type, user.user_email)
#     if existing_user:
#         raise HTTPException(status_code=400, detail="Email already registered")
#     if not user.user_email or not user.user_password:
#         raise HTTPException(status_code=400, detail="Email and password are required")
        
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Email format invalid")
#     if not check_email(user.user_email):
#         raise HTTPException(status_code=400, detail="Password format invalid")
    
#     if user.user_type == "player":
#         new_user = player_login(player_email=user.user_email, player_password=user.user_password)
#         new_user_info = player_info(player_firstname="",player_surname="",player_dob="",player_contact_number="",
#                                     player_image=b"",player_height="",player_gender="")
#     elif user.user_type == "manager":
#         new_user = manager_login(manager_email=user.user_email, manager_password=user.user_password)
#         new_user_info = manager_info(manager_firstname="",manager_surname="",manager_contact_number="",manager_image=b"")
#     elif user.user_type == "physio":
#         new_user = physio_login(physio_email=user.user_email, physio_password=user.user_password)
#         new_user_info = physio_info(physio_firstname="",physio_surname="",physio_contact_number="",physio_image=b"")

#     db.add(new_user)
#     db.add(new_user_info)
#     db.commit()
#     db.refresh(new_user)
#     return {"detail": f"{user.user_type.capitalize()} Registered Successfully", "id": get_user_by_email(db,user.user_type,user.user_email)}

    
def login(db, user):
    return get_user_details_by_email_password(db, user.user_email, user.user_password)
    
    # if existing_user:
    #     if user.user_type == "manager" and verify_password(user.user_password, existing_user.manager_password):
    #         return {"user_email": True, "user_password": True}
    #     elif user.user_type == "player" and verify_password(user.user_password, existing_user.player_password):
    #         return {"user_email": True, "user_password": True}
    #     elif user.user_type == "physio" and verify_password(user.user_password, existing_user.physio_password):
    #         return {"user_email": True, "user_password": True}
    #     else:
    #         return {"user_email": True, "user_password": False}
    # else:
    #     return {"user_email": False, "user_password": False}



def get_user_details_by_email_password(db:Session, email: str, password: str):
    # raise HTTPException(status_code=200, detail=email)

    try:
        email = email.lower()
        manager_login_result = db.query(manager_login).filter_by(manager_email=email).first()
        player_login_result = db.query(player_login).filter_by(player_email=email).first()
        physio_login_result = db.query(physio_login).filter_by(physio_email=email).first()
        coach_login_result = db.query(coach_login).filter_by(coach_email=email).first()


        if manager_login_result:
            return UserLoginBase(user_id=manager_login_result.manager_id, user_type="manager", user_email=True, user_password=verify_password(password, manager_login_result.manager_password))
        elif player_login_result:
            return UserLoginBase(user_id=player_login_result.player_id, user_type="player", user_email=True, user_password=verify_password(password, player_login_result.player_password))
        elif physio_login_result:
            return UserLoginBase(user_id=physio_login_result.physio_id, user_type="physio", user_email=True, user_password=verify_password(password, physio_login_result.physio_password))
        elif coach_login_result:
            return UserLoginBase(user_id=coach_login_result.coach_id, user_type="coach", user_email=True, user_password=verify_password(password, coach_login_result.coach_password))
        else:
            raise HTTPException(status_code=400, detail="No user found")
        
    except Exception as e:
        return(f"Error retrieving user: {e}")

def get_user_by_type(db:Session, user: UserType):
    return get_user_by_email(db, user.user_type, user.user_email)

def get_user_by_id_type(db:Session, id: int, type: str):
    try:
        if type == "manager":
            login_info = db.query(manager_login).filter_by(manager_id=id).first()
        elif type == "player":
            login_info = db.query(player_login).filter_by(player_id=id).first()
        elif type == "physio":
            login_info = db.query(physio_login).filter_by(physio_id=id).first()
        elif type == "coach":
            login_info = db.query(coach_login).filter_by(coach_id=id).first()
        else:
            raise HTTPException(status_code=400, detail="Invalid user type")
        
        return login_info
    except Exception as e:
        return(f"Error retrieving from {type}s: {e}")

def check_user_exists_by_email(db:Session, email: str):
    try:
        email = email.lower()
        manager_login_result = db.query(manager_login).filter_by(manager_email=email).first()
        player_login_result = db.query(player_login).filter_by(player_email=email).first()
        physio_login_result = db.query(physio_login).filter_by(physio_email=email).first()
        coach_login_result = db.query(coach_login).filter_by(coach_email=email).first()


        if manager_login_result:
            return True
        elif player_login_result:
            return True
        elif physio_login_result:
            return True
        elif coach_login_result:
            return True
        else:
            return False
        
    except Exception as e:
        return(f"Error retrieving user: {e}")
def get_user_by_email(db:Session, type: str, email: str):
    # raise HTTPException(status_code=200, detail=email)
    try:
        email = email.lower()
        if type == "manager":
            login_info = db.query(manager_login).filter_by(manager_email=email).first()
        elif type == "player":
            login_info = db.query(player_login).filter_by(player_email=email).first()
        elif type == "physio":
            login_info = db.query(physio_login).filter_by(physio_email=email).first()
        elif type == "coach":
            login_info = db.query(coach_login).filter_by(coach_email=email).first()
        else:
            raise HTTPException(status_code=400, detail="Invalid user type")
        
        return login_info
    except Exception as e:
        return(f"Error retrieving from {type}s: {e}")
    
def get_user_details_by_email(db: Session, email :str):
    # raise HTTPException(status_code=200, detail=email)

    try:
        email = email.lower()
        manager_login_result = db.query(manager_login).filter_by(manager_email=email).first()
        player_login_result = db.query(player_login).filter_by(player_email=email).first()
        physio_login_result = db.query(physio_login).filter_by(physio_email=email).first()
        coach_login_result = db.query(coach_login).filter_by(coach_email=email).first()


        if manager_login_result:
            return UserLoginBase(user_id=manager_login_result.manager_id, user_type="manager", user_email=True, user_password=True)
        elif player_login_result:
            return UserLoginBase(user_id=player_login_result.player_id, user_type="player", user_email=True, user_password=True)
        elif physio_login_result:
            return UserLoginBase(user_id=physio_login_result.physio_id, user_type="physio", user_email=True, user_password=True)
        elif coach_login_result:
            return UserLoginBase(user_id=coach_login_result.coach_id, user_type="coach", user_email=True, user_password=True)
        else:
            raise HTTPException(status_code=400, detail="No user found")
        
    except Exception as e:
        return(f"Error retrieving user: {e}") 

#endregion
