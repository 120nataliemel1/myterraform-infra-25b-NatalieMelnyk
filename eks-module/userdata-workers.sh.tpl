#!/bin/bash
set -euxo pipefail

# AL2023 uses nodeadm (bootstrap.sh is removed)
mkdir -p /etc/nodeadm

cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthorityData: ${cluster_ca_b64}
  networking:
    serviceCIDR: ${service_cidr}
  kubelet:
    extraArgs:
      node-labels: "node.kubernetes.io/lifecycle=normal"
EOF

systemctl restart nodeadm-config.service || true
systemctl restart nodeadm-run.service || true
