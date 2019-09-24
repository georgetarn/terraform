#!/usr/bin/env bash

set -xe

SENSU_BACK_CONF_FILE=$1
EC2_NODE_IP=$2

scp ${SENSU_BACK_CONF_FILE} ec2-user@${EC2_NODE_IP}:/var/tmp/
ssh ec2-user@${EC2_NODE_IP} "sudo cp /var/tmp/${SENSU_BACK_CONF_FILE} /etc/sensu/backend.yml"
ssh ec2-user@${EC2_NODE_IP} "sudo service sensu-backend start"
ssh ec2-user@${EC2_NODE_IP} "sudo service sensu-backend status"


