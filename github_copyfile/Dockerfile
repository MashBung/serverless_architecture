FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/
COPY templates/ ./templates/

EXPOSE your-port

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "your-port"]