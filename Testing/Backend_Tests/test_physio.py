import requests

def test_add_physio():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Password123!",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['physio_id'] == 1
    
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
        "physio_contact_number": "012345"
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
        "physio_contact_number": "012345"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Email format invalid"
    
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
        "physio_contact_number": "012345"
    }
        assert response_json == expected_data
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_login_physio():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "physio",
        "user_email": "testphysio@gmail.com",
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

def test_login_physio_fail():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_type": "physio",
        "user_email": "testphysio@gmail.com",
        "user_password": "Password123"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
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
            "physio_password": "Password123",
            "physio_firstname": "test",
            "physio_surname": "tester",
            "physio_contact_number": "012345"
        
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

    
def test_update_physio_fail():
    url = 'http://127.0.0.1:8000/physio/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "physio_email": "testphysioupdate@gmail.com",
            "physio_password": "Password123",
            "physio_firstname": "123",
            "physio_surname": "456",
            "physio_contact_number": "012345"
        
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Physio and physio info with ID 1 has been updated"
    
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


def test_add_team_physio():
    url = 'http://127.0.0.1:8000/team_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_id": 1,
        "physio_id": 1
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    assert response.get("message") == "Physio with ID 1 has been added to team with ID 1"


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