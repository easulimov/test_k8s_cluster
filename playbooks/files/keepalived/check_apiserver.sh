#!/bin/sh
# File: /etc/keepalived/check_apiserver.sh
# VIP 192.168.8.60

APISERVER_VIP=192.168.8.60
APISERVER_DEST_PORT=8888
PROTO=http

errorExit() {
    echo "*** $*" 1>&2
    exit 1
}

curl --silent --max-time 2 --insecure ${PROTO}://localhost:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET ${PROTO}://localhost:${APISERVER_DEST_PORT}/"
if ip addr | grep -q ${APISERVER_VIP}; then
    curl --silent --max-time 2 --insecure ${PROTO}://${APISERVER_VIP}:${APISERVER_DEST_PORT}/ -o /dev/null || errorExit "Error GET ${PROTO}://${APISERVER_VIP}:${APISERVER_DEST_PORT}/"
fi