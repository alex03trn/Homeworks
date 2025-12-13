FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Создаём input/output
RUN mkdir -p input output && chmod -R 777 input output

CMD ["python", "main.py"]
