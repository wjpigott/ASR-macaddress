param (
    [parameter(Mandatory=$false)]
    [Object]$RecoveryPlanContext
)
$VMinfo = $RecoveryPlanContext.VmMap | Get-Member | Where-Object MemberType -EQ NoteProperty | select -ExpandProperty Name
$vmMap = $RecoveryPlanContext.VmMap
#Write-Output "vminfo is $VMinfo"
#Write-Output "vmMap is $vmMap"
Connect-AzAccount -Identity 
    foreach($VMID in $VMinfo)
    {
        $VM = $vmMap.$VMID  
            if( !(($VM -eq $Null) -Or ($VM.ResourceGroupName -eq $Null) -Or ($VM.RoleName -eq $Null))) 
            {
    #this check is to ensure that we skip when some data is not available else it will fail
    Write-output "Resource group name ", $VM.ResourceGroupName
    Write-output "Rolename " = $VM.RoleName
    # Get the VM name from Azure Site Recovery
    $vmName = $VM.RoleName
    Write-Output "This is the VMName $vmName" 
    # Path to the script on the VM
    $scriptPath = "C:\\scripts\\changeMacAddress.ps1"
    # Command to execute the script
    $command = "& '$scriptPath'"
    # Run the script against all the listed VMs
                   Invoke-AzVMRunCommand -ResourceGroupName hpc-asr -Name $vmName -CommandId 'RunPowerShellScript' -ScriptString $command
    Write-Output "Finished"
            }
        }