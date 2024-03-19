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

def test_get_schedule():
    url = baseUrl + '/schedules/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    expected_json = {
    "schedule_id": 1,
    "schedule_title": "Match 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before"
    }
    try:
        response_json = response.json()
        assert response_json == expected_json
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_schedule_2():
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
        assert response_json['id'] == 2
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_get_schedule_by_type():
    url = baseUrl + '/schedules/1/type/Training'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    expected_json = [{
    "schedule_id": 1,
    "schedule_title": "Match 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before",
    }, {
    "schedule_id": 2,
    "schedule_title": "Training 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00",
    "schedule_alert_time": "1 hour before"
    }]
    try:
        response_json = response.json()
        assert response_json == expected_json
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_schedule():
    url = baseUrl + '/schedules/1'
    headers = {'Content-Type': 'application/json'}
    json = {
        "schedule_id": 1,
    "schedule_title": "Match 1",
    "schedule_location": "Stadium 1",
    "schedule_type": "Match",
    "schedule_start_time": "2024-02-21T12:30:00",
    "schedule_end_time": "2024-02-21T14:30:00",
    "schedule_alert_time": "1 hour before"
    }
    response = requests.put(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_x_delete_schedule():
    url = baseUrl + '/schedules/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.delete(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule deleted successfully"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_z_cleanup():
    url = baseUrl + '/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200