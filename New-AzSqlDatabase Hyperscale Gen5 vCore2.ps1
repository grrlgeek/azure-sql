#Create Azure SQL Database with PowerShell 

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

# Choose subscription 
Get-AzSubscription 
Select-AzSubscription -SubscriptionId "fa58cf66-caaf-4ba9-875d-f310d3694845" 

# Resource Group info 
Get-AzResourceGroup | Select-Object ResourceGroupName, Location 
$ResourceGroupName = "swiss-re-hs-test"
$Region = "westus2"

$ResourceGroupName 
$Region 

# Create resource group (if necessary) 
# New-AzResourceGroup -Name $ResourceGroupName -Location $Region 

# SQL server info 
Get-AzSqlServer -ResourceGroupName $ResourceGroupName | Select-Object ServerName, Location
$SqlServerName = "jeschult-20200528" 
$SqlServerName
# Create SQL Server (if necessary) 
# When you run New-AzSqlServer, you're prompted for a username and password 
# This is NOT your credentials, it's the server's admin username/password 
# You can also use -SqlAdministratorCredentials with Get-Credential \# Credentials 
New-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -Location $Region #-WhatIf

# Create firewall rule for IP range 
Get-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName | Select FirewallRuleName, StartIpAddress, EndIpAddress
$FirewallRuleName = "jeschult-ClientIP"
New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -FirewallRuleName $FirewallRuleName -StartIpAddress "71.237.84.1" -EndIpAddress "71.237.84.255"

# Create SQL Database 
$DatabaseName = "JesHyperscale" 
# DTU 
$Edition = "Standard" #Options {None | Basic | Standard | Premium | DataWarehouse | Free  | Stretch | GeneralPurpose | BusinessCritical}
$Tier = "S0" #Options {Look in Portal - Basic, S0, S1, S2, S3, P1, P2, P3, P4, P6, P11, or v}
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition -RequestedServiceObjectiveName $Tier
# vCore 
$Edition = "Hyperscale" #Options {None | Basic | Standard | Premium | DataWarehouse | Free  | Stretch | GeneralPurpose | BusinessCritical}
$Vcore = "2" #Options {Look in Portal - Basic, S0, S1, S2, S3, P1, P2, P3, P4, P6, P11, or vCores }
$Gen = "Gen5" #Options {Gen4 | Gen5}
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition -Vcore $Vcore -ComputeGeneration "$Gen"

# Clean up 
# Drop Database 
Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName
# Drop SQL Server 
Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -WhatIf
# Drop resource group 
Remove-AzResourceGroup -ResourceGroupName $ResourceGroupName -WhatIf