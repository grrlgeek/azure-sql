# Create elastic database pool 

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
Get-AzSqlServerFirewallRule -ResourceGroupName $rg -ServerName $server | Select FirewallRuleName, StartIpAddress, EndIpAddress
$FirewallRuleName = "ClientIP"
New-AzSqlServerFirewallRule -ResourceGroupName $rg -ServerName $server -FirewallRuleName $FirewallRuleName -StartIpAddress "65.27.78.1" -EndIpAddress "65.27.78.255"

# Create elastic pool 
$pool = "demopool"
$edition = "Standard" 
$dtu = "400"
$dtumin = "10"
$dtumax = "100"
New-AzSqlElasticPool -ResourceGroupName $rg -ServerName $server -ElasticPoolName $pool -Edition $edition -Dtu $dtu -DatabaseDtuMin $dtumin -DatabaseDtuMax $dtumax 

# Add new database in pool 
$database = "data1"
New-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database -ElasticPoolName $pool

# Add standalone database 
$database2 = "data2"
New-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database2 

# Move existing database into pool 
Set-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database2 -ElasticPoolName $pool

Get-AzSqlElasticPool -ResourceGroupName $rg -ServerName $server | Select ElasticPoolName, Dtu
Get-AzSqlDatabase -ResourceGroupName $rg -ServerName $server | Select DatabaseName, ElasticPoolName 

#Clean up 
# Drop Databases 
Remove-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database
Remove-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database2
# Drop SQL Server 
Remove-AzSqlServer -ResourceGroupName $rg -ServerName $server
# Drop resource group 
Remove-AzResourceGroup -ResourceGroupName $rg 