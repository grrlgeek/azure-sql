Login-AzureRmAccount

#Set subscription 
$SubscriptionId = "92aedf6b-f7b7-4e1f-9f23-ed28db0d2085"
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

Get-Command *Azure*Alert*

$ResourceGroup = 'SQLserver'
$location = 'East US'
$server = 'borland'
$db = 'AdventureWorksLT'
$rid = (Get-AzureRmResource -ResourceGroupName $ResourceGroup -ResourceName "$server/$db").ResourceID
$rid


Get-AzureRmMetricDefinition -ResourceId $rid | Select-Object -ExpandProperty Name, Unit `
| Get-Member `
| Select-Object Name | Get-Member

#| Format-Table


$email = New-AzureRmAlertRuleEmail -CustomEmails 'jes@borland.com' -SendToServiceOwners
Add-AzureRmMetricAlertRule -Name 'DTU90Check' `
-Location $location `
-ResourceGroup $ResourceGroup `
-TargetResourceId $rid `
-MetricName 'dtu_consumption_percent' `
-Operator GreaterThanOrEqual `
-Threshold 90 `
-WindowSize '00:05:00' `
-TimeAggregationOperator Maximum `
-Actions $email
