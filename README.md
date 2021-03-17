[![Build Status](https://dev.azure.com/crazyelectron/HomeServer/_apis/build/status/crazyelectron-io.homeserver?branchName=main)](https://dev.azure.com/crazyelectron/HomeServer/_build/latest?definitionId=6&branchName=main)
# Setup instructions

Login to the correct Azure tenant and select the subscription to use.

```bash
#--- Login to the tenant
az login
az account list --output table
#--- Optionally select correct subscription
az account set --subscription <Azure-SubscriptionId>
```

## Create Terraform state storage in Azure

Setup Azure storage acount backend storage for the Terraform state.
Run the following commands from the root folder to setup the Azure backend storage.

```bash
terraform -chdir=./backend init
terraform -chdir=./backend plan -out backend-state.tfplan
terraform -chdir=./backend apply backend-state.tfplan
```

This will create a resource group with the storage account in it and a SAS token for accessing the container where Terraform stores its state.
The configuration details to be used by the backend initialization for accessing the remote state storage is written to `backend-config.txt` as key-value pairs, to be used in the next step to configure Terraform to use the remote storage.

## Setup the Terraform backend configuration

Run the following command to configure Terraform.
This will ensure the Azure storage container is used to store the state.

```bash
terraform ...
```

## Create a keyvault to hold the secrets

```bash
#---Create the KeyVault
az keyvault create -n hometfkvlt -g hometerra-rg -l westeurope
Location    Name            ResourceGroup
----------  --------------  ---------------
eastus2     <YOUR_KV_NAME>  AksTerraform-RG
#---Create a SAS Token for the storage account, store it in KeyVault
az storage container generate-sas --account-name hometfstate --expiry 2022-04-01 --name tfstate --permissions dlrw -o json | xargs az keyvault secret set --vault-name hometfkvlt --name hometfsas --value
#---Store the SSH public key in Azure KeyVault
az keyvault secret set --vault-name hometfkvlt --name LinuxSSHPubKey -f ~/.ssh/beheerder_key.pub > /dev/null
#---Create a Service Principal for Azure DevOps
az ad sp create-for-rbac -n "hometfSPN" --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
# The output values will be mapped to these Terraform variables:
# appId (Azure) → client_id (Terraform).
# password (Azure) → client_secret (Terraform).
# tenant (Azure) → tenant_id (Terraform).
#---Store the service principal id in Azure KeyVault
az keyvault secret set --vault-name hometfkvlt --name spn-id --value <SPN_ID> /dev/null
#store the service principal secret in Azure KeyVault
az keyvault secret set --vault-name hometfkvlt --name spn-secret --value <SPN_SECRET> /dev/null
*/
```
