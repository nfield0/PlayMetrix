from typing import Union

from fastapi import FastAPI

app = FastAPI()


## To install requirements
# python -m pip install -r requirements.txt


## To Run Uvicorn
# python -m uvicorn main:app --reload

## For Interactive Documentation (Swagger UI)
# http://127.0.0.1:8000/docs
# /redoc for ReDoc Documentation



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
