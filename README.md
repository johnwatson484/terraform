# Terraform

Terraform scripts

## Kubernetes

### Azure
Provision IaaS cluster in Azure using KubeOne.  

Provisioning uses the below linked guide written by KubeOne.  
https://github.com/kubermatic/kubeone/blob/master/docs/quickstart-azure.md

A service principal needs to be created in order to provision resources and deploy the cluster, the below Azure CLI command can be used to create one.

`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"`

Running the above command will return an output with the below.
```
{
  "appId": "xxx",
  "displayName": "azure-cli-2019-09-29-12-03-06",
  "name": "http://azure-cli-2019-09-29-12-03-06",
  "password": "xxx",
  "tenant": "xxx"
}
```

The return values should be set in the below environment variables.

```
export ARM_CLIENT_ID=appId
export ARM_CLIENT_SECRET=password
export ARM_TENANT_ID=tenant
export ARM_SUBSCRIPTION_ID=SUBSCRIPTION_ID
```

In order to deploy Kubernetes, a private SSH key must be cached in the SSH Agent by running the below commands.

```
eval `ssh-agent`
```

`ssh-add ~/.ssh/ssh_key_name`

