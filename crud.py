
from sqlalchemy.orm import Session

import models



def get_leagues(db: Session):
    try:
        leagues = db.query(models.League).all()
        return leagues
    except Exception as e:
        print(f"Error retrieving leagues: {e}")
        return []
