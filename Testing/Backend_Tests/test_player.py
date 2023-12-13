import requests



def test_add_player():
    url = 'http://127.0.0.1:8000/register'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "player",
        "user_email": "testplayer@gmail.com",
        "user_password": "test_password"
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

def test_add_player_incorrect_email():
    url = 'http://127.0.0.1:8000/register'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "player",
        "user_email": "testplayer",
        "user_password": "test_password"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('detail') == "Email format invalid"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player():
    url = 'http://127.0.0.1:8000/players'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = [{
            "player_id": 1,
            "player_email": "testplayer@gmail.com",
            "player_password": "test_password"
        }]
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_update_player_info():
    url = 'http://127.0.0.1:8000/players/info/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "player_id": 1,
            "player_firstname": "Nigel", 
            "player_surname": "Farage",
            "player_dob": "1999-05-31",
            "player_contact_number": "30888802",
            "player_image" : "001231",
            "player_height": "1.80m", 
            "player_gender": "Male"
            
        }
    
    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Player info with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player_info():
    url = 'http://127.0.0.1:8000/players/info/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {'player_id': 1, 
                         'player_dob': '1999-05-31', 
                         'player_image': '001231', 
                         'player_gender': 'Male', 
                         'player_firstname': 'Nigel', 
                         'player_surname': 'Farage', 
                         'player_contact_number': '30888802',
                        'player_height': '1.80m'}
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_player_stats():
    url = 'http://127.0.0.1:8000/players/stats/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "player_id": 1,
            "matches_played": 5, 
            "matches_started": 2,
            "matches_off_the_bench": 3,
            "injury_prone": True,
            "minutes_played" : 90,
            
        }
    
    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Player stats with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player_stats():
    url = 'http://127.0.0.1:8000/players/stats/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "player_id": 1,
            "matches_played": 5, 
            "matches_started": 2,
            "matches_off_the_bench": 3,
            "injury_prone": True,
            "minutes_played" : 90,
            
        }
    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Player stats with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"
        


    

# def test_delete_player():
#     url = 'http://127.0.0.1:8000/players/1'
#     headers = {'Content-Type': 'application/json'}
#     response = requests.delete(url, headers=headers)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     try:
#         response_json = response.json()
#         expected_data = {
#             "message":"Player with ID 1 has been deleted"
#         }
        
#         assert response_json == expected_data

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_z_cleanup():
#     url = 'http://127.0.0.1:8000/cleanup_tests'
#     headers = {'Content-Type': 'application/json'}
#     response = requests.delete(url, headers=headers)
#     assert response.status_code == 200

# def test_update_player_info_incorrect():
#     url = 'http://127.0.0.1:8000/players/info/1'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#             "player_id": 1,
#             "player_firstname": "Robert123", 
#             "player_surname": "Farage",
#             "player_dob": "1999-05-31",
#             "player_contact_number": "30888802",
#             "player_image" : "001231",
#             "player_height": "1.80m", 
#             "player_gender": "Male"   
#         }

#     response = requests.put(url, headers=headers, json=json)
#     assert response.status_code == 400
#     assert response.headers['Content-Type'] == 'application/json'

#     try:
#         response_json = response.json()
#         assert response_json.get("message") == "Email format invalid"
    
#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"
