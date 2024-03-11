az login
Connect-AzAccount

## Set subscription 
az account set --subscription "MCAPS-Hybrid-REQ-70161-2024-jeschult"
Select-AzSubscription -SubscriptionName "MCAPS-Hybrid-REQ-70161-2024-jeschult"
## Show subscription resources
az account show 

## Variables 
$subID = "487b28a7-8215-40da-8abb-23ce08297ebb"
$resourceGroup = "deveastus2004"
$location = "eastus2"
$keyvault = "kv001eastus2"
$sqlserver = "sql049eastus2"
$sqladminuser = "sqladmin"
$database1 = "comm-usa"
$database2 = "comm-can"
$database3 = "comm-mex"

## Create resource group 
az group create --name $resourceGroup --location $location

## Assign Reader role in Subscription
## Tim 
az role assignment create --role "Reader" --assignee-object-id "b29510a8-6bb5-480f-aa18-d9eb5ad694a4" --assignee-principal-type "user" --scope /subscriptions/$subID
## Assign Reader role in resource group 
## Jared 
az role assignment create --role "Reader" --assignee-object-id "cf8d2eb1-9b98-481a-89f9-16a1890c4132" --assignee-principal-type "user" --scope /subscriptions/$subID/resourceGroups/$resourceGroup
## View roles in resource group 
az role assignment list --resource-group $resourceGroup --output table

## Create Key Vault 
az keyvault create --name $keyvault --resource-group $resourceGroup --location $location --retention-days 30
## Create secret 
## DO NOT DO THIS IN REAL LIFE - Use PowerShell to prompt for password - come back to this 
az keyvault secret set --vault-name $keyvault --name "sqladminpassword" --value "P@ssw0rd123$%"

$sqladminpassword = (Get-AzKeyVaultSecret -VaultName $keyvault -Name "sqladminpassword" -AsPlainText)

## Create SQL server 
az sql server create --name $sqlserver --resource-group $resourceGroup --location $location --admin-user $sqladminuser --admin-password $sqladminpassword

## Assign Entra admin to SQL server
az sql server ad-admin create --display-name "Jared Karney" --object-id "cf8d2eb1-9b98-481a-89f9-16a1890c4132" --resource-group $resourceGroup --server-name $sqlserver

## Add firewall rule for client subnet
az sql server firewall-rule create --resource-group $resourceGroup --server $sqlserver --name "AllowClient" --start-ip-address "75.8.255.0" --end-ip-address "75.8.255.255"

## Add databases 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database1 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database2 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database3 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 

## Switch to Azure Data Studio to show logins/Users 

## Delete resource group 
az group delete --name $resourceGroup --no-wait --yes

```