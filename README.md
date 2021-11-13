# kubernetes-cert-manager

This setup provisions a [cert-manager](https://github.com/jetstack/cert-manager)

# helm chart dependencies
* ```helm repo add jetstack https://charts.jetstack.io```

[mkcert](https://github.com/FiloSottile/mkcert) tool can be used to facilitate creating SSL certificates for local development. The example here creates a cluster issuer of type CA, which is using such key and certificate.
```
#initilize
mkcert --install

#generate a wildcard certificate
mkcert "*.local.dev"

# create ssl dir in the project folder
# copy the key and certificate from the install location into the ssl dir
# the location can be obtained with
mkcert -CAROOT
``
