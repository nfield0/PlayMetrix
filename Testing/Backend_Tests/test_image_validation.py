import requests
from test_url import baseUrl
import base64

def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        image_bytes = image_file.read()
        base64_encoded = base64.b64encode(image_bytes).decode('utf-8')
    return base64_encoded

image_path = "Testing/Backend_Tests/test_images/low_qual_test.jpg"
image_bytes = image_to_base64(image_path)

print(len(image_bytes))

def test_add_coach():
    url = baseUrl + '/register_coach'
    headers = {'Content-Type': 'application/json'}
    json = {
        "coach_email": "testcoach@gmail.com",
        "coach_password": "Testpassword123!",
        "coach_firstname": "test",
        "coach_surname": "tester",
        "coach_contact": "012345",
        "coach_image": image_bytes
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Coach Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['coach_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


image_path2 = "Testing/Backend_Tests/test_images/over_limit.jpg"
image_bytes2 = image_to_base64(image_path2)


def test_add_coach2():
    url = baseUrl + '/register_coach'
    headers = {'Content-Type': 'application/json'}
    json = {
        "coach_email": "testcoach2@gmail.com",
        "coach_password": "Testpassword123!",
        "coach_firstname": "test",
        "coach_surname": "tester",
        "coach_contact": "012345",
        "coach_image": image_bytes2
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 400

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Image size exceeds the maximum allowed size"
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"