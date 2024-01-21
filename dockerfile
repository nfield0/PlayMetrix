# Use an official Python image as the base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /Backend

# Create a virtual environment
RUN python -m venv venv

# Activate the virtual environment and set PYTHONPATH
ENV PATH="/Backend/venv/bin:$PATH"
ENV PYTHONPATH="/Backend"

# Copy the requirements file to the working directory
COPY requirements.txt requirements.txt

# Install FastAPI and Uvicorn
RUN venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the entire project to the working directory
COPY . .

# Expose the default FastAPI port
EXPOSE 8000

# Define the command to run the application
CMD ["uvicorn", "Backend.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

