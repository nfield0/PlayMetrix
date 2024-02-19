import requests

def test_add_notification():
    url = 'http://127.0.0.1:8000/notification'
    headers = {'Content-Type': 'application/json'}
    json = {
        "notification_title": "Test Notification",
        "notification_desc": "Test Description",
        "notification_date": "2024-01-21T00:00:00",
        "team_id": 1,
        "poster_id": 1,
        "poster_type": "manager"
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
        "poster_id": 1,
        "poster_type": "manager"
    }
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
        "poster_id": 1,
        "poster_type": "manager"
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