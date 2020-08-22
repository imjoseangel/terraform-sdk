# Terraform SDK

## How to create AKS

### Export Variables

```bash
export TF_VAR_client_id=<service-principal-appid>
export TF_VAR_client_secret=<service-principal-password>
```

### Create Plan

```bash
terraform plan -var-file="secret/aks.tfvars" -out defaultaks.plan
```

### Apply Plan

```bash
terraform apply defaultaks.plan
```
