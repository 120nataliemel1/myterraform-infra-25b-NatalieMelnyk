#!/bin/bash
set -euo pipefail

echo "[INFO] Bootstrapping EKS worker node into cluster: ${cluster_name}" | tee /var/log/user-data.log

# Join the EKS cluster
/etc/eks/bootstrap.sh ${cluster_name} | tee -a /var/log/user-data.log
