# Change Azure vm size 

Login-AzureRmAccount

#Set subscription 
$SubscriptionId = " "
Select-AzureRmSubscription -SubscriptionId $SubscriptionId 

#Region 
$Region - "East US" 

#List Sizes 
Get-AzureRmVMSize -Location $Region 

#Parameters 
$RM = "ImageDemo" 
$VM = "ImageDemo"
$Size = "Standard_DS2"

#Set-AzureVmSize 
$VM = Get-AzureRmVm -ResourceGroupName $RM -Name $VM 
$VM.HardwareProfile.vmSize = $Size 
Update-AzureRmVm -ResourceGroupName $RM -VM $VM 

$VM

