import re
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import text
import os
from fastapi import Depends, FastAPI, HTTPException
from models import *
from schema import *
import bcrypt
from passlib.context import CryptContext
from Crud.user import *
from Crud.teams import *
from Crud.manager import *
from Crud.player import *
from Crud.physio import *



#region announcements
    
def get_announcement(db: Session, id: int):
    try:
        result = db.query(announcements).filter_by(announcements_id=id).first()
        return result
    except Exception as e:
        error_message = f"Error retrieving announcement with ID {id}: {e}"
        return error_message

def get_announcement(db: Session, id: int):
    try:
        result = db.query(announcements).filter_by(schedule_id=id).all()
        return result
    except Exception as e:
        error_message = f"Error retrieving announcement with ID {id}: {e}"
        return error_message
    
def insert_new_announcement(db:Session, new_announcement: AnnouncementBaseNoID):
    try:
        if new_announcement is None:
            raise HTTPException(status_code=400, detail="Announcement is empty or invalid")
        
        if get_user_by_id_type(db, new_announcement.poster_id, new_announcement.poster_type) is None:
            raise HTTPException(status_code=400, detail="{new_announcement.poster_type} ID Does not Exist")

        announcement = announcements(announcements_title=new_announcement.announcements_title,
                                        announcements_desc=new_announcement.announcements_desc,
                                        announcements_date=new_announcement.announcements_date,
                                        schedule_id=new_announcement.schedule_id,
                                        poster_id=new_announcement.poster_id,
                                        poster_type=new_announcement.poster_type)
        db.add(announcement)
        db.commit()
        db.refresh(announcement)
        return {"message": "Announcement inserted successfully", "id": announcement.announcements_id}

    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return (f"Error inserting announcement: {e}")
    
def update_announcement(db, updated_announcement: AnnouncementBase, id: int):

    try:        
        announcement_to_update = db.query(announcements).filter_by(announcements_id= id).first()
        
        if not announcement_to_update:
            raise HTTPException(status_code=404, detail="Announcement not found")
        
        announcement_to_update.announcements_title = updated_announcement.announcements_title
        announcement_to_update.announcements_desc = updated_announcement.announcements_desc
        announcement_to_update.announcements_date = updated_announcement.announcements_date
        announcement_to_update.schedule_id = updated_announcement.schedule_id
        announcement_to_update.poster_id = updated_announcement.poster_id
        announcement_to_update.poster_type = updated_announcement.poster_type
        
        db.commit()
        return {"message": f"Announcement with ID {id} has been updated"}
    except Exception as e:
        return(f"Error updating announcement: {e}")
    
def delete_announcement_by_id(db:Session, id: int):
    try:        
        announcement_to_delete = db.query(announcements).filter_by(announcements_id=id).first()
        if announcement_to_delete:
            db.delete(announcement_to_delete)
            db.commit()
        db.close()
        return {"message": "Announcement deleted successfully"}

    except Exception as e:
        return(f"Error deleting announcement: {e}")



#endregion



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
            coach = CoachCreate(coach_email=result.coach_email,coach_password="Hidden",
                                  coach_firstname=info_result.coach_firstname,coach_surname=info_result.coach_surname,
                                  coach_contact=info_result.coach_contact, coach_image=info_result.coach_image)
            return coach
        else:
            raise HTTPException(status_code=404, detail="Coach Info not found")
            
    except Exception as e:
        return(f"Error retrieving coach: {e}")

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


#region team_physio

def get_team_physio(db: Session, physio_id: int):
    try:
        result = db.query(team_physio).filter_by(physio_id=physio_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team physio: {e}")


def get_physio_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_physio).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team physio: {e}")
    
def insert_team_physio_by_team_id(db:Session, team_physio_obj: TeamPhysioBase):
    try:
        if not get_physio_login_by_id(db, team_physio_obj.physio_id):
            raise HTTPException(status_code=400, detail="Physio ID Does not Exist")
        if not get_team_by_id(db, team_physio_obj.team_id):
            raise HTTPException(status_code=400, detail="Team ID Does not Exist")
        
        new_team_physio = team_physio(team_id= team_physio_obj.team_id, physio_id= team_physio_obj.physio_id)
        db.add(new_team_physio)
        db.commit()
        return {"message": f"Physio with ID {team_physio_obj.physio_id} has been added to team with ID { team_physio_obj.team_id}"}
    except HTTPException as http_err:
        raise http_err
    except Exception as e:
        return(f"Error adding physio to team: {e}")
    
# def update_team_physio_by_team_id(db:Session,  team_physio: ):
#     try:
#         team_to_update = db.query(team_physio).filter_by(team_id=team_id).first()
#         if not team_to_update:
#             raise HTTPException(status_code=404, detail="Team not found")
#         team_to_update.physio_id = physio_id
#         db.commit()
#         return {"message": f"Team with ID {team_id} has been updated"}
#     except Exception as e:
#         return(f"Error updating team: {e}")

def delete_physio_team_id(db:Session, id: int):
    try:        
        team_to_delete = db.query(team_physio).filter_by(team_id=id).first()
        if team_to_delete:
            db.delete(team_to_delete)
            db.commit()
        return {"message": f"Physio from Team with ID {id} has been deleted"}
    except Exception as e:
        return(f"Error deleting team physio: {e}")
    
#endregion

#region team_player

def get_team_players(db: Session, player_id: int):
    try:
        result = db.query(team_player).filter_by(player_id=player_id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team players: {e}")

def get_players_by_team_id(db: Session, id: int):
    try:
        result = db.query(team_player).filter_by(team_id=id).all()
        return result
    except Exception as e:
        return(f"Error retrieving team players: {e}")
    
def add_player_to_team(db:Session, team_player_obj: TeamPlayerBase):
    try:
        new_team_player = team_player(team_id=team_player_obj.team_id, player_id=team_player_obj.player_id, team_position=team_player_obj.team_position, player_team_number=team_player_obj.player_team_number,
                                       playing_status=team_player_obj.playing_status, lineup_status=team_player_obj.lineup_status)
        db.add(new_team_player)
        db.commit()
        return {"message": f"Player with ID {str(team_player_obj.player_id)} has been added to team with ID {str(team_player_obj.team_id)}"}
    except Exception as e:
        return(f"Error adding player to team: {e}")
    
def update_player_on_team(db:Session, team_player_obj: TeamPlayerBase):
    try:
        player_to_update = db.query(team_player).filter_by(team_id=team_player_obj.team_id, player_id=team_player_obj.player_id).first()
        if not player_to_update:
            raise HTTPException(status_code=404, detail="Player not found")
        player_to_update.team_position = team_player_obj.team_position
        player_to_update.player_team_number = team_player_obj.player_team_number
        player_to_update.playing_status = team_player_obj.playing_status
        player_to_update.lineup_status = team_player_obj.lineup_status
        db.commit()
        return {"message": f"Player with ID {str(team_player_obj.player_id)} has been updated"}
    except Exception as e:
        return(f"Error updating player position: {e}")


def delete_player_from_team(db:Session, player_id: int, team_id: int ):
    try:        
        player_to_delete = db.query(team_player).filter_by(team_id=team_id, player_id=player_id).first()
        if player_to_delete:
            db.delete(player_to_delete)
            db.commit()
        return {"message": f"Player with ID {player_id} has been deleted from team with ID {team_id}"}
    except Exception as e:
        return(f"Error deleting player from team: {e}")
    

#endregion



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

    
#region notification
    
def get_notifications(db: Session):
    try:
        result = db.query(notifications).all()
        return result
    except Exception as e:
        return(f"Error retrieving notifications: {e}")

def get_notification_by_id(db: Session, id: int):
    try:
        result = db.query(notifications).filter_by(notification_id=id).first()
        return result
    except Exception as e:
        return(f"Error retrieving notification: {e}")
    
def insert_notification(db: Session, new_notification: NotificationBase):
    try:
        if new_notification is not None:
            new_notification_obj = notifications(
                notification_title=new_notification.notification_title,
                notification_date=new_notification.notification_date,
                notification_desc=new_notification.notification_desc,
                team_id=new_notification.team_id,
                poster_id=new_notification.poster_id,
                poster_type=new_notification.poster_type
            )
            db.add(new_notification_obj)
            db.commit()
            db.refresh(new_notification_obj)
            return {"message": f"Notification inserted successfully", "id": new_notification_obj.notification_id}
        return {"message": f"Notification is empty or invalid"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error inserting notification: {e}")

def update_notification(db, updated_notification: NotificationBase, id):
    try:
        notification_to_update = db.query(notifications).filter_by(notification_id = id).first()
        if notification_to_update:
            notification_to_update.notification_title = updated_notification.notification_title
            notification_to_update.notification_date = updated_notification.notification_date
            notification_to_update.notification_desc = updated_notification.notification_desc
            notification_to_update.team_id = updated_notification.team_id
            notification_to_update.poster_id = updated_notification.poster_id
            notification_to_update.poster_type = updated_notification.poster_type
            db.commit()
            return {"message": f"Notification with ID {id} has been updated"}
        else:
            raise HTTPException(status_code=404, detail="Notification not found")
    except HTTPException as http_err:
        raise http_err
    except Exception as e:  
        raise HTTPException(status_code=500, detail=f"Error updating notification: {e}")
    
def delete_notification(db:Session, id: int):
    try:        
        notification_to_delete = db.query(notifications).filter_by(notification_id=id).first()
        if notification_to_delete:
            db.delete(notification_to_delete)
            db.commit()
        db.close()
        return {"message": "Notification deleted successfully"}

    except Exception as e:
        return(f"Error deleting notification: {e}")

#endregion
    
def cleanup(db: Session):
    try:       
        db.query(team_schedule).delete()
        db.query(player_schedule).delete()
        db.query(announcements).delete()
        db.query(schedule).delete()
        
        db.query(team_coach).delete()
        db.query(team_physio).delete()
        db.query(team_player).delete()

        db.query(player_injuries).delete()
        db.query(injuries).delete()
        db.query(team).delete()
        db.query(league).delete()
        db.query(sport).delete()

        db.query(physio_info).delete()
        db.query(physio_login).delete()
        

        db.query(manager_info).delete()
        db.query(manager_login).delete()


        db.query(player_stats).delete()

        db.query(player_info).delete()
        db.query(player_login).delete()

        db.query(coach_info).delete()
        db.query(coach_login).delete()



        db.flush()

        db.execute(text("ALTER SEQUENCE manager_login_manager_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE physio_info_physio_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE league_league_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE player_login_player_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE team_team_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE sport_sport_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE coach_login_coach_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE injuries_injury_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE physio_login_physio_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE announcements_announcements_id_seq RESTART WITH 1;"))
        db.execute(text("ALTER SEQUENCE schedule_schedule_id_seq RESTART WITH 1;"))


        db.commit()
        db.close()
        return {"message": "Finished Cleanup"}

    except SQLAlchemyError as e:
        # Log the exception for debugging
        print(f"Cleanup failed: {e}")
        db.rollback()  # Rollback changes in case of an error
        db.close()  # Close the connection
        return {"error": "Cleanup failed, check logs for details"}
