#!/bin/bash

email=$1
key=$2

cat > external-dns-values.yaml << EOF
clusterDomain: admin.local
sources:
  - service
  - ingress
domainFilters:
  - onwalk.net
  - cyshall.com
  - svc-sit.ink
  - svc-dev.ink
policy: upsert-only
provider: cloudflare
cloudflare:
  apiKey: $email
  email: $key
EOF

helm repo add bitnami https://charts.bitnami.com/bitnami || echo true
helm repo update
kubectl create namespace external-dns || echo true
helm upgrade --install external-dns -f external-dns-values.yaml bitnami/external-dns -n external-dns
