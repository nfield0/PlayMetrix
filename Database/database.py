from sqlalchemy import create_engine
from dotenv import load_dotenv, find_dotenv
import os
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import psycopg2
from sqlalchemy import text
from dotenv import load_dotenv

load_dotenv()

# USERNAME = os.getenv("DB_USERNAME")
# PASSWORD = os.getenv("PASSWORD")
# HOST = os.getenv("HOST")
# PORT = os.getenv("PORT")

# DATABASE = os.getenv("DATABASE")


db_connection = os.environ["DB_CONNECTION"]


engine = create_engine(db_connection, connect_args={}, future=True)
# with engine.connect() as conn:
#     result = conn.execute(text("Select * From league;"))
#     for r in result:
#         print(r)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()







# # SQLAlchemy engine
# engine = create_engine(DB_CONNECTION, connect_args={}, future=True)



# try:
#     with engine.connect() as connection_str:
        
#         print('Successfully connected to the PostgreSQL database')
# except Exception as ex:
#     print(f'Sorry failed to connect: {ex}')

