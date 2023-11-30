from sqlalchemy.orm import Session
from PlayMetrix.Backend.models import *
from PlayMetrix.Database.database import SessionLocal, Base, engine
from fastapi import Depends, FastAPI, HTTPException, Response
from fastapi.responses import RedirectResponse
from PlayMetrix.Backend import schema
import PlayMetrix.Backend.crud as crud

Base.metadata.create_all(bind=engine)

app = FastAPI()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

## To install requirements
# python -m pip install -r requirements.txt

## Requires .env file in root directory!

## To Run Uvicorn
# python -m uvicorn main:app --reload
# In Root directory
# python -m uvicorn PlayMetrix.Backend.main:app --reload

## For Interactive Documentation (Swagger UI)
# http://127.0.0.1:8000/docs
# /redoc for ReDoc Documentation

## For testing
# python -m pytest


@app.get("/")
def read_root():
    return {"message:", "Root Page"}

@app.post("/register")
def register_user(user: schema.UserCreate, db: Session = Depends(get_db)):
    existing_player = db.query(player_login).filter_by(player_email=user.user_email).first()
    existing_manager = db.query(manager_login).filter_by(manager_email=user.user_email).first()
    existing_physio = db.query(physio_login).filter_by(physio_email=user.user_email).first()


    if existing_player or existing_manager or existing_physio:
        raise HTTPException(status_code=400, detail="Email already registered")

    if not user.user_email or not user.user_password:
        raise HTTPException(status_code=400, detail="Email and password are required")

    if user.user_type == "player":
        new_user = player_login(player_email=user.user_email, player_password=user.user_password)
    elif user.user_type == "manager":
        new_user = manager_login(manager_email=user.user_email, manager_password=user.user_password)
    elif user.user_type == "physio":
        new_user = physio_login(physio_email=user.user_email, physio_password=user.user_password)


    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"detail": f"{user.user_type.capitalize()} Registered Successfully"}


@app.post("/login")
def login_user(user: schema.UserCreate, db: Session = Depends(get_db)):


    if user.user_type == "player":
        existing_user = db.query(player_login).filter_by(player_email=user.user_email).first()
        if existing_user:
            verified = db.query(player_login).filter_by(player_password=user.user_password)
            if verified:
                return player_login(player_email=user.user_email, player_password=user.user_password)
            
    elif user.user_type == "manager":
        existing_user = db.query(manager_login).filter_by(manager_email=user.user_email).first()
        if existing_user:
            verified = db.query(manager_login).filter_by(manager_password=user.user_password)
            if verified:
               return manager_login(manager_email=user.user_email, manager_password=user.user_password)
            
    elif user.user_type == "physio":
        existing_user = db.query(physio_login).filter_by(physio_email=user.user_email).first()


        if existing_user:
            verified = db.query(physio_login).filter_by(physio_password=user.user_password)
            if verified:
                return physio_login(physio_email=user.user_email, physio_password=user.user_password)

        raise HTTPException(status_code=400, detail="Password is incorrect")
    raise HTTPException(status_code=404, detail="Account with that email does not exist")


@app.get("/logout")
def logout():
  # clear tokens
  SessionLocal.close_all()
  return RedirectResponse(url="/login"), HTTPException(status_code=200)


@app.get("/leagues/")
def read_leagues(db:Session = Depends(get_db)):
    return crud.get_leagues(db)





#.remove

# @app.route("/cleanup_players/", methods=["DELETE", "GET"])
# def delete_players(db:Session = Depends(get_db)):
#     return crud.delete_player(db)


# @app.post("/register_player")
# def register_player(player: schema.PlayerCreate, db: Session = Depends(get_db)):
#     existing_user = db.query(player_login).filter_by(player_email=player_login.player_email).first()
#     if existing_user:
#         raise HTTPException(status_code=400, detail="Email already registered")

#     new_user = player_login(player_email=player.player_email, player_password=player.player_password)
    

#     db.add(new_user)
#     db.commit()
#     db.refresh(new_user)
#     return {"message": "Player Created Successfully", "id": new_user.player_login_id}