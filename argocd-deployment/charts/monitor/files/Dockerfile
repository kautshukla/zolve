FROM python:3.11-slim

WORKDIR /app

RUN pip install kubernetes==32.0.1 requests==2.32.3

COPY monitor.py .

CMD ["python", "/app/monitor.py"]