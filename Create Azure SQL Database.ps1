#Create Azure SQL Database with PowerShell 

# Log in 
Login-AzureRmAccount

# Choose subscription 
Select-AzureRmSubscription -SubscriptionId "7cee9841-6bfc-43bd-b1c7-dfd99f77aa56" 

# Resource Group info 
Get-AzureRmResourceGroup | Select ResourceGroupName, Location 
$ResourceGroupName = "starwars"
$Region = "centralus"
# Create resource group (if necessary) 
# New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Region 

# SQL Server info 
Get-AzureRmSqlServer -ResourceGroupName $ResourceGroupName | Select ServerName, Location
# Create SQL Server (if necessary) 
$SqlServerName = "jakku" 
# When you run New-AzureRmSqlServer, you're prompted for a username and password 
# This is NOT your credentials, it's the server's admin username/password 
New-AzureRmSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -Location $Region -ServerVersion "12.0"

# Create firewall rule for IP range 
Get-AzureRmSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName 
$FirewallRuleName = "ClientFirewallRule"
New-AzureRmSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -FirewallRuleName $FirewallRuleName -StartIpAddress "75.184.100.1" -EndIpAddress "75.184.100.255"

# Create SQL Database 
$DatabaseName = "niima" 
$Edition = "Standard" #Options {None | Premium | Basic | Standard | DataWarehouse | Free}
$Tier = "S0" #Options {Look in Portal - Basic, S0, S1, S2, S3, P1, P2, P3, P4, P6, P11}
New-AzureRmSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition -RequestedServiceObjectiveName $Tier

# Clean up 
# Drop Database 
Remove-AzureRmSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName
# Drop SQL Server 
Remove-AzureRmSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName
# Drop resource group 
Remove-AzureRmResourceGroup -ResourceGroupName $ResourceGroupName