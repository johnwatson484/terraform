# EKS Cluster

- `terraform apply`
- save output kubeconfig
- save `config_map_aws_auth.yaml`
- `kubectl apply -f config_map_aws_auth.yaml`
- verify with `kubectl get nodes --watch`
