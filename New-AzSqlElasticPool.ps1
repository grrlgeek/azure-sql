# Create elastic database pool 

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

# Choose subscription 
Get-AzSubscription 
Select-AzSubscription -SubscriptionId "1193861b-ae28-4d1c-bb80-e0df27454e76" 

# Create resource group (if necessary) 
$rg = "rg-sqldatabase" 
$region = "eastus"
New-AzResourceGroup -Name $rg -Location $region

# Create SQL Server (if necessary) 
$server = "jeschult-test"
New-AzSqlServer -ResourceGroupName $rg -ServerName $server -Location $region 

# Create firewall rule for IP range 
Get-AzSqlServerFirewallRule -ResourceGroupName $rg -ServerName $server | Select FirewallRuleName, StartIpAddress, EndIpAddress
$FirewallRuleName = "PoshDemoRule"
New-AzSqlServerFirewallRule -ResourceGroupName $rg -ServerName $server -FirewallRuleName $FirewallRuleName -StartIpAddress "65.27.78.1" -EndIpAddress "65.27.78.255"

# Create elastic pool 
$pool = "RunningPool"
$edition = "Standard" 
$dtu = "400"
$dtumin = "10"
$dtumax = "100"
New-AzSqlElasticPool -ResourceGroupName $rg -ServerName $server -ElasticPoolName $pool -Edition $edition -Dtu $dtu -DatabaseDtuMin $dtumin -DatabaseDtuMax $dtumax 

# Add new database in pool 
$database = "runner1"
New-AzSqlDatabase -ResourceGroupName $rg -ServerName $server -DatabaseName $database -ElasticPoolName $pool

# Add standalone database 
$database2 = "runner2"
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