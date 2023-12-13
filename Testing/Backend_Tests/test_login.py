import requests


def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200

def test_add_player():
    url = 'http://127.0.0.1:8000/register'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "player",
        "user_email": "testplayer@gmail.com",
        "user_password": "Password123!"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['player_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_login_player():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "player",
        "user_email": "testplayer@gmail.com",
        "user_password": "Password123!"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_email": True,
            "user_password": True
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_add_manager():
    url = 'http://127.0.0.1:8000/register'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "manager",
        "user_email": "testmanager@gmail.com",
        "user_password": "Password123!"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Manager Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['manager_id'] == 1
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_login_manager():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "manager",
        "user_email": "testmanager@gmail.com",
        "user_password": "Password123!"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_email": True,
            "user_password": True
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200