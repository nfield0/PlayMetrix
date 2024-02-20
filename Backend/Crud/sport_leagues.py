
from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import league, sport
from schema import LeagueBase, SportBase
from Crud.crud import check_is_valid_name


#region leagues

def get_leagues(db: Session):
    try:
        leagues = db.query(league).all()
        return leagues
    except Exception as e:
        return(f"Error retrieving leagues: {e}")
    
def get_league_by_id(db: Session, id: int):
    try:
        leagues = db.query(league).filter_by(league_id=id).first()
        return leagues
    except Exception as e:
        return(f"Error retrieving leagues: {e}")    
    
def insert_league(db:Session, league_input: LeagueBase):
    try:
        if check_is_valid_name(league_input.league_name):
            new_league = league(league_name=league_input.league_name)
            db.add(new_league)
            db.commit()
            db.refresh(new_league)
            return {"message": f"League inserted successfully", "id": new_league.league_id}
        else:
            raise HTTPException(status_code=400, detail="League name is incorrect")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating league: {e}")
    
def update_league(db:Session, league_input: LeagueBase, id: int):
    try:
        if check_is_valid_name(league_input.league_name):
            league_result = db.query(league).filter_by(league_id=id).first()
            if league_result:
                league_result.league_name = league_input.league_name
                db.commit()
                return {"message": f"League with ID {id} has been updated"}

            else:
                raise HTTPException(status_code=404, detail="League not found")
        else:
            raise HTTPException(status_code=400, detail="League name is incorrect")
    except Exception as e:
        return(f"Error updating league: {e}")
    
def delete_league_by_id(db:Session, id: int):
    try:        
        league_to_delete = db.query(league).filter_by(league_id=id).first()
        if league_to_delete:
            db.delete(league_to_delete)
            db.commit()
        db.close()
        return {"message": "League deleted successfully"}

    except Exception as e:
        return(f"Error deleting League: {e}")

#endregion
    

#region sport

def get_sports(db: Session):
    try:
        result = db.query(sport).all()
        return result
    except Exception as e:
        return(f"Error retrieving sports: {e}")
    
def get_sport(db: Session, id : int):
    try:
        result = db.query(sport).filter_by(sport_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving sport: {e}")


def insert_sport(db:Session, new_sport: SportBase):
    try:
        if check_is_valid_name(new_sport.sport_name):
            new = sport(sport_name=new_sport.sport_name)
            db.add(new)
            db.commit()
            db.refresh(new)
            return {"message": f"Sport inserted successfully", "id": new.sport_id}
        else:
            raise HTTPException(status_code=400, detail="Sport name is incorrect")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating Sport: {e}")
    
def update_sport(db:Session, new_sport: SportBase, id: int):
    try:
        if check_is_valid_name(new_sport.sport_name):
            sport_result = db.query(sport).filter_by(sport_id=id).first()
            sport_result.sport_name = new_sport.sport_name

            db.commit()
            db.refresh(sport_result)
            return {"message": f"Sport with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=400, detail="Sport name is incorrect")
    except HTTPException as http_err:
            raise http_err
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error updating Sport: {e}")
    
def delete_sport(db:Session, id: int):
    try:       
        sport_to_delete = db.query(sport).filter_by(sport_id=id).first()
        if sport_to_delete:
            db.delete(sport_to_delete)
            db.commit()
        db.close()
        return {"message": "Sport deleted successfully"}

    except Exception as e:
        return(f"Error deleting Sport: {e}")

#endregion