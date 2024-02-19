import re
import os
from passlib.context import CryptContext
from fastapi import HTTPException
import bcrypt
#region regex_and_encryption
from cryptography.fernet import Fernet
import base64

email_regex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'
password_regex = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$'
name_regex = r'^[A-Za-z]+(?:\s+[A-Za-z]+)*$'
team_name_regex = r'^[A-Za-z0-9\s]*$'

def check_email(email : str):
    if re.fullmatch(email_regex, email):
       return True
    else:
        return False 
        
    
def check_password_regex(password : str):
    if re.fullmatch(password_regex, password):
        return True
    else:
        return False

def check_is_valid_name(name: str):
    if not re.match(name_regex, name):
        raise HTTPException(status_code=400, detail="Name format is invalid")
    else:
        return True
    
def check_is_valid_team_name(name: str):
    if re.fullmatch(team_name_regex, name):
        return True
    else:
        return False

fixed_salt = os.environ["SALT"].encode('utf-8')

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto", bcrypt__default_rounds=12)

# verifcation fails upon login after a server restart (due to hash changing)
# as such we salt the password with a fixed salt to ensure the hash is the same after restarts
# For security this hash is in .env file and preferably will be removed in future to improve security

def verify_password(plain_password, hashed_password):
    salted_password = fixed_salt + plain_password.encode('utf-8')
    hashed_password_with_salt = bcrypt.hashpw(salted_password, hashed_password.encode('utf-8'))
    return hashed_password.encode('utf-8') == hashed_password_with_salt

def encrypt_password(password):
    password = fixed_salt + password.encode('utf-8')

    return pwd_context.hash(password)

def generate_key():
    return Fernet.generate_key()

def encode_key(key):
    return base64.urlsafe_b64encode(key)

key = generate_key()
encoded_key = encode_key(key)

cipher_suite = Fernet(b'Iw0n7Sg6ih3pIoUMPg1CrVGLqby_5KWaqUnldCSJJlc=')

def encrypt(string):
    encrypted_string = cipher_suite.encrypt(string.encode('utf-8'))
    print("encrypted length:" + str(len(encrypted_string)))
    return encrypted_string

def decrypt(encrypted_string):
    print("post-storage encrypted length:" + str(len(encrypted_string)))
    decrypted_string = cipher_suite.decrypt(encrypted_string).decode()
    return decrypted_string

word = "Hello"

encrypted_word = encrypt(word)
print("Encrypted word:", encrypted_word)

decrypted_word = decrypt(encrypted_word)
print("Decrypted word:", decrypted_word)


# def encrypt_password(password : str):
#     password = password.encode()
#     password = bcrypt.hashpw(password, bcrypt.gensalt())
#     return password

# def check_password(plain_password, hashed_password):
#     return bcrypt.checkpw(plain_password.encode(), hashed_password)

#endregion

