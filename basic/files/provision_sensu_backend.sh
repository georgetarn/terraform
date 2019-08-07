#!/usr/bin/env bash

set -xe

echo "[SensuGo] Installing SensuGo agent"
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh | bash
apt-get install sensu-go-backend
apt-get install sensu-go-cli

sensuctl configure -n \
--username 'admin' \
--password 'P@ssw0rd!' \
--namespace default \
--url 'http://127.0.0.1:8080'