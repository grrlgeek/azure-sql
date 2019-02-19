# Azure PowerShell prep 

# Check that execution policy is "RemoteSigned" 
Get-ExecutionPolicy

# Check PowerShell version - need 5.x for Win 7 + 
$PSVersionTable.PSVersion

Get-Module

# Install module Rm (old module) 
Install-Module -Name Az -AllowClobber

# Sign in 
# Connect to Azure with a browser sign in token
Connect-AzAccount

# Save between sessions 
Enable-AzContextAutosave 

