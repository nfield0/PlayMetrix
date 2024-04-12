import requests
from test_url import baseUrl
import base64

def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        image_bytes = image_file.read()
        base64_encoded = base64.b64encode(image_bytes).decode('utf-8')
    return base64_encoded

image_path = "Testing/Backend_Tests/test_images/john.png"
image_bytes_1 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/team.jpg"
image_bytes_2 = image_to_base64(image_path)


image_path = "Testing/Backend_Tests/test_images/p1.jpeg"
image_bytes_3 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p2.jpg"
image_bytes_4 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p3.png"
image_bytes_5 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/sarah.png"
image_bytes_physio = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p4.jpg"
image_bytes_6 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p5.jpg"
image_bytes_7 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p6.jpg"
image_bytes_8 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p7.jpg"
image_bytes_9 = image_to_base64(image_path)

image_path = "Testing/Backend_Tests/test_images/p8.jpg"
image_bytes_10 = image_to_base64(image_path)



def test_add_manager():
    url = baseUrl + '/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "john@gmail.com",
        "manager_password": "Testpassword123!",
        "manager_firstname": "John",
        "manager_surname": "Manly",
        "manager_contact_number": "012345",
        "manager_image": image_bytes_1,
        "manager_2fa": False
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Manager Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['manager_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

# def test_add_league():
#     url = baseUrl + '/leagues/'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "league_name": "Louth GAA"
#     }
#     response = requests.post(url, headers=headers, json=json)

#     # assert response.headers['Content-Type'] == 'application/json'

#     try:
#         response_json = response.json()
#         assert response_json.get("message") == "League inserted successfully"
#         assert 'id' in response_json
#         assert response_json['id'] == 1
#         assert response.status_code == 200  

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_add_sport():
#     url = baseUrl + '/sports/'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "sport_name": "Gaelic Rugby"
#     }
#     response = requests.post(url, headers=headers, json=json)

#     assert response.headers['Content-Type'] == 'application/json'

#     try:
#         response_json = response.json()
#         assert response_json.get("message") == "Sport inserted successfully"
#         assert 'id' in response_json
#         assert response_json['id'] == 1
#         assert response.status_code == 200  

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"





def test_add_team():
    url = baseUrl + '/teams/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_name": "Louth Under 21s GAA",
        "team_logo": image_bytes_2,
        "manager_id": 1,
        "league_id": 1,
        "sport_id": 1,
        "team_location": "Dundalk, Louth"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Team inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_schedule():
    url = baseUrl + '/schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
    "schedule_title": "Training 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before",
    "team_id":1
    }

    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_schedule_2():
    url = baseUrl + '/schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
    "schedule_title": "Match 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Match",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before",
    "team_id":1
    }

    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 2
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_add_player():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "niall@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Niall",
        "player_surname": "Dunne",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "12345678",
        "player_image" : image_bytes_3,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 1,
            "team_position": "Defense",
            "player_team_number": 1,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Substitute"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 1 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_add_player_2():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "michael@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Michael",
        "player_surname": "O'Keith",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "12345678",
        "player_image" : image_bytes_4,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 2
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_2():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 2,
            "team_position": "Midfield",
            "player_team_number": 2,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starter"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 2 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_add_player_3():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "james@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "James",
        "player_surname": "O'Rourke",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "12345678",
        "player_image" : image_bytes_5,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 3
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_3():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 3,
            "team_position": "Full Back",
            "player_team_number": 3,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Reserve"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 3 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_player_4():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "johnathan@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "John",
        "player_surname": "O'Neill",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "12345678",
        "player_image" : image_bytes_6,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 4
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_4():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 4,
            "team_position": "Full Back",
            "player_team_number": 4,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starter"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 4 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_player_5():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "richard@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Richard",
        "player_surname": "Oliver",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : image_bytes_7,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 5
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_5():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 5,
            "team_position": "Full Back",
            "player_team_number": 5,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starting 15"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 5 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_player_6():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "stephen@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Stephen",
        "player_surname": "Murphy",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : image_bytes_8,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 6
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_6():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 6,
            "team_position": "Full Back",
            "player_team_number": 6,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starting 15"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 6 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_add_player_7():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "david@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "David",
        "player_surname": "Boyd",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : image_bytes_9,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 7
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_7():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 7,
            "team_position": "Full Back",
            "player_team_number": 7,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starting 15"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 7 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_player_8():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "steve@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Steve",
        "player_surname": "O'Rourke",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : image_bytes_10,
        "player_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    

    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 8
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_player_8():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    json = {
            "team_id": 1,
            "player_id": 8,
            "team_position": "Full Back",
            "player_team_number": 8,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starting 15"
        }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 8 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

# def test_add_player_9():
#     url = baseUrl + '/register_player'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "player_email": "kyle@gmail.com",
#         "player_password": "Testpassword123!",
#         "player_firstname": "Kyle",
#         "player_surname": "Lynch",
#         "player_height": "1.80m",
#         "player_gender": "Male",
#         "player_dob": "1999-05-31",
#         "player_contact_number": "30888802",
#         "player_image" : None,
#         "player_2fa": True
#     }
#     response = requests.post(url, headers=headers, json=json)
    

#     assert response.headers['Content-Type'] == 'application/json'

#     try:
        
#         response_json = response.json()
#         assert response_json.get('detail') == "Player Registered Successfully"
#         assert 'id' in response_json
#         assert response_json['id'] == 9
#         assert response.status_code == 200
    
#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_add_team_player_9():
#     url = baseUrl + '/team_player'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#             "team_id": 1,
#             "player_id": 9,
#             "team_position": "Full Back",
#             "player_team_number": 9,
#             "playing_status": "Playing",
#             "reason_for_status": "Fit to play",
#             "lineup_status": "Starting 15"
#         }
#     response = requests.post(url, headers=headers, json=json)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     try:
#         response_json = response.json()
#         expected_data = {
#             "message":"Player with ID 9 has been added to team with ID 1"
#         }
        
#         assert response_json == expected_data

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_add_player_10():
#     url = baseUrl + '/register_player'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "player_email": "conor@gmail.com",
#         "player_password": "Testpassword123!",
#         "player_firstname": "Conor",
#         "player_surname": "Finnegan",
#         "player_height": "1.80m",
#         "player_gender": "Male",
#         "player_dob": "1999-05-31",
#         "player_contact_number": "30888802",
#         "player_image" : None,
#         "player_2fa": True
#     }
#     response = requests.post(url, headers=headers, json=json)
    

#     assert response.headers['Content-Type'] == 'application/json'

#     try:
        
#         response_json = response.json()
#         assert response_json.get('detail') == "Player Registered Successfully"
#         assert 'id' in response_json
#         assert response_json['id'] == 10
#         assert response.status_code == 200
    
#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_add_team_player_10():
#     url = baseUrl + '/team_player'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#             "team_id": 1,
#             "player_id": 10,
#             "team_position": "Full Back",
#             "player_team_number": 10,
#             "playing_status": "Playing",
#             "reason_for_status": "Fit to play",
#             "lineup_status": "Starting 15"
#         }
#     response = requests.post(url, headers=headers, json=json)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     try:
#         response_json = response.json()
#         expected_data = {
#             "message":"Player with ID 10 has been added to team with ID 1"
#         }
        
#         assert response_json == expected_data

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

def test_add_physio():
    url = baseUrl + '/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Testpassword123!",
        "physio_firstname": "Sarah",
        "physio_surname": "Long",
        "physio_contact_number": "012345",
        "physio_image": image_bytes_physio,
        "physio_2fa": False
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 2
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_add_team_physio():
    url = baseUrl + '/team_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_id": 1,
        "physio_id": 2
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Physio with ID 2 has been added to team with ID 1"

    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"