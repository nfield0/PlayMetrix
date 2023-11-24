from typing import Union
from sqlalchemy.orm import Session
from models import league
from typing import List
from database import SessionLocal, Base, engine
from fastapi import Depends, FastAPI, HTTPException
import schema
import crud

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


## To Run Uvicorn
# python -m uvicorn main:app --reload

## For Interactive Documentation (Swagger UI)
# http://127.0.0.1:8000/docs
# /redoc for ReDoc Documentation


@app.get("/")
def read_root():
    return {"Detail:", "results"}


@app.get("/leagues/")
def read_leagues(db:Session = Depends(get_db)):
     users = db.query(league).all()
     return users


