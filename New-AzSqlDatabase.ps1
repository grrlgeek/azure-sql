#Create Azure SQL Database with PowerShell 

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

# Choose subscription 
Get-AzSubscription 
Select-AzSubscription -SubscriptionId "" 

# Resource Group info 
Get-AzResourceGroup | Select ResourceGroupName, Location 
$ResourceGroupName = "rg-sqldatabase"
$Region = "eastus2"

$ResourceGroupName 
$Region 

# Create resource group (if necessary) 
# New-AzResourceGroup -Name $ResourceGroupName -Location $Region 

# SQL server info 
Get-AzSqlServer -ResourceGroupName $ResourceGroupName | Select ServerName, Location 
$SqlServerName = "jeschult-test" 
$SqlServerName
# Create SQL Server (if necessary) 
# When you run New-AzSqlServer, you're prompted for a username and password 
# This is NOT your credentials, it's the server's admin username/password 
# You can also use -SqlAdministratorCredentials with Get-Credential \# Credentials 
New-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -Location $Region 

# Create firewall rule for IP range 
Get-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName | Select FirewallRuleName, StartIpAddress, EndIpAddress
$FirewallRuleName = "ClientIP"
New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -FirewallRuleName $FirewallRuleName -StartIpAddress "71.237.84.0" -EndIpAddress "71.237.84.255"

# Create SQL Database 
$DatabaseName = "demodb" 
# DTU 
$Edition = "Standard" #Options { Basic | Standard | Premium }
$Tier = "S0" #Options {Look in Portal - Basic, S0, S1, S2, S3, P1, P2, P3, P4, P6, P11}
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition -RequestedServiceObjectiveName $Tier
# vCore 
$Edition = "GeneralPurpose" #Options {GeneralPurpose | BusinessCritical }
$Vcore = "2" #Options {Look in Portal - vCores }
$Gen = "Gen5" #Options {Gen5 | Fsv2-series | M-series}
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition -Vcore $Vcore -ComputeGeneration "$Gen"

# Clean up 
# Drop Database 
Remove-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName
# Drop SQL Server 
Remove-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -WhatIf
# Drop resource group 
Remove-AzResourceGroup -ResourceGroupName $ResourceGroupName -WhatIf