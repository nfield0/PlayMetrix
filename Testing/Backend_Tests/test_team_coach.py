import requests


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

def test_add_coach():
    url = 'http://127.0.0.1:8000/register_coach'
    headers = {'Content-Type': 'application/json'}
    json = {
        "coach_email": "testcoach@gmail.com",
        "coach_password": "Testpassword123!",
        "coach_firstname": "test",
        "coach_surname": "tester",
        "coach_contact": "012345",
        "coach_image": "h"
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Coach Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['coach_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team_coach():
    url = 'http://127.0.0.1:8000/team_coach'
    headers = {'Content-Type': 'application/json'}
    json = {
        "coach_id": 1,
        "team_id": 1,
        "team_role": "Head Coach"
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("message") == "Coach with ID 1 has been added to team with ID 1"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_team_coach():
    url = 'http://127.0.0.1:8000/team_coach/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.get(url, headers=headers)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    expected_data = [{
        "coach_id": 1,
        "team_id": 1,
        "team_role": "Head Coach"
    }]
    try:
        response_json = response.json()
        assert response_json == expected_data
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_coaches_by_team_id():
    url = 'http://127.0.0.1:8000/coaches_team/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.get(url, headers=headers)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    expected_data = [{
        "coach_id": 1,
        "team_id": 1,
        "team_role": "Head Coach"
    }]
    try:
        response_json = response.json()
        assert response_json == expected_data
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200