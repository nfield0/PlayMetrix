import requests
# player injuries

def test_add_injury_for_player_injuries():
    url = 'http://127.0.0.1:8000/injuries/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "injury_type": "Ankle Sprain",
        "expected_recovery_time": "2021-05-01",
        "recovery_method": "Physical Therapy and rest"
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Injury inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

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



def test_add_player_injury():
    url = 'http://127.0.0.1:8000/player_injuries/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "injury_id": 1,
        "date_of_injury": "2021-04-01",
        "date_of_recovery": "2021-05-01",
        "player_id": 1
        
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Player Injury inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player_injuries():
    url = 'http://127.0.0.1:8000/player_injuries/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)

    try:
        response_json = response.json()
        expected_data = {
            "injury_id": 1,
            "date_of_injury": "2021-04-01",
            "date_of_recovery": "2021-05-01",
            "player_id": 1
        }
        assert response_json == expected_data
        assert response.status_code == 200
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_player_injury():
    url = 'http://127.0.0.1:8000/player_injuries/1'
    headers = {'Content-Type': 'application/json'}
    json={
        "injury_id": 1,
        "date_of_injury": "2023-04-01",
        "date_of_recovery": "2024-05-01",
        "player_id": 1
    }
    response = requests.get(url, headers=headers,json=json)

    try:
        response_json = response.json()
        response_json.get("message") == "Player Injury updated successfully"
        assert response.status_code == 200
        assert response.headers['Content-Type'] == 'application/json'
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_delete_player_injury():
    url = 'http://127.0.0.1:8000/player_injuries/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)

    try:
        response_json = response.json()
        response_json.get("message") == "Player Injury deleted successfully"
        assert response.status_code == 200
        assert response.headers['Content-Type'] == 'application/json'
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"
    

def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200