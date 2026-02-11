#!/bin/bash
set -euxo pipefail

# --------------------------------------------
# AL2023 EKS worker bootstrap (nodeadm)
# bootstrap.sh is NOT available on AL2023 EKS AMIs.
# nodeadm reads a NodeConfig and joins the cluster.
# --------------------------------------------

cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
EOF

# Initialize + join the EKS cluster
nodeadm init -c /etc/nodeadm/config.yaml
