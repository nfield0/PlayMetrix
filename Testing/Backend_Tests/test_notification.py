import requests


def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200   

def test_adc_manager():
    url = 'http://127.0.0.1:8000/register_manager'
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
    url = 'http://127.0.0.1:8000/leagues/'
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
    url = 'http://127.0.0.1:8000/sports/'
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
    url = 'http://127.0.0.1:8000/teams/'
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

def test_add_notification():
    url = 'http://127.0.0.1:8000/notification'
    headers = {'Content-Type': 'application/json'}
    json = {
        "notification_title": "Test Notification",
        "notification_desc": "Test Description",
        "notification_date": "2024-01-21T00:00:00",
        "team_id": 1,
        "user_type": "manager"
    }
    response = requests.post(url, headers=headers, json=json)
    try:
        response_json = response.json()
        assert response_json.get("message") == "Notification inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_notification():
    url = 'http://127.0.0.1:8000/notification/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    try:
        expected_json = {
        "notification_id": 1,
        "notification_title": "Test Notification",
        "notification_desc": "Test Description",
        "notification_date": "2024-01-21T00:00:00",
        "team_id": 1,
        "user_type": "manager"
        
    }
        response_json = response.json()
        assert response_json == expected_json
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_notification_by_team_type():
    url = 'http://127.0.0.1:8000/notification/1/manager'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    try:
        expected_json = [{
        "notification_id": 1,
        "notification_title": "Test Notification",
        "notification_desc": "Test Description",
        "notification_date": "2024-01-21T00:00:00",
        "team_id": 1,
        "user_type": "manager"
        
    }]
        response_json = response.json()
        assert response_json == expected_json
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_notification():
    url = 'http://127.0.0.1:8000/notification/1'
    headers = {'Content-Type': 'application/json'}
    json = {
        "notification_title": "Test Notification Updated",
        "notification_desc": "Test Description Updated",
        "notification_date": "2024-01-21T00:00:00",
        "team_id": 1,
        "user_type": "manager"
    }
    response = requests.put(url, headers=headers, json=json)
    try:
        response_json = response.json()
        assert response_json.get("message") == "Notification with ID 1 has been updated"
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_delete_notification():
    url = 'http://127.0.0.1:8000/notification/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.delete(url, headers=headers)
    try:
        response_json = response.json()
        assert response_json.get("message") == "Notification deleted successfully"
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"