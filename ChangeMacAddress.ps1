# Determine the active network adapter on the machine, and then compare this interface with the others attached to the Virtual machine.
# Use the interface that is not active to be change the MAC address
# 
$defaultAdapter = (Get-NetRoute | Where-Object { $_.DestinationPrefix -eq '0.0.0.0/0' } | Get-NetIPInterface).InterfaceAlias
$activeAdapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object -ExpandProperty Name
$activeNonDefaultAdapters = $activeAdapters | Where-Object { $_ -ne $defaultAdapter }
$activeNonDefaultAdapters
Disable-NetAdapter -Name $activeNonDefaultAdapters -Confirm:$false
# Set the new MAC address
Set-NetAdapterAdvancedProperty -Name $activeNonDefaultAdapters -RegistryKeyword NetworkAddress -RegistryValue "1234561A2B3C"
Enable-NetAdapter -Name $activeNonDefaultAdapters
