import requests

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


def test_add_sport_incorrect():
    url = 'http://127.0.0.1:8000/sports/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "sport_name": "Gaelic Rugby 1234!"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Name format is invalid"
        assert response.status_code == 400  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_league_by_id():
    url = 'http://127.0.0.1:8000/sports/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)

    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        expected_data = {
            "sport_id": 1,
            "sport_name": "Gaelic Rugby"
        }
        
        assert response_json == expected_data
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_sport_by_false_id():
    url = 'http://127.0.0.1:8000/sports/.1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    # assert response.headers['Content-Type'] == 'application/json'
    try:
        assert response.status_code == 422          

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_sport_by_id():
    url = 'http://127.0.0.1:8000/sports/1'
    headers = {'Content-Type': 'application/json'}
    json = {
             "sport_name": "Basketball"                
            }
    
    response = requests.put(url, headers=headers, json=json)
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get("message") == "Sport with ID 1 has been updated"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}" 

def test_update_sport_by_id_incorrect_name():
    url = 'http://127.0.0.1:8000/sports/1'
    headers = {'Content-Type': 'application/json'}
    json = {
             "sport_name": "Basketball 1236!"                
            }
    
    response = requests.put(url, headers=headers, json=json)
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get('detail')== "Name format is invalid"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_delete_sport_by_id():
    url = 'http://127.0.0.1:8000/sports/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get("message") == "Sport deleted successfully"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"  
