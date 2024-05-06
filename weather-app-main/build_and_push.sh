#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Debes pasar el tag de la imagen como argumento."
    echo "Uso: $0 <tag>"
    exit 1
fi

docker login -u $DOCKERHUB_USER -p $DOCKERHUB_KEY
docker build -t $DOCKERHUB_USER/weather-nginx-front:$1 .
docker ps
docker push $DOCKERHUB_USER/weather-nginx-front:$1
