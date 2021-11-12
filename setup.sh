#!/bin/bash

set -eo pipefail

dir=$(dirname $0)
source $dir/.includes.sh

check_executables
check_helm_chart "jetstack/cert-manager"

echo "setting up certificate manager"

kubectl create namespace cert-manager \
  --dry-run=client -o yaml | kubectl apply -f -

if [ -d $dir/ssl ]; then
  kubectl create secret tls "ca-key-pair" -n cert-manager \
    --cert=$dir/ssl/rootCA.pem \
    --key=$dir/ssl/rootCA-key.pem \
    --dry-run=client -o yaml | kubectl apply -f - 
fi   

helm upgrade cert-manager jetstack/cert-manager \
  -n cert-manager -f $dir/cert-manager-values.yaml \
  --install --wait --timeout 15m

cat << EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer 
spec:
  ca:
    secretName: ca-key-pair
EOF
