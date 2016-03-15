#Create Azure SQL Database with PowerShell 

# Log in 
Login-AzureRmAccount

# Choose subscription 
Select-AzureRmSubscription -SubscriptionId " " 

# Create resource group (if necessary) 
New-AzureRmResourceGroup -Name "sqldatabases" -Location "East US"

# Create SQL Server (if necessary) 
New-AzureRmSqlServer -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -Location "East US" -ServerVersion "12.0"

# Create firewall rule for IP range 
New-AzureRmSqlServerFirewallRule -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -FirewallRuleName "clientFirewallRule1" -StartIpAddress "75.184.100.1" -EndIpAddress "75.184.100.255"

# Create SQL Database 
New-AzureRmSqlDatabase -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -DatabaseName "runmoremiles" -Edition Standard -RequestedServiceObjectiveName "S1"

# Clean up 
# Drop Database 
Remove-AzureRmSqlDatabase -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb" -DatabaseName "runmoremiles"
# Drop SQL Server 
Remove-AzureRmSqlServer -ResourceGroupName "sqldatabases" -ServerName "sqlserverjb"
# Drop resource group 
Remove-AzureRmResourceGroup -ResourceGroupName "sqldatabases"