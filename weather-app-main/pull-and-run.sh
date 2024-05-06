#!/bin/bash

# Pull the latest image from Docker Hub
docker pull alejomena99/weather-nginx-front:latest

# Run the container mapping port 5001 on the host to port 3000 in the container
docker run -d -p 5001:3000 alejomena99/weather-nginx-front:latest

# Check if the container is running
if [ "$(docker ps -q -f ancestor=alejomena99/weather-nginx-front:latest)" ]; then
    echo "El front se encuentra disponible en http://localhost:5001"
else
    echo "Hubo un error al ejecutar el contenedor."
fi
