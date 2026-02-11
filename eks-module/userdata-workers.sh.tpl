#!/bin/bash
set -euxo pipefail

cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${api_server_endpoint}
    certificateAuthority: ${cluster_ca}
    cidr: ${service_cidr}
EOF

nodeadm init -c /etc/nodeadm/config.yaml
