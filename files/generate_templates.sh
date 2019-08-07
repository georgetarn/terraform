#!/usr/bin/env bash

set -xe

BACKEND1_IP=$1
BACKEND2_IP=$2
BACKEND3_IP=$3

echo "[SensuGo] Generating SensuGo default agent configuration"
cat <<EOF > ./backend1.yml
---
# Sensu backend configuration

##
# backend configuration
##
state-dir: "/var/lib/sensu/sensu-backend"
#cache-dir: "/var/cache/sensu/sensu-backend"
config-file: "/etc/sensu/backend.yml"
debug: true 
#deregistration-handler: "example_handler"
log-level: "debug" # available log levels: panic, fatal, error, warn, info, debug

##
# agent configuration
##
#agent-host: "[::]" # listen on all IPv4 and IPv6 addresses
#agent-port: 8081

##
# api configuration
##
#api-listen-address: "[::]:8080" # listen on all IPv4 and IPv6 addresses
#api-url: "http://localhost:8080"

##
# dashboard configuration
##
#dashboard-cert-file: "/path/to/ssl/cert.pem"
#dashboard-key-file: "/path/to/ssl/key.pem"
#dashboard-host: "[::]" # listen on all IPv4 and IPv6 addresses
#dashboard-port: 3000

##
# ssl configuration
##
#cert-file: "/path/to/ssl/cert.pem"
#key-file: "/path/to/ssl/key.pem"
#trusted-ca-file: "/path/to/trusted-certificate-authorities.pem"
#insecure-skip-tls-verify: false

##
# store configuration
##
##
# store configuration for backend-1/${BACKEND1_IP}
##
etcd-advertise-client-urls: "http://${BACKEND1_IP}:2379"
etcd-listen-client-urls: "http://${BACKEND1_IP}:2379"
etcd-listen-peer-urls: "http://0.0.0.0:2380"
etcd-initial-cluster: "backend-1=http://${BACKEND1_IP}:2380,backend-2=http://${BACKEND2_IP}:2380,backend-3=http://${BACKEND3_IP}:2380"
etcd-initial-advertise-peer-urls: "http://${BACKEND1_IP}:2380"
etcd-initial-cluster-state: "new"
etcd-initial-cluster-token: ""
etcd-name: "backend-1"
EOF

echo "[SensuGo] Generating SensuGo default agent configuration"
cat <<EOF > ./backend2.yml
---
# Sensu backend configuration

##
# backend configuration
##
state-dir: "/var/lib/sensu/sensu-backend"
#cache-dir: "/var/cache/sensu/sensu-backend"
config-file: "/etc/sensu/backend.yml"
debug: true 
#deregistration-handler: "example_handler"
log-level: "debug" # available log levels: panic, fatal, error, warn, info, debug

##
# agent configuration
##
#agent-host: "[::]" # listen on all IPv4 and IPv6 addresses
#agent-port: 8081

##
# api configuration
##
#api-listen-address: "[::]:8080" # listen on all IPv4 and IPv6 addresses
#api-url: "http://localhost:8080"

##
# dashboard configuration
##
#dashboard-cert-file: "/path/to/ssl/cert.pem"
#dashboard-key-file: "/path/to/ssl/key.pem"
#dashboard-host: "[::]" # listen on all IPv4 and IPv6 addresses
#dashboard-port: 3000

##
# ssl configuration
##
#cert-file: "/path/to/ssl/cert.pem"
#key-file: "/path/to/ssl/key.pem"
#trusted-ca-file: "/path/to/trusted-certificate-authorities.pem"
#insecure-skip-tls-verify: false

##
# store configuration
##
##
# store configuration for backend-1/${BACKEND2_IP}
##
etcd-advertise-client-urls: "http://${BACKEND2_IP}:2379"
etcd-listen-client-urls: "http://${BACKEND2_IP}:2379"
etcd-listen-peer-urls: "http://0.0.0.0:2380"
etcd-initial-cluster: "backend-1=http://${BACKEND1_IP}:2380,backend-2=http://${BACKEND2_IP}:2380,backend-3=http://${BACKEND3_IP}:2380"
etcd-initial-advertise-peer-urls: "http://${BACKEND2_IP}:2380"
etcd-initial-cluster-state: "new"
etcd-initial-cluster-token: ""
etcd-name: "backend-2"
EOF

echo "[SensuGo] Generating SensuGo default agent configuration"
cat <<EOF > ./backend3.yml
---
# Sensu backend configuration

##
# backend configuration
##
state-dir: "/var/lib/sensu/sensu-backend"
#cache-dir: "/var/cache/sensu/sensu-backend"
config-file: "/etc/sensu/backend.yml"
debug: true 
#deregistration-handler: "example_handler"
log-level: "debug" # available log levels: panic, fatal, error, warn, info, debug

##
# agent configuration
##
#agent-host: "[::]" # listen on all IPv4 and IPv6 addresses
#agent-port: 8081

##
# api configuration
##
#api-listen-address: "[::]:8080" # listen on all IPv4 and IPv6 addresses
#api-url: "http://localhost:8080"

##
# dashboard configuration
##
#dashboard-cert-file: "/path/to/ssl/cert.pem"
#dashboard-key-file: "/path/to/ssl/key.pem"
#dashboard-host: "[::]" # listen on all IPv4 and IPv6 addresses
#dashboard-port: 3000

##
# ssl configuration
##
#cert-file: "/path/to/ssl/cert.pem"
#key-file: "/path/to/ssl/key.pem"
#trusted-ca-file: "/path/to/trusted-certificate-authorities.pem"
#insecure-skip-tls-verify: false

##
# store configuration
##
##
# store configuration for backend-1/${BACKEND3_IP}
##
etcd-advertise-client-urls: "http://${BACKEND3_IP}:2379"
etcd-listen-client-urls: "http://${BACKEND3_IP}:2379"
etcd-listen-peer-urls: "http://0.0.0.0:2380"
etcd-initial-cluster: "backend-1=http://${BACKEND1_IP}:2380,backend-2=http://${BACKEND2_IP}:2380,backend-3=http://${BACKEND3_IP}:2380"
etcd-initial-advertise-peer-urls: "http://${BACKEND3_IP}:2380"
etcd-initial-cluster-state: "new"
etcd-initial-cluster-token: ""
etcd-name: "backend-3"
EOF
