#!/usr/bin/env bash

USAGE='Usage: $0 {build|release} 
eg. 
release : build ./Dockerfile to code4demo/nginx-cors:latest  
'
CURRENTPATH=$(dirname ${0})
SHELLNAME=$(echo "$0" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
#support in -s 
if [ -L "$0" ] ; then 
SHELLPATH=$(echo $(ls -l "$CURRENTPATH"  | grep "$SHELLNAME") | awk  -F "->" '{print $NF}') 
#SHELLNAME=$(echo $SHELLPATH | awk -F "/" '{print $NF}')
fi

PORJECTNAME="nginx-cors"
DOCKERHOST="kineviz" 
if [ -z "$2" ]; then
    echo "Default docker registry host : $DOCKERHOST "
else
DOCKERHOST=$2
    echo "Read the docker registry host : $DOCKERHOST "
fi

CURRENT_TAG="$(git describe --tags --abbrev=0)"

build(){
    cd "${CURRENTPATH}"
    if [ ! -f "${CURRENTPATH}/Dockerfile.alpine" ]; then 
        echo "Can't found ./Dockerfile.alpine file"
        exit 1
    else 
        docker pull "${DOCKERHOST}/${PORJECTNAME}:latest" \
        && \
        docker build \
        --build-arg http_proxy=${http_proxy} \
        --build-arg https_proxy=${https_proxy} \
        -f ./Dockerfile.alpine  -t "${DOCKERHOST}/${PORJECTNAME}:latest" ./ 
    fi
}

docker_push_release(){
    echo "Will push docker image ${DOCKERHOST}/${PORJECTNAME}:latest to ${DOCKERHOST}"
    docker push "${DOCKERHOST}/${PORJECTNAME}:latest"

if [ ! -z "$CURRENT_TAG" ]; then
    echo "Will tag & push docker image ${DOCKERHOST}/${PORJECTNAME}:${CURRENT_TAG} to ${DOCKERHOST}"
    docker tag "${DOCKERHOST}/${PORJECTNAME}:latest" "${DOCKERHOST}/${PORJECTNAME}:${CURRENT_TAG}"
    docker push "${DOCKERHOST}/${PORJECTNAME}:${CURRENT_TAG}"
fi

}

 


run() {

  case "$1" in
    build)
    build
    ;;
    release)
    build
    docker_push_release
    ;;
    *)
        echo "$USAGE"
     ;;
esac

exit 0;

}

if [ -z "$1" ]; then
    echo "$USAGE"
    exit 0
fi

run "$1"