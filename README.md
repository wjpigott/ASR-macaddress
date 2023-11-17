# Changing the Azure MAC Address is not allowed
In some situations there may be a need to have an Azure Machine have a static MAC Address on the Network Adapter.
One scenario for this is when using software that requires the MAC address to be locked.
If you choose to implement this solution. <br> <br> It is highly recommended to use Azure Backup to backup the virtual machine incase during your testing the MAC address would be set on the wrong network adapter causing the virtual machine to become unresponsive.

# Workaround
Set a static MAC address on a secondary Azure virtual machine network adapter.
This scenario was discussed in a prior link by April Edwards a few years ago. https://techcommunity.microsoft.com/t5/itops-talk-blog/understanding-static-mac-address-licensing-in-azure/ba-p/1386187
# Azure Site Recovery
I would like to extend on this solution to be utilized with Azure Site Recovery to be utilized in a regional or zonal outage. This solution would need to failover and reset the network adapter properly.

## Requirements
Azure Site Recovery Plan - with a post script utilizing an Azure Automation Account
Script pre-existing (for this example) on the virtual machine to set the MAC address.

## Gotchas during research
When Azure Site Recovery fails over a virtual machine with multiple network adapters it isn't clear which adapter will become the primary default adapter used for Azure traffic. 
The script included determines which adapter is primary, and then will disable the secondary adapter and set the Network Address. The network adapter is then reenabled. 
