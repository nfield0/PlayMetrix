
import requests
import base64
from test_url import baseUrl


def test_adc_manager():
    url = baseUrl + '/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "testmanager@gmail.com",
        "manager_password": "Testpassword123!",
        "manager_firstname": "test",
        "manager_surname": "tester",
        "manager_contact_number": "012345",
        "manager_image": "something",
        "manager_2fa": True
    
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


def test_add_league():
    url = baseUrl + '/leagues/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "league_name": "Louth GAA"
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "League inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_sport():
    url = baseUrl + '/sports/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "sport_name": "Gaelic Rugby"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Sport inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team():
    url = baseUrl + '/teams/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_name": "Louth Under 21s GAA",
        "team_logo": "b'url",
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

def test_add_player():
    url = baseUrl + '/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "testplayer@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Nigel",
        "player_surname": "Farage",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : "001231",
        "player_2fa": True
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
            "team_position": "Full Back",
            "player_team_number": 1,
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
            "message":"Player with ID 1 has been added to team with ID 1"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_team_player():
    url = baseUrl + '/team_player/1'
    headers = {'Content-Type': 'application/json'}  
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = [{
            "team_id": 1,
            "player_id": 1,
            "team_position": "Full Back",
            "player_team_number": 1,
            "playing_status": "Playing",
            "reason_for_status": "Fit to play",
            "lineup_status": "Starting 15"
        }]
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_team_player_file():
    url = baseUrl + '/team_player'
    headers = {'Content-Type': 'application/json'}
    
    with open("Backend\Sample.pdf", "rb") as pdf_file:
        encoded_string = base64.b64encode(pdf_file.read())
        encoded_string = encoded_string.decode()     
    #file_encoded = base64.b64encode(file.read())
    json = {
        "team_id": 1,
        "player_id": 1,
        "team_position": "Full Back",
        "player_team_number": 1,
        "playing_status": "Unavailable",
        "reason_for_status": "Broken Leg",
        "lineup_status": "Starting 15"
    }
    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 1 has been updated"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_team_player_updated():
    url = baseUrl + '/team_player/1'
    headers = {'Content-Type': 'application/json'}  
    response = requests.get(url, headers=headers)
    
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = [{
            "team_id": 1,
            "player_id": 1,
            "team_position": "Full Back",
            "player_team_number": 1,
            "playing_status": "Unavailable",
            "reason_for_status": "Broken Leg",
            "lineup_status": "Starting 15"
        }]
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_players_by_team_id():
    url = baseUrl + '/players_team/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    expected_data = [{
            "team_id": 1,
            "player_id": 1,
            "team_position": "Full Back",
            "player_team_number": 1,
            "playing_status": "Unavailable",
            "reason_for_status": "Broken Leg",
            "lineup_status": "Starting 15"
        }]
    try:
        response_json = response.json()
        assert response_json == expected_data
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_delete_team_player():
    url = baseUrl + '/team_player/1/1'
    headers = {'Content-Type': 'application/json'}  
    response = requests.delete(url, headers=headers)
    
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Player with ID 1 has been deleted from team with ID 1"
        }
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_z_cleanup():
    url = baseUrl + '/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200