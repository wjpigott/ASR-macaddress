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
    $scriptPath = "/root/scripts/LinuxBashNetworkAdapterChange.sh"
    # Command to execute the script
    $command = "/bin/bash $scriptPath"
    # Run the script against all the listed VMs
    $result = Invoke-AzVMRunCommand -ResourceGroupName $VM.ResourceGroupName -Name $vmName -CommandId 'RunShellScript' -ScriptString $command
    Write-Output "this is the output of the invoke:  $($result.value.Message)"
    Write-Output "status $($result.Status)"
    if ($result.value.Message -like '*error*') 
    {  
    Write-Output "Failed. An error occurred: `n $($result.value.Message)"
    throw $($result.value.Message)        
    }
    else
    {
    Write-Output "Success"
    } 
    Write-Output "Finished"
            }
        }
