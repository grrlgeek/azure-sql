az login
Connect-AzAccount

## Set subscription 
az account set --subscription "<sub name>"
Select-AzSubscription -SubscriptionName "<sub name>"
## Show subscription resources
az account show 

## Variables 
$subID = "<sub id>"
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
## You will need to go to Entra ID to find user names and object IDs 
## User 1
az role assignment create --role "Reader" --assignee-object-id "<Entra ID Object ID>" --assignee-principal-type "user" --scope /subscriptions/$subID
## Assign Reader role in resource group 
## User 2
az role assignment create --role "Reader" --assignee-object-id "<Entra ID Object ID>" --assignee-principal-type "user" --scope /subscriptions/$subID/resourceGroups/$resourceGroup
## View roles in resource group 
az role assignment list --resource-group $resourceGroup --output table

## Create Key Vault 
az keyvault create --name $keyvault --resource-group $resourceGroup --location $location --retention-days 30
## Create secret 
## DO NOT DO THIS IN REAL LIFE - Use PowerShell to prompt for password 
az keyvault secret set --vault-name $keyvault --name "sqladminpassword" --value "<password>"

$sqladminpassword = (Get-AzKeyVaultSecret -VaultName $keyvault -Name "sqladminpassword" -AsPlainText)

## Create SQL server 
az sql server create --name $sqlserver --resource-group $resourceGroup --location $location --admin-user $sqladminuser --admin-password $sqladminpassword

## Assign Entra admin to SQL server
az sql server ad-admin create --display-name "<User 2 - from above>" --object-id "<User 2 Object ID>" --resource-group $resourceGroup --server-name $sqlserver

## Add firewall rule for client subnet
az sql server firewall-rule create --resource-group $resourceGroup --server $sqlserver --name "AllowClient" --start-ip-address "<ip>" --end-ip-address "<ip>"

## Add databases 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database1 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database2 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 
az sql db create --resource-group $resourceGroup --server $sqlserver --name $database3 --edition "GeneralPurpose" --family Gen5 --compute-model "Serverless" --min-capacity "0.5" --capacity "2" --auto-pause-delay "60" --zone-redundant "false" --backup-storage-redundancy Local --sample-name "AdventureWorksLT" 

## Switch to Azure Data Studio to show logins/Users 

## Delete resource group 
az group delete --name $resourceGroup --no-wait --yes

```