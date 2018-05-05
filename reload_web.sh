#!/bin/bash


# Parar container
echo Parando Container logus-web-container...
docker stop logus-web-container

# Iniciar container
echo Iniciando Container logus-web-container...
docker start logus-web-container
