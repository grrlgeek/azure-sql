# Create elastic database pool 

#Log in 
Login-AzureRmAccount

# Choose subscription 
Select-AzureRmSubscription -SubscriptionId " " 

# Create resource group (if necessary) 
New-AzureRmResourceGroup -Name "sqldatabases" -Location "East US"

# Create SQL Server (if necessary) 
New-AzureRmSqlServer -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -Location "East US" -ServerVersion "12.0"

# Create firewall rule for IP range 
New-AzureRmSqlServerFirewallRule -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -FirewallRuleName "clientFirewallRule1" -StartIpAddress "75.184.100.1" -EndIpAddress "75.184.100.255"

# Create elastic pool 
New-AzureRmSqlElasticPool -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -ElasticPoolName "RunningPool" -Edition "Standard" -Dtu 400 -DatabaseDtuMin 10 -DatabaseDtuMax 100

# Add new database in pool 
New-AzureRmSqlDatabase -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -DatabaseName "runner1" -ElasticPoolName "RunningPool"

# Move existing database into pool 
Set-AzureRmSqlDatabase -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -DatabaseName "v12test" -ElasticPoolName "RunningPool" 

#Clean up 
# Drop Database 
Remove-AzureRmSqlDatabase -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -DatabaseName "runner1"
# Drop SQL Server 
Remove-AzureRmSqlServer -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb"
# Drop resource group 
Remove-AzureRmResourceGroup -ResourceGroupName "sqldatabases"