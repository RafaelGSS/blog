#!/bin/bash

log () {
 echo "[($date)] - $1";
}

log "Initialized deploy";
docker kill blog_prod;
log "Container killed";
docker-compose up -d --build blog_prod;
log "Deployed!";
