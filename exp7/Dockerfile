FROM python:3.9

# Install Pillow library for image processing
RUN pip install pillow

# Copy the python script and the image into the container
COPY hello.py /app/
COPY devops.png /app/

WORKDIR /app/

# Expose port 8000 for the web server
EXPOSE 8000

# Run the Python web server script
CMD ["python", "hello.py"]