# Change Azure SQL Database service tier 

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

#Set subscription 
Get-AzSubscription 
$SubscriptionId = "92aedf6b-f7b7-4e1f-9f23-ed28db0d2085"
# Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#List existing SQL Databases 
Get-AzResourceGroup | Select ResourceGroupName, Location
$rg = "SQLserver"
Get-AzSqlServer -ResourceGroupName $rg | Select ServerName, Location 
$server = "borland"
Get-AzSqlDatabase -ResourceGroupName $rg -Server $server | Select DatabaseName, Edition, SkuName, CurrentServiceObjectiveName
$database = "AdventureWorksLT" 

#New size 
$NewEdition = "Standard"
$NewPricingTier = "S2"

#Scale 
$ScaleRequest = Set-AzSqlDatabase -DatabaseName $database -ServerName $server -ResourceGroupName $rg -Edition $NewEdition -RequestedServiceObjectiveName $NewPricingTier 

$ScaleRequest 
Get-AzSqlDatabase -ResourceGroupName $rg -Server $server | Select DatabaseName, Edition, SkuName, CurrentServiceObjectiveName