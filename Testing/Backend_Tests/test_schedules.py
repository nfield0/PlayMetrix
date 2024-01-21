import requests

def test_add_schedule():
    url = 'http://127.0.0.1:8000/schedules'
    headers = {'Content-Type': 'application/json'}
    json = {
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00"
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
    url = 'http://127.0.0.1:8000/schedules/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    expected_json = {
        "schedule_id": 1,
    "schedule_type": "Training",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00"
    }
    try:
        response_json = response.json()
        assert response_json == expected_json
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_update_schedule():
    url = 'http://127.0.0.1:8000/schedules/1'
    headers = {'Content-Type': 'application/json'}
    json = {
        "schedule_id": 1,
    "schedule_type": "Match",
    "schedule_start_time": "2024-01-21T12:30:00",
    "schedule_end_time": "2024-01-21T14:30:00"
    }
    response = requests.put(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_delete_schedule():
    url = 'http://127.0.0.1:8000/schedules/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.delete(url, headers=headers)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200
    
    try:
        response_json = response.json()
        assert response_json.get("message") == "Schedule deleted successfully"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"
