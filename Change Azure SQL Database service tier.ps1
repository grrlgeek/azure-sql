# Change Azure SQL Database service tier 

Login-AzureRmAccount

#Set subscription 
$SubscriptionId = " "
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Parameters 
$ResourceGroupName = "Group-1"
$ServerName = "jessqldb2"
$DatabaseName = "v12test"
$NewEdition = "Standard"
$NewPricingTier = "S2"

#Scale 
$ScaleRequest = Set-AzureRmSqlDatabase -DatabaseName $DatabaseName -ServerName $ServerName -ResourceGroupName $ResourceGroupName -Edition $NewEdition -RequestedServiceObjectiveName $NewPricingTier 

$ScaleRequest 