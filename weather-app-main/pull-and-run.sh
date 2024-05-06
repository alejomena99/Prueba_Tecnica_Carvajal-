#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Debes pasar el puerto de tu maquina local."
    echo "Uso: $0 <tag>"
    exit 1
fi

docker pull alejomena99/weather-nginx-front:latest

docker run -d -p $1:3000 alejomena99/weather-nginx-front:latest

# Check if the container is running
if [ "$(docker ps -q -f ancestor=alejomena99/weather-nginx-front:latest)" ]; then
    echo "El front se encuentra disponible en http://localhost:$1"
else
    echo "Hubo un error al ejecutar el contenedor."
fi
