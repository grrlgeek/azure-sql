<# 
 .NOTES
 ===========================================================================
  Created with:  SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.157
  Created on:    2/8/2019 10:29 AM
  Created by:    derek
  Organization:  
  Filename:      
 ===========================================================================
 .DESCRIPTION
  A description of the file.
#>
#Set variables to get this working
$VMName = "JesVM"
$VMName = $VMName.tolower()
$VMSize = "Basic_A0"
$storageaccountname = "ds"+$vmname+"storageaccount"
$Computername = $VMName
$osdiskname = "$vmname-osdisk"
#Create creds
$Azurecred = Get-Credential | Export-Clixml $env:USERPROFILE\azure.cred
$VMCred = Get-Credential | Export-Clixml $env:USERPROFILE\vmcred.cred
#Collect azure creds and vm creds as needed
$Azurecred = (Import-Clixml $env:USERPROFILE\azure.cred)
$VMCred = (Import-Clixml $env:USERPROFILE\vmcred.cred)
#End variables
#use Az module cmdlets to get publisher, offer and sku
$pubname = (get-azvmimagepublisher -Location northcentralus | where { $_.publishername.contains("MicrosoftWindowsServer") })[0].publishername
$offername = (get-azvmimageoffer -location northcentralus -PublisherName $pubname)[2].Offer
$sku = (get-azvmimagesku -location $location -publishername $pubname -offer $offername)[0].skus

#Create a resourcegroup to hold the things using Az module cmdlets
if (!(get-azresourcegroup -resourcegroupname "testgroup"))
{
 $rg = new-azresourcegroup -name "testgroup" -location $location
}
#Create Storage Account to hold the things using Az module cmdlets 
if (!(get-azstorageaccount -resourcegroupname $rg.resourcegroupname))
{
 $storageaccount = new-azstorageaccount -resourcegroupname $rg.resourcegroupname -name $storageaccountname -location $location -skuname "Standard_LRS"
}
else
{
 $StorageAccount = get-azstorageaccount -resourcegroupname $rg.resourcegroupname
}
#Use Az module cmdlets to create a subnet, vnet and network adapter
#create a subnet -- subnet
$subnet = new-azvirtualnetworksubnetconfig -name "mySubnet" -addressprefix "10.0.1.0/24"
#create a network - vnet
$vnet = new-azvirtualnetwork -resourcegroupname $rg.resourcegroupname -location $location -name "MyVnet" -addressprefix "10.0.0.0/16" -subnet $subnet
#create an adapter 
$subnet1 = $vnet.subnets | where {$_.name -eq "mySubnet"}
$Nic1 = new-aznetworkinterface -resourcegroupname $rg.resourcegroupname -name "Nic1" -location $location -subnetid $subnet1.id
#end subnet vnet and netadapter
#The rest sets up and builds vm - old azurerm cmdlet lines commented out below new az module cmdlet lines
# Set up VM object
$VirtualMachine = new-azvmconfig -vmname $VMName -vmsize $vmsize
#$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = set-azvmoperatingsystem -vm $VirtualMachine -windows -computername $Computername -credential $vmcred -provisionvmagent
#$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Cred -ProvisionVMAgent
$VirtualMachine = set-azvmsourceimage -vm $VirtualMachine -publishername $pubname -offer $offername -skus $sku -version "latest"
#$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName $PubName -Offer $OfferName[2].offer -Skus $Sku -Version "latest"
$VirtualMachine = add-azvmnetworkinterface -vm $VirtualMachine -id $nic1.id -primary
#$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
#Create an endpoint for the storage account holding the disk
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$OSDiskUri
$VirtualMachine = set-azvmosdisk -vm $VirtualMachine -name $osdiskname -vhduri $OSDiskUri -createoption FromImage
#$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage -DiskEncryptionKeyUrl '' -DiskEncryptionKeyVaultId ''
# Create the VM in Azure
New-azvm -resourcegroupname $rg.resourcegroupname -location $location -vm $VirtualMachine
#New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Region -VM $VirtualMachine
#get the name of the vm
get-azvm | select Name
#Get-AzureRmVm | Select Name