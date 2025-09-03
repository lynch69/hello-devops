import os
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    message = os.getenv("APP_MESSAGE", "Hello DevOps 🚀")
    return {"message": message}
