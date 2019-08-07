#!/usr/bin/env bash

set -xe

echo "[SensuGo] Installing SensuGo agent"
curl -s https://packagecloud.io/install/repositories/sensu/stable/script.deb.sh | bash
apt-get install sensu-go-backend
apt-get install sensu-go-cli

sensuctl configure -n \
--username '${sensu_username}' \
--password '${sensu_password}' \
--namespace '${sensu_namespace}' \
--url 'http://127.0.0.1:${sensu_port}'