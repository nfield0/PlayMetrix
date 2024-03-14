import requests
from test_url import baseUrl



def test_add_injury():
    url = baseUrl + '/injuries/'
    headers = {'Content-Type': 'application/json'}
    json = {
        
        "injury_type": "Ankle Sprain",
        "injury_name_and_grade": "Grade 1",
        "injury_location": "Left Ankle",
        "potential_recovery_method_1": "Physical Therapy and rest",
        "potential_recovery_method_2": "Surgery",
        "potential_recovery_method_3": "Rest and Ice",
        "expected_minimum_recovery_time": 24,
        "expected_maximum_recovery_time": 120
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

def test_add_injury_incorrect():
    url = baseUrl + '/injuries/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "injury_type": "Ankle Sprain123!",
        "injury_name_and_grade": "Grade 1",
        "injury_location": "Left Ankle",
        "potential_recovery_method_1": "Physical Therapy and rest",
        "potential_recovery_method_2": "Surgery",
        "potential_recovery_method_3": "Rest and Ice",
        "expected_minimum_recovery_time": 24,
        "expected_maximum_recovery_time": 120
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Name format is invalid"
        assert response.status_code == 400  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_injury_by_id():
    url = baseUrl + '/injuries/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)

    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        expected_data = {
            "injury_id": 1,
            "injury_type": "Ankle Sprain",
        "injury_name_and_grade": "Grade 1",
        "injury_location": "Left Ankle",
        "potential_recovery_method_1": "Physical Therapy and rest",
        "potential_recovery_method_2": "Surgery",
        "potential_recovery_method_3": "Rest and Ice",
        "expected_minimum_recovery_time": 24,
        "expected_maximum_recovery_time": 120
        }
        
        assert response_json == expected_data
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_injury_by_false_id():
    url = baseUrl + '/injuries/.1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)

    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        assert response.status_code == 422          

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_injury_by_id():
    url = baseUrl + '/injuries/1'
    headers = {'Content-Type': 'application/json'}
    json = {
        "injury_type": "Broken Ankle",
        "injury_name_and_grade": "Grade 1",
        "injury_location": "Left Ankle",
        "potential_recovery_method_1": "Physical Therapy and rest",
        "potential_recovery_method_2": "Surgery",
        "potential_recovery_method_3": "Rest and Ice",
        "expected_minimum_recovery_time": 24,
        "expected_maximum_recovery_time": 144
    }
    response = requests.put(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Injury with ID 1 has been updated"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"        

 
        
def test_add_player():
    url = baseUrl + '/register_player'
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

def test_delete_injury_by_id():
    url = baseUrl + '/injuries/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get("message") == "Injury deleted successfully"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}" 


def test_z_cleanup():
    url = baseUrl + '/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200