#!/bin/bash
docker rm -f nginx-cors-test
docker run -d \
--name nginx-cors-test \
-p 9080:80 \
-e TARGET_HOST=host.docker.internal:8080 \
-e ALLOW_HEADERS="X-Requested-With,Content-Type,Accept,Origin" \
kineviz/nginx-cors
 