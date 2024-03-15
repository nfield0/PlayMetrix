import requests
from test_url import baseUrl

def test_add_a_manager():
    url = baseUrl + '/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "testmanager@gmail.com",
        "manager_password": "Testpassword123!",
        "manager_firstname": "test",
        "manager_surname": "tester",
        "manager_contact_number": "012345",
        "manager_image": "something"
    
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

        #prerequisites^^^^^^^


def test_add_schedule():
    url = baseUrl + '/schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
    "schedule_title": "Match 1",
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


#pre-requisites ^^^^^^^^^
        

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
        "player_image" : "001231"
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


def test_add_match():
    url = baseUrl + '/match'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_id": 1,
        "schedule_id": 1,
        "minutes_played": 60
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('message') == "Player Match inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_match():
    url = baseUrl + '/match/1'
    response = requests.get(url)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('player_id') == 1
        assert response_json.get('schedule_id') == 1
        assert response_json.get('minutes_played') == 60
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_match_by_schedule_player_id():
    url = baseUrl + '/match/schedule/1/player/1'
    response = requests.get(url)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('player_id') == 1
        assert response_json.get('schedule_id') == 1
        assert response_json.get('minutes_played') == 60
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_minutes_played_add_prerequisite():
    url = baseUrl + '/match'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_id": 1,
        "schedule_id": 1,
        "minutes_played": 60
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('message') == "Player Match inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 2
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_get_minutes_played_total():
    url = baseUrl + '/match/player/1/minutes_played'
    response = requests.get(url)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json == 120
        assert response.status_code == 200    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"
















def test_delete_match():
    url = baseUrl + '/match/1'
    response = requests.delete(url)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('message') == "Match deleted successfully"
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_z_add_match():
    url = baseUrl + '/match'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_id": 1,
        "schedule_id": 1,
        "minutes_played": 60
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('message') == "Player Match inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 3
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_z_get_match_updated():
    url = baseUrl + '/match/schedule/1/player/1/minutes/40'
    response = requests.put(url)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Minutes Updated Successfully to 40"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



