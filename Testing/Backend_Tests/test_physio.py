import requests

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

def test_add_physio_incorrect_email():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysiogmail.com",
        "physio_password": "Password123!",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345",
        "physio_image": "0"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Email format invalid"
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_physio_incorrect_name():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio12@gmail.com",
        "physio_password": "Password123!",
        "physio_firstname": "123",
        "physio_surname": "tester",
        "physio_contact_number": "012345",
        "physio_image": "0"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Name format is invalid"
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_get_physio():
    url = 'http://127.0.0.1:8000/physio/info/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Hidden",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345",
        "physio_image": "something"
    }
        assert response_json == expected_data
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_login_physio():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_email": "testphysio@gmail.com",
        "user_password": "Testpassword123!"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_id": 1,            
            "user_type": "physio",
            "user_email": True,
            "user_password": True
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_login_physio_fail():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_email": "testphysio@gmail.com",
        "user_password": "Password123"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_id": 1,
            "user_type": "physio",
            "user_email": True,
            "user_password": False
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_physio():
    url = 'http://127.0.0.1:8000/physio/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "physio_email": "testphysioupdate@gmail.com",
            "physio_password": "Password123!",
            "physio_firstname": "test",
            "physio_surname": "tester",
            "physio_contact_number": "012345",
        "physio_image": "0"
        
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Physio and physio info with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_physio_login():
    url = 'http://127.0.0.1:8000/physio/login/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "physio_id": 1,
            "physio_email": "testphysioupdate@gmail.com",
            "physio_password": "Password123!"
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Physio Login with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_update_physio_info():
    url = 'http://127.0.0.1:8000/physio/info/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "physio_id": 1,
            "physio_firstname": "test",
            "physio_surname": "tester",
            "physio_contact_number": "012345",
        "physio_image": "0"
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Physio Info with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"    

def test_update_physio_fail():
    url = 'http://127.0.0.1:8000/physio/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "physio_email": "testphysioupdate@gmail.com",
            "physio_password": "Password123!",
            "physio_firstname": "123",
            "physio_surname": "456",
            "physio_contact_number": "012345",
        "physio_image": "0"
        
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("detail") == "Name format is invalid"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_delete_physio():
    url = 'http://127.0.0.1:8000/physio/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Physio and physio info with ID 1 has been deleted"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

# team_physio tests

def test_add_team_manager():
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

def test_add_team_before_team_test():
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

def test_add_physio_2():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Testpassword123!",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345",
        "physio_image": "0"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 2
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


# def test_add_z_team_physio():
#     url = 'http://127.0.0.1:8000/team_physio'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "team_id": 1,
#         "physio_id": 1
#     }
#     response = requests.post(url, headers=headers, json=json)
    
#     #assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     assert response == "Physio with ID 1 has been added to team with ID 1"


# def test_get_team_physio():
#     url = 'http://127.0.0.1:8000/team_physio/1'
#     headers = {'Content-Type': 'application/json'}
#     response = requests.get(url, headers=headers)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     try:
#         response_json = response.json()
#         expected_data = {
#             "physio_id": 1
#         }

#         assert response_json == expected_data
#     except(ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"