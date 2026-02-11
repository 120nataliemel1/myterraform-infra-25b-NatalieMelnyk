apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: "${cluster_name}"
    apiServerEndpoint: "${cluster_endpoint}"
    certificateAuthority: "${cluster_ca_b64}"
  kubelet:
    extraArgs:
      node-labels: "node.kubernetes.io/lifecycle=normal"

