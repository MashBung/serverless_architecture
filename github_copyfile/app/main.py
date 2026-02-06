from fastapi import FastAPI, Request, File, UploadFile
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
import os
import boto3
from dotenv import load_dotenv
import time
import json

load_dotenv()

app = FastAPI()

AWS_REGION = os.getenv("AWS_REGION")
BUCKET_NAME = os.getenv("S3_BUCKET_NAME")

s3_client = boto3.client("s3", region_name=AWS_REGION)
lambda_client = boto3.client("lambda", region_name=AWS_REGION)


templates_dir = os.path.dirname(os.path.abspath(__file__))
templates_path = os.path.join(templates_dir, "..", "templates")
templates = Jinja2Templates(directory=templates_path)


@app.post("/upload")
async def upload_image(request: Request, file: UploadFile = File(...)):
    try:
        timestamp = int(time.time() * 1000)
        file_name = f"uploads/{timestamp}_{file.filename}"

        s3_client.upload_fileobj(
            file.file,
            BUCKET_NAME,
            file_name,
            ExtraArgs={"ContentType": file.content_type},
        )

        payload = {
            "Records": [
                {
                    "s3": {
                        "bucket": {"name": BUCKET_NAME},
                        "object": {"key": file_name},
                    }
                }
            ]
        }
        response = lambda_client.invoke(
            FunctionName="test-lambda",
            InvocationType="RequestResponse",
            Payload=json.dumps(payload),
        )

        result = json.loads(response["Payload"].read())

        return {
            "message": "Upload successful",
            "file_name": file_name,
            "lambda_result": result,
        }

    except Exception as e:
        return {"error": str(e)}


@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})
