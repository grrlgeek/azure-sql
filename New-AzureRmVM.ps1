# Create Windows VM in Azure with PowerShell 

# Log in 
Login-AzureRmAccount

# Choose subscription 
Select-AzureRmSubscription -SubscriptionId " " | Set-AzureRmContext

# Resource Group info 
Get-AzureRmResourceGroup
$ResourceGroupName = "SQLServers"
$Region = "centralus"
# Create resource group (if necessary) 
#New-AzureRmResourceGroup -Name "sqldatabases" -Location "East US" 

# Storage info 
Get-AzureRmStorageAccount 
$StorageName = "sqlserversimageposh"
$StorageType = "Standard_GRS"
# Create Storage (if necessary) 
#$StorageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Region 

# Network info 
Get-AzureRmVirtualNetwork 
$VNet = Get-AzureRmVirtualNetwork -Name "SQLServers" -ResourceGroupName "SQLServers"
$VNet
$SubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name "default" -VirtualNetwork $VNet).Id 
$SubnetID
$NicName = "Nic1" 
$IPAddress = "10.2.0.120"
$Interface = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName -Location $Region -SubnetId $SubnetID -PrivateIpAddress $IPAddress
$Interface.Id

# Compute info 
# What VM size to select? 
Get-AzureRmVMSize -Location $Region | Select Name
$VMName = "ImageVM" #This is what will appear in the portal 
$ComputerName = "ImageDemoPOSH" 
$OSDiskName = $VMName + "OSDisk"
$VMSize = "Standard_DS3" 

# What OS and Image to use? Will use this info for Set-AzureRmVMSourceImage. 
# List publishers 
Get-AzureRmVMImagePublisher -Location $Region | Where-Object {$_.PublisherName -Like "*Microsoft*"} | Select PublisherName 
$PubName = "MicrosoftWindowsServer" 
# $PubName = "MicrosoftSQLServer"
Get-AzureRmVMImageOffer -Location $Region -PublisherName $PubName | Select Offer 
$OfferName = "WindowsServer" 
# $OfferName = "SQL2014SP1-WS2012R2"
Get-AzureRmVMImageSku -Location $Region -PublisherName $PubName -Offer $OfferName | Select Skus 
$Sku = "2012-R2-Datacenter" 
# $Sku = "Enterprise"

# Credentials 
$user = "CNCY"
$password = 'P@zzw0rd'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword) 


# Set up VM object
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize

$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate

$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName $PubName -Offer $OfferName -Skus $Sku -Version "latest"

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id

$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"

$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage

# Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Region -VM $VirtualMachine

Get-AzureRmVm | Select Name