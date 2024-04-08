from sqlalchemy.orm import Session
from fastapi import HTTPException
from models import player_login, player_info, player_stats, player_injuries, player_schedule, matches, team_player
from schema import PlayerBase, PlayerInfo, PlayerStat
from Crud.security import check_email, check_password_regex, encrypt_password, decrypt_hex, encrypt, check_is_valid_name,check_is_valid_contact_number

#region players

def get_players(db: Session):
    try:
        result = db.query(player_login).all()
        return result
    except Exception as e:
        return(f"Error retrieving players: {e}")
    
    # player_info_result = db.query(player_info).filter_by(player_id=player.player_id).first()
    #             player_stats_result = db.query(player_stats).filter_by(player_id=player.player_id).first()
    #             # player_injuries_result = db.query(player_injuries).filter_by(player_id=player.player_id).first()
    #             player_entity = PlayerBase(player.player_id, player.player_email, player.player_password,
    #                                     player_info_result.player_firstname, player_info_result.player_surname, player_info_result.player_DOB,
    #                                         player_info_result.player_contact_number, player_info_result.player_image,
    #                                         player_stats_result.matches_played, player_stats_result.matches_started,
    #                                         player_stats_result.matches_off_the_bench, player_stats_result.injury_prone,
    #                                         player_stats_result.minute_played )
    #             players.append(player_entity)
    
def get_player_by_id(db: Session, id: int):
    try:
        player = db.query(player_login).filter_by(player_id=id).first()
        player = PlayerBase(player_id=player.player_id, player_email=player.player_email, player_password="Hidden", player_2fa=player.player_2fa)
        return player
    except Exception as e:
        return(f"Error retrieving player: {e}")
    


def get_player_info_by_id(db:Session, id: int):
    try:
        player = db.query(player_info).filter_by(player_id=id).first()
        player_decrypted = PlayerInfo(player_id=player.player_id, player_firstname=player.player_firstname,
                                        player_surname=decrypt_hex(player.player_surname), player_dob=str(player.player_dob),
                                        player_contact_number=decrypt_hex(player.player_contact_number), player_image=player.player_image,
                                        player_height=player.player_height, player_gender=player.player_gender)
        return player_decrypted
    except Exception as e:
        return(f"Error retrieving player info: {e}")
    
def create_player_info_by_id(db:Session, id: int):
    try:
        player_info = PlayerInfo(id, "","","","","","")
        db.add(player_info)
        return
    except Exception as e:
        return(f"Error retrieving player info: {e}")

def get_player_stats_by_id(db:Session, id: int):
    try:
        player = db.query(player_stats).filter_by(player_id=id).first()
        return player
    except Exception as e:
        return(f"Error retrieving player stats: {e}")
    
def update_player_info_by_id(db:Session, player: PlayerInfo, id: int):
    try:
        if not check_is_valid_name(player.player_firstname) or not check_is_valid_name(player.player_surname):
            raise HTTPException(status_code=400, detail="Invalid name")
        if not check_is_valid_contact_number(player.player_contact_number):
            raise HTTPException(status_code=400, detail="Invalid contact number")
        player_info_to_update = db.query(player_info).filter_by(player_id=id).first()
        new_player_info = player_info(player_id=player.player_id,
                                      player_firstname=player.player_firstname,
                                      player_surname=encrypt(player.player_surname),
                                      player_dob=player.player_dob,
                                      player_contact_number=encrypt(player.player_contact_number),
                                      player_image=player.player_image,
                                      player_height=player.player_height,
                                      player_gender=player.player_gender
                                      )
	
        if not player_info_to_update:
            db.add(new_player_info)
        else:
        
            player_info_to_update.player_firstname = player.player_firstname
            player_info_to_update.player_surname = encrypt(player.player_surname)
            player_info_to_update.player_dob = player.player_dob
            player_info_to_update.player_contact_number = encrypt(player.player_contact_number)
            player_info_to_update.player_image = player.player_image
            player_info_to_update.player_height = player.player_height
            player_info_to_update.player_gender = player.player_gender


        db.commit()

        return {"message": f"Player info with ID {id} has been updated"}

    except Exception as e:
        return(f"Error retrieving player info: {e}")


def update_player_stat_by_id(db:Session, player: PlayerStat,id: int ):
    try:
        player_stat_to_update = db.query(player_stats).filter_by(player_id=id).first()

        
        
        if not player_stat_to_update:
            new_player_stat = player_stats(player_id = player.player_id,
            matches_played = player.matches_played,
            matches_started = player.matches_started,
            matches_off_the_bench = player.matches_off_the_bench,
            injury_prone = player.injury_prone)
            # raise HTTPException(status_code=404, detail="Player info not found")
            db.add(new_player_stat)
        else:
            player_stat_to_update.player_id = player.player_id
            player_stat_to_update.matches_played = player.matches_played
            player_stat_to_update.matches_started = player.matches_started
            player_stat_to_update.matches_off_the_bench = player.matches_off_the_bench
            player_stat_to_update.injury_prone = player.injury_prone

        db.commit()

        return {"message": f"Player stats with ID {id} has been updated"}
    except Exception as e:
                return(f"Error retrieving player stats: {e}")
    
# def update_minutes_played(db, minutes_played, id):
#     try:
#         player_stat_to_update = db.query(player_stats).filter_by(player_id=id).first()
#         player_stat_to_update.minutes_played += minutes_played
#         db.commit()
#         db.refresh(player_stat_to_update)

#         return {"message": f"Player with ID {id} minutes played set to {player_stat_to_update.minutes_played}"}
#     except Exception as e:
#         return(f"Error updating minutes played: {e}")
    



def update_player_by_id(db:Session,  player: PlayerBase, id: int):
    try:
        player_to_update = db.query(player_login).filter_by(player_id=id).first()
        if not player_to_update:
            raise HTTPException(status_code=404, detail="Player Login not found")
        player_to_update.player_email = player.player_email
        player_to_update.player_password = encrypt_password(player.player_password)
        player_to_update.player_2fa = player.player_2fa

        db.commit()

        return {"message": f"Player Login with ID {id} has been updated"}
    except Exception as e:
        return(f"Error retrieving player login: {e}")

def delete_player(db: Session, id: int):
    try:        
        player = db.query(player_login).filter_by(player_id=id).first()
        player_info_result = db.query(player_info).filter_by(player_id=id).first()
        player_stats_result = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries_result = db.query(player_injuries).filter_by(player_id=id).all()
        player_schedule_result = db.query(player_schedule).filter_by(player_id=id).all()
        matches_result = db.query(matches).filter_by(player_id=id).all()
        player_team_result = db.query(team_player).filter_by(player_id=id).all()
        
        if player_injuries_result:
            db.delete(player_injuries_result) 
            db.commit()
        if player_stats_result:
            db.delete(player_stats_result)
            db.commit()
        if player_info_result:
            db.delete(player_info_result)
            db.commit()
        if player_schedule_result:
            db.delete(player_schedule_result)
            db.commit()
        if matches_result:
            db.delete(matches_result)
            db.commit()
        if player_team_result:
            db.delete(player_team_result)
            db.commit()
        if player:
            db.delete(player)
            db.commit()	
        db.commit()
        db.close()
        return {"message": f"Player with ID {id} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")
    

def delete_player_by_email(db:Session, email: str):
    try:        
        player = db.query(player_login).filter_by(player_email=email).first()
        player_info_result = db.query(player_info).filter_by(player_id=id).first()
        player_stats_result = db.query(player_stats).filter_by(player_id=id).first()
        player_injuries_result = db.query(player_injuries).filter_by(player_id=id).all()
        player_schedule_result = db.query(player_schedule).filter_by(player_id=id).all()
        matches_result = db.query(matches).filter_by(player_id=id).all()
        player_team_result = db.query(team_player).filter_by(player_id=id).all()
        
        if player_injuries_result:
            db.delete(player_injuries_result) 
            db.commit()
        if player_stats_result:
            db.delete(player_stats_result)
            db.commit()
        if player_info_result:
            db.delete(player_info_result)
            db.commit()
        if player_schedule_result:
            db.delete(player_schedule_result)
            db.commit()
        if matches_result:
            db.delete(matches_result)
            db.commit()
        if player_team_result:
            db.delete(player_team_result)
            db.commit()
        if player:
            db.delete(player)
            db.commit()	
        db.commit()
        db.close()
        return {"message": f"Player with Email {email} has been deleted"}

    except Exception as e:
        return(f"Error deleting from players: {e}")



#endregion