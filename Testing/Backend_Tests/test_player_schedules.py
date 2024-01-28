import requests

def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200


def test_add_schedule():
    url = 'http://127.0.0.1:8000/schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
    "schedule_title": "Match 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before"
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

def test_add_player():
    url = 'http://127.0.0.1:8000/register_player'
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

def test_add_player_schedule():
    url = 'http://127.0.0.1:8000/player_schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
        "schedule_id": 1,
        "player_id": 1,
        "player_attending": True
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        assert response_json.get("message") == "Player Schedule inserted successfully"
        
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player_schedule():
    url = 'http://127.0.0.1:8000/player_schedules/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    expected_json = [{
        "schedule_id": 1,
        "player_id": 1,
        "player_attending": True
    }]
    try:
        response_json = response.json()
        assert response_json == expected_json
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_player_schedule():
    url = 'http://127.0.0.1:8000/player_schedules/1'
    headers = {'Content-Type': 'application/json'}
    json = {
        "schedule_id": 1,
        "player_id": 1,
        "player_attending": False
    }
    response = requests.put(url, headers=headers,json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Player with ID 1 Schedule has been updated"
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_delete_player_schedule():
    url = 'http://127.0.0.1:8000/player_schedules/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Player with ID 1 Schedule deleted successfully"
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




















def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200