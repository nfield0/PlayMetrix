import requests

def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200

def test_add_a_manager():
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

def test_add_announcement():
    url = 'http://127.0.0.1:8000/announcements'
    headers = {'Content-Type': 'application/json'}
    json = {
    "announcements_title": "Test Announcement",
    "announcements_desc": "Test Description",
    "announcements_date": "2024-01-21T00:00:00",
    "schedule_id": 1,
    "poster_id": 1,
    "poster_type": "manager"
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("message") == "Announcement inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_get_announcement():
    url = 'http://127.0.0.1:8000/announcements/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        expected_json = [{
            "announcements_id": 1,
            "announcements_title": "Test Announcement",
            "announcements_desc": "Test Description",
            "announcements_date": "2024-01-21T00:00:00",
            "schedule_id": 1,
            "poster_id": 1,
            "poster_type": "manager"
    
    }]
        response_json = response.json()
        assert response_json == expected_json
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_update_announcement():

    url = 'http://127.0.0.1:8000/announcements/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "announcements_id": 1,
            "announcements_title": "Test Announcement Update",
            "announcements_desc": "Test Description Update",
            "announcements_date": "2025-01-21T00:00:00",
            "schedule_id": 1,
            "poster_id": 1,
            "poster_type": "manager"
    }
    response = requests.put(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        
        response_json = response.json()
        assert response_json.get("message") == "Announcement with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_delete_announcement():
    url = 'http://127.0.0.1:8000/announcements/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.delete(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Announcement deleted successfully"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"
