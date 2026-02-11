user_data = base64encode(<<-EOT
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${aws_eks_cluster.projectx_cluster.endpoint}
    certificateAuthorityData: ${aws_eks_cluster.projectx_cluster.certificate_authority[0].data}
  kubelet:
    extraArgs:
      node-labels: "node.kubernetes.io/lifecycle=normal"
EOT
)
