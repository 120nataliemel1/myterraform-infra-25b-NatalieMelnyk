#!/bin/bash
set -euxo pipefail

# Log userdata output (helps you see the real error in EC2 console output)
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

mkdir -p /etc/nodeadm

cat > /etc/nodeadm/config.yaml <<EOF
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: "${cluster_name}"
    apiServerEndpoint: "${cluster_endpoint}"
    certificateAuthority: "${cluster_ca_b64}"
EOF

echo "----- nodeadm config file -----"
cat /etc/nodeadm/config.yaml

systemctl daemon-reload || true

echo "----- nodeadm-config status BEFORE restart -----"
systemctl status nodeadm-config.service --no-pager || true

echo "----- restarting nodeadm services -----"
systemctl restart nodeadm-config.service
systemctl restart nodeadm-run.service

echo "----- nodeadm-config status AFTER restart -----"
systemctl status nodeadm-config.service --no-pager || true

echo "----- nodeadm-config journal (last 200 lines) -----"
journalctl -u nodeadm-config.service --no-pager -n 200 || true
