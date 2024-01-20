import requests

def test_add_manager():
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


def test_login_manager():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_email": "testmanager@gmail.com",
        "user_password": "Testpassword123!"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_id": 1,
            "user_type": "manager",
            "user_email": True,
            "user_password": True
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_login_manager_incorrect():
    url = 'http://127.0.0.1:8000/login'
    headers = {'Content-Type': 'application/json'}
    json = {
        "user_email": "testmanager@gmail.com",
        "user_password": "Pas!"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_data = {
            "user_id": 1,
            "user_type": "manager",
            "user_email": True,
            "user_password": False
            }
        response_json = response.json()
        assert response_json == expected_data
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_manager_incorrect_email():
    url = 'http://127.0.0.1:8000/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "testmanagergmailcom",
        "manager_password": "Password123!",
        "manager_firstname": "test",
        "manager_surname": "tester",
        "manager_contact_number": "012345",
        "manager_image": "something"
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 400
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get('detail') == "Email format invalid"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

# def test_get_manager_no_info():
#     url = 'http://127.0.0.1:8000/managers/1'
#     headers = {'Content-Type': 'application/json'}
#     response = requests.get(url, headers=headers)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'
#     try:
#         response_json = response.json()
#         expected_data = {
#             "manager_id": 1,
#             "manager_email": "testmanager@gmail.com",
#             "manager_password": "Password123!"
#         }
        
#         assert response_json == expected_data

#     except (ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"



def test_update_manager():
    url = 'http://127.0.0.1:8000/managers/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "manager_email": "testmanager@gmail.com",
            "manager_password": "Password123!?",
            "manager_firstname": "test",
            "manager_surname": "tester",
            "manager_contact_number": "012345",
            "manager_image": "something"
        
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Manager and manager info with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_update_manager_login():
    url = 'http://127.0.0.1:8000/managers/login/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "manager_id": 1,
            "manager_email": "testmanager@gmail.com",
            "manager_password": "Password123!?"
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Manager Login with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_update_manager_info():
    url = 'http://127.0.0.1:8000/managers/info/1'
    headers = {'Content-Type': 'application/json'}
    json = {
            "manager_id": 1,
            "manager_firstname": "test1",
            "manager_surname": "tester1",
            "manager_contact_number": "012345",
            "manager_image": "something"
        
    }

    response = requests.put(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        print(response_json)
        assert response_json.get("message") == "Manager Info with ID 1 has been updated"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


# test is passable on static databases with hashed password returning
def test_get_manager_info():
    url = 'http://127.0.0.1:8000/managers/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "manager_email": "testmanager@gmail.com",
            "manager_password": "Hidden",
            "manager_firstname": "test1",
            "manager_surname": "tester1",
            "manager_contact_number": "012345",
            "manager_image": "something"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_delete_manager():
    url = 'http://127.0.0.1:8000/managers/1'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        expected_data = {
            "message":"Manager and manager info with ID 1 has been deleted"
        }
        
        assert response_json == expected_data

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200
    



# def test_update_manager_incorrect():
#     url = 'http://127.0.0.1:8000/managers/1'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#             "manager_email": "testcom",
#             "manager_password": "test_password_updated",
#             "manager_firstname": "test",
#             "manager_surname": "tester",
#             "manager_contact_number": "012345",
#             "manager_image": "something"   
#     }

#     response = requests.put(url, headers=headers, json=json)
#     assert response.status_code == 400
#     assert response.headers['Content-Type'] == 'application/json'

#     try:
#         response_json = response.json()
#         assert response_json.get("message") == "Email format invalid"
#     except ValueError as e:
#         assert False, f"JSON parsing failed: {e}"
#     except AssertionError as e:
#         assert False, f"Test failed: {e}"