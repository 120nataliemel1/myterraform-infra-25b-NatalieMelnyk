user_data = base64encode(<<-EOT
#!/bin/bash
set -euxo pipefail

# AL2023 uses nodeadm (bootstrap.sh is removed)
mkdir -p /etc/nodeadm

cat > /etc/nodeadm/config.yaml <<'EOF'
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${aws_eks_cluster.projectx_cluster.endpoint}
    certificateAuthorityData: ${aws_eks_cluster.projectx_cluster.certificate_authority[0].data}
  networking:
    serviceCIDR: ${data.aws_eks_cluster.projectx.kubernetes_network_config[0].service_ipv4_cidr}
  kubelet:
    extraArgs:
      node-labels: "node.kubernetes.io/lifecycle=normal"
EOF

# restart nodeadm services
systemctl restart nodeadm-config.service || true
systemctl restart nodeadm-run.service || true
EOT
)
