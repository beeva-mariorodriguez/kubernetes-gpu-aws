#!/bin/bash

if [ ! -f ssh/id_rsa ]
then
    mkdir -p ssh
    ssh-keygen -N "" -f ssh/id_rsa
fi

kops create cluster \
    --name "$(terraform output cluster_name)" \
    --state "$(terraform output kops_state_store)" \
    --zones "$(terraform output -json aws_azs | jq -r '.value|join(",")')" \
    --kubernetes-version "$(terraform output k8s_version)" \
    --image "$(terraform output coreos_image_location)" \
    --node-size "t2.medium" \
    --node-volume-size 30 \
    --network-cidr "$(terraform output aws_cidr_block)" \
    --dns-zone "$(terraform output aws_dns_zone_id)" \
    --vpc "$(terraform output aws_vpc_id)" \
    --networking "$(terraform output k8s_networking)" \
    --node-count 2 \
    --cloud aws \
    --api-loadbalancer-type public \
    --topology public \
    --ssh-public-key ssh/id_rsa.pub \
    --dns private

