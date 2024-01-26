![playmetrix logo](https://github.com/nfield0/PlayMetrix/assets/92158821/e4b55b7b-811a-4d42-a085-07eb40b67c6b)



All-in-one player tracking App (Recovery, Statistics &amp; Scheduling)

This repository is for our Final Year Computing in Software Development Collaborative Project.


This application has several Key Features:
1. Allows Managers of sports team to make team selections based on player injuries and performance.
2. Allows Physios to upload injury information to the app.
3. Players can view their own statistics regarding recovery and performance.


## Technologies Used

<div align="center">
<img src="https://github.com/nfield0/PlayMetrix/assets/92158821/001448fb-5083-4536-8ec4-76a655a6051a" width="300px">

AWS - for Server Hosting


<img src="https://github.com/nfield0/PlayMetrix/assets/92158821/3e8ecb75-1f5a-406c-a7e7-70802fc65334" width="300px">

PostgreSQL - for Database Management


<img src="https://github.com/nfield0/PlayMetrix/assets/92158821/0f713af8-e38d-4d2e-aea3-a00f7771dd35" width="300px">

FastAPI - for RESTful API's


<img src="https://github.com/nfield0/PlayMetrix/assets/92158821/68149bc7-f7a2-4edd-aab4-5a291359c3df" width="300px">

Flutter - for Frontend Implementation
</div>


### Prerequisites

Database - 
PostgreSQL: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

Backend - 
Python (3.11.5): https://www.python.org/downloads/

Frontend -
Flutter: https://docs.flutter.dev/get-started/install

# Installation & Running
### Install & Setup Database first, then install & run Backend in it's own terminal, and finally install & run Front-end in a separate terminal.


## Database: 
#### Go to PostgreSQL website and download the latest
#### Select your OS and version of PostgreSQL
#### Once installed, open PgAdmin4
#### Add a master password, and remember this as it will be used to run backend later.

### Run the code contained in playmetrixV2.sql to create the database and tables


## Backend:

### To run install automatically, click run button in main.py file. Accept prompt to create Virtual Environment.



### Manual Code setup
> Create a Virtual Environment on Windows (Ctrl + Shift + P in VSCode)
```
python -m venv .venv
```
> Create a Virtual Environment on MacOS
```
source venv/bin/activate
```
> Run Virtual Environment
```
.venv/scripts/activate
```
> Install Requirement libraries
```
python -m pip install -r requirements.txt
```
> Create a new file in your project directory and name it .env. Insert this text inside:
```
DB_CONNECTION = "postgresql://postgres:yourpassword@localhost:5432/yourdatabasename"
```
> Run Backend (Uvicorn)
```
python -m uvicorn Backend.main:app --reload
```
## Backend Testing: 
> Run in new terminal
```
python -m pytest
```
> Interactive Documentation
```
http://127.0.0.1:8000/docs
```



## Frontend:
#### Using VS Code to install Flutter
##### Start Flutter Install
1. Open VS Code
2. Download the **"Flutter" extension** on VS Code
3. Open the Command Palette (```Control```+```Shift```+```P```)
4. Type ```flutter``` in the Command Palette
5. Select **Flutter: New Project**
6. VS Code prompts you to locate the Flutter SDK on your computer.<br/>
<nbsp/><nbsp/><nbsp/><nbsp/>a. If you have the Flutter SDK installed, click **Locate SDK**.<br/>
<nbsp/><nbsp/><nbsp/><nbsp/>b. If you do not have the Flutter SDK installed, click **Download SDK**.
7. When prompted <strong>Which Flutter template?</strong>, ignore it. Press Esc. You can create a test project after checking your development setup.

##### Download the Flutter SDK
1. When the Select Folder for Flutter SDK dialog displays, choose where you want to install Flutter.
> VS Code places you in your user profile to start. Choose a different location.
3. Click **Clone Flutter**. While downloading Flutter, VS Code displays this pop-up notification:
```
Downloading the Flutter SDK. This may take a few minutes.
```
3. Once it finishes downloading Flutter, the Output panel displays:
```
Checking Dart SDK version...
Downloading Dart SDK from the Flutter engine ...
Expanding downloaded archive...
```
> When successful, VS Code displays this pop-up notification:
```
Initializing the Flutter SDK. This may take a few minutes.
```
> When the Flutter install succeeds, VS Code displays this pop-up notification:
```
Do you want to add the Flutter SDK to PATH so it's accessible
in external terminals?
```
4. Click **Add SDK** to PATH.
> When successful, a notification displays:
```
The Flutter SDK was added to your PATH
```
5. To enable ```flutter``` in all PowerShell windows:
<nbsp/><nbsp/><nbsp/><nbsp/>a. Close, then reopen all PowerShell windows.
<nbsp/><nbsp/><nbsp/><nbsp/>b. Restart VS Code.

#### Running the Flutter application
- Open any simulator you want the app to be running on
> Locate to the Frontend folder
```
cd Frontend
```
> Run the application
```
flutter run
```





# Project Links


# Contributors (Team Pesado):

<div align="center">

Conor Begley &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
Nathan Field &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
Michael Flynn &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
Luana Kimley &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
Shakira Lynch &nbsp; &nbsp; &nbsp;

</div>
<div float="left" align="middle">
  
  <img src="https://github.com/nfield0/PlayMetrix/assets/92158821/fa2e41bd-1247-4c7e-b7e1-751c596ad3e5" width="140" height="140" /> &nbsp;
  <img src="https://github.com/nfield0/PlayMetrix/assets/92158821/05ef309a-44a4-44bb-9547-ac0c11f3bffe" width="140" height="140"/> &nbsp;
  <img src="https://github.com/nfield0/PlayMetrix/assets/92158821/893a3f2a-05c3-4992-8573-ed779ec7f791" width="140" height="140"/> &nbsp;
  <img src="https://github.com/nfield0/PlayMetrix/assets/92158821/301fd112-97d8-4842-a2c3-0734933464e2" width="140" height="140"/> &nbsp;
  <img src="https://github.com/nfield0/PlayMetrix/assets/92158821/2c590291-d42b-47fd-a419-4537b8d1f705" width="140" height="140"/> &nbsp;

</div>

# References

AWS: https://aws.amazon.com/

PostgreSQL: https://www.postgresql.org/docs/ 

FastAPI: https://fastapi.tiangolo.com/

Flutter: https://flutter.dev/


