#!/bin/bash
set -euxo pipefail

# Ensure nodeadm directory exists (CRITICAL)
mkdir -p /etc/nodeadm

# Write nodeadm config
cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: projectx_cluster_ubuntu25b
    apiServerEndpoint: https://829739FADD590C43AF80E6342A5FDD5D.gr7.us-east-1.eks.amazonaws.com
    certificateAuthorityData: <BASE64_CA_FROM_EKS>
    cidr: 10.0.0.0/16
EOF

# Start nodeadm (systemd-managed)
systemctl daemon-reexec
systemctl restart nodeadm
