# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y libpq-dev gcc

# Create a virtual environment inside the container
RUN python3 -m venv venv

# Activate the virtual environment and install dependencies
RUN /bin/bash -c "source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"

# Set environment variables
ENV FLASK_APP=crudapp.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run database migrations
RUN /bin/bash -c "source venv/bin/activate && flask db init && flask db migrate -m 'entries table' && flask db upgrade"

# Expose the application port
EXPOSE 80

# Command to run the application
CMD ["/bin/bash", "-c", "source venv/bin/activate && flask run --host=0.0.0.0 --port=80"]
