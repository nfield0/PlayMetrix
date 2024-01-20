import requests

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

def test_add_league_incorrect():
    url = 'http://127.0.0.1:8000/leagues/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "league_name": "Louth GAA 123"
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Name format is invalid"
        assert response.status_code == 400  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_league_by_id():
    url = 'http://127.0.0.1:8000/leagues/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)

    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        expected_data = {
            "league_id": 1,
            "league_name": "Louth GAA"
        }
        
        assert response_json == expected_data
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_league_by_false_id():
    url = 'http://127.0.0.1:8000/leagues/.1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    # assert response.headers['Content-Type'] == 'application/json'
    try:
        assert response.status_code == 422          

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_league_by_id():
    url = 'http://127.0.0.1:8000/leagues/1'
    headers = {'Content-Type': 'application/json'}
    json = {
             "league_name": "Monaghan GAA"                
            }
    
    response = requests.put(url, headers=headers, json=json)
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get("message") == "League with ID 1 has been updated"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"        

def test_delete_league_by_id():
    url = 'http://127.0.0.1:8000/leagues/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    
    # assert response.headers['Content-Type'] == 'application/json'
   
    try:
        response_json = response.json()
        assert response_json.get("message") == "League deleted successfully"
        assert response.status_code == 200  


    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"  
