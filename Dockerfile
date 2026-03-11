FROM python:3.11-slim

WORKDIR /app

# Layer caching: Copy requirements first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Initialize the database at build time
RUN python -c "import db; db.init_db()"

# Set port environment variable
ENV PORT=5000

# Use gunicorn for production (shell form so $PORT expands)
CMD gunicorn --bind 0.0.0.0:$PORT --workers 2 app:app