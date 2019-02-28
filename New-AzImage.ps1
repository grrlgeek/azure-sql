# Create Windows VM in Azure with PowerShell - Az module 

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

Get-AzSubscription 
# 92aedf6b-f7b7-4e1f-9f23-ed28db0d2085

# Choose subscription 
Select-AzSubscription -SubscriptionId "92aedf6b-f7b7-4e1f-9f23-ed28db0d2085" | Set-AzContext

# Resource Group info 
Get-AzResourceGroup | Select ResourceGroupName, Location
$ResourceGroupName = "RG-SQLvms"
$Region = "eastus"
# Create resource group (if necessary) 
New-AzResourceGroup -Name "SQLVMs" -Location "East US" -WhatIf

# Storage info 
Get-AzStorageAccount 
$StorageName = "sqlvmsforworkshop2"
$StorageType = "Standard_LRS"
# Create Storage (if necessary) 
$StorageAccount = New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Region 

# Network info 
Get-AzVirtualNetwork | Select Name, ResourceGroupName, Location, Subnets 
$VNet = Get-AzVirtualNetwork -Name "RG-SQLvms-vnet" -ResourceGroupName "RG-SQLvms"
$VNet
$SubnetID = (Get-AzVirtualNetworkSubnetConfig -Name "default" -VirtualNetwork $VNet).Id 
$SubnetID
$NicName = "Nic1" 
$IPAddress = "10.0.1.10"
$Interface = New-AzNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName -Location $Region -SubnetId $SubnetID -PrivateIpAddress $IPAddress
$Interface.Id



# Compute info 
# What VM size to select? 
Get-AzVMSize -Location $Region | Select Name
$VMName = "POSHdemo" #This is what will appear in the Portal 
$ComputerName = "POSHdemo" 
$OSDiskName = $VMName + "OSDisk"
$OSDiskName
$VMSize = "Standard_DS3_v2" 

# What OS and Image to use? Will use this info for Set-AzVMSourceImage. 
# List publishers 
Get-AzVMImagePublisher -Location $Region | Where-Object {$_.PublisherName -Like "*Microsoft*"} | Select PublisherName 
# For Windows only 
$PubName = "MicrosoftWindowsServer" 
# For Image with SQL already installed 
$PubName = "MicrosoftSQLServer"
Get-AzVMImageOffer -Location $Region -PublisherName $PubName | Select Offer 
# For Windows only 
$OfferName = "WindowsServer" 
# For Image with SQL already installed
$OfferName = "SQL2017-WS2016"
Get-AzVMImageSku -Location $Region -PublisherName $PubName -Offer $OfferName | Select Skus 
# For Windows only 
$Sku = "2012-R2-Datacenter" 
# For Image with SQL already installed
$Sku = "Enterprise"

# Credentials 
$user = "borland"
$password = 'P@zzw0rd'
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword) 
$password

 
# Set up VM object
$VirtualMachine = New-AzVmConfig -vmname $VMName -vmsize $vmsize
$VirtualMachine = Set-AzVmOperatingSystem -vm $VirtualMachine -windows -computername $Computername -credential $Cred -ProvisionVMagent
$VirtualMachine = Set-AzVmSourceImage -vm $VirtualMachine -publishername $pubname -offer $offername -skus $sku -version "latest"
$VirtualMachine = Add-AzVmNetworkInterface -vm $VirtualMachine -id $Interface.id -primary
#Create an endpoint for the storage account holding the disk
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$VirtualMachine = Set-AzVmOsDisk -vm $VirtualMachine -name $osdiskname -vhduri $OSDiskUri -createoption FromImage
# Create the VM in Azure
New-AzVm -ResourceGroupName $ResourceGroupName -location $Region -vm $VirtualMachine

#get the name of the vm
get-azvm | select Name
