import requests

def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200

def test_add_manager():
    url = 'http://127.0.0.1:8000/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "testmanager@gmail.com",
        "manager_password": "Testpassword123!",
        "manager_firstname": "test",
        "manager_surname": "tester",
        "manager_contact_number": "012345",
        "manager_image": ""
    
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

def test_add_physio():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Testpassword123!",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345",
        "physio_image": "something"
    }
    response = requests.post(url, headers=headers, json=json)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
    
    except(ValueError, AssertionError) as e:
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



def test_check_player():
    url = 'http://127.0.0.1:8000/users'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "player",
        "user_email": "testplayer@gmail.com"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("player_id") == 1
        assert response_json.get("player_email") == "testplayer@gmail.com"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200