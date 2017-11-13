#!/bin/bash
echo "export RISEML_ENDPOINT=http://$(kubectl get service riseml-ingress -n riseml -o yaml |
    grep "hostname:" | grep -o '[^ ]*$'):$(kubectl get service riseml-ingress -n riseml -o yaml |
    grep "port:" | grep -o '[^ ]*$')" && \
echo "export RISEML_SYNC_ENDPOINT=rsync://$(kubectl get service riseml-sync -n riseml -o yaml |
    grep "hostname:" | grep -o '[^ ]*$'):$(kubectl get service riseml-sync -n riseml -o yaml |
    grep "port:" | grep -o '[^ ]*$')/sync"

