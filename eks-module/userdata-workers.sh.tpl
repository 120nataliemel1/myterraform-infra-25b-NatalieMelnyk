#!/bin/bash
set -euxo pipefail

# AL2023 EKS nodes use nodeadm (bootstrap.sh is removed)
mkdir -p /etc/nodeadm

cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthorityData: ${cluster_ca_b64}
  kubelet:
    extraArgs:
      node-labels: "node.kubernetes.io/lifecycle=normal"
  # Optional but good if your PM explicitly wants CIDR:
  # clusterDNS can be derived from service CIDR, but nodeadm can accept it.
  # If you know the service CIDR, pass it; otherwise omit this whole section.
  networking:
    serviceCIDR: ${service_cidr}
EOF

systemctl daemon-reload || true
systemctl restart nodeadm-config.service || true
systemctl restart nodeadm-run.service || true


