from sqlalchemy.orm import Session
from PlayMetrix.Backend.models import *
from PlayMetrix.Database.database import SessionLocal, Base, engine
from fastapi import Depends, FastAPI, HTTPException, Response
from fastapi.responses import RedirectResponse
from PlayMetrix.Backend.schema import *
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


#region authentication and registration

@app.post("/register")
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = crud.get_user_by_email(db, user.user_email)

    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    if not user.user_email or not user.user_password:
        raise HTTPException(status_code=400, detail="Email and password are required")

    if user.user_type == "player":
        new_user = player_login(player_email=user.user_email, player_password=user.user_password)
    elif user.user_type == "manager":
        new_user = manager_login(manager_em99653ail=user.user_email, manager_password=user.user_password)
    elif user.user_type == "physio":
        new_user = physio_login(physio_email=user.user_email, physio_password=user.user_password)

    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"detail": f"{user.user_type.capitalize()} Registered Successfully"}


@app.post("/login")
def login_user(user: UserCreate, db: Session = Depends(get_db)):


    if user.user_type == "player":
        existing_user = crud.get_user_by_email(db, user.user_email)
        if existing_user:
            verified = db.query(player_login).filter_by(player_password=user.user_password)
            if verified:
                return player_login(player_email=user.user_email, player_password=user.user_password)
            
    elif user.user_type == "manager":
        existing_user = db.query(manager_login).filter_by(manager_email=user.user_email).first()
        if existing_user:
            verified = crud.get_user_by_email(db, user.user_email)
            if verified:
               return manager_login(manager_email=user.user_email, manager_password=user.user_password)
            
    elif user.user_type == "physio":
        existing_user = crud.get_user_by_email(db, user.user_email)

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

#endregion

#region managers


@app.get("/managers")
def read_managers(db:Session = Depends(get_db)):
    return crud.get_all_managers_login(db)

@app.get("/managers/{id}")
def read_managers(id, db:Session = Depends(get_db)):
    return crud.get_manager_by_id(db, id)

@app.put("/managers/{id}")
def update_managers(id, manager, db:Session = Depends(get_db)):
    return crud.update_manager_by_id(db, id, manager)

@app.delete("/managers/{id}")
def delete_manager(id, db:Session = Depends(get_db)):
    return crud.delete_manager_by_id(db, id)



#endregion

#region teams


@app.get("/teams")
def read_teams(db:Session = Depends(get_db)):
    return crud.get_teams(db)

@app.get("/teams/{id}")
def read_team(id, db:Session = Depends(get_db)):
    return crud.get_team_by_id(db, id)

@app.post("/teams/")
def insert_team(team: TeamBase, db:Session = Depends(get_db)):
    return crud.insert_new_team(db, team)

@app.put("/teams/")
def update_team(id: int, team: TeamBase, db:Session = Depends(get_db)):
    return crud.update_team(db, team, id)

@app.delete("/teams/{id}")
def delete_team(id: int, db:Session = Depends(get_db)):
    return crud.delete_team_by_id(db, id)



#endregion

#region leagues
@app.get("/leagues/")
def read_leagues(db:Session = Depends(get_db)):
    return crud.get_leagues(db)

#endregion



@app.delete("/cleanup_players")
def delete_players(db:Session = Depends(get_db)):
    return crud.delete_player(db)
