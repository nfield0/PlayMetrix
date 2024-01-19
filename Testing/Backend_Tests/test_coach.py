import requests


def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200

def test_add_coach():
    url = 'http://127.0.0.1:8000/register_coach'
    headers = {'Content-Type': 'application/json'}
    json = {
        "coach_email": "testcoach@gmail.com",
        "coach_password": "Testpassword123",
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
        assert response_json == "Coach Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['coach_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"












def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200