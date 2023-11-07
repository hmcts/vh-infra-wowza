param (
    $env,
    $vm_number,
    $buildNmuber
)

# Set build name
$running_vms = (az vm list --resource-group vh-infra-wowza-ithc -d --query "[?starts_with(name,'vh-infra-wowza-') && contains(['VM running','VM starting'],powerState)].{Name:name, ID:id, State:powerState}" | ConvertFrom-Json).Count
$buildName = "$buildNmuber - $env [$running_vms->$vm_number]"
write-host "##vso[build.updatebuildnumber]$buildName"

$vms = az vm list --resource-group vh-infra-wowza-$env -d --query "[?starts_with(name,'vh-infra-wowza-')].{Name:name, ID:id, State:powerState}" | ConvertFrom-Json
$i = 0

function Set-VMStatus {
    param ( 
        [string]$vm,
        $state,
        $desiredState
    )

    if ($desiredState) {
        if ($state -in ('VM running','VM starting')) {
            Write-Host "VM already running/starting"
        } else {
            Write-Host "Starting VM..."
            az vm start --ids $vm --no-wait
        }
    } else {
        if ($state -in ('VM stopped','VM stopping','VM deallocating', 'VM deallocated')) {
            Write-Host "VM already stopped/stopping"
        } else {
            Write-Host "Shutting down VM..."
            az vm deallocate --ids $vm --no-wait
        }
    }
}

if ($vm_number -le $vms.Count){
    foreach( $vm in $vms) {
        $i = $i + 1
        if ($i -le $vm_number){
            Write-Host "$($vm.Name) has been requested. Current status is '$($vm.State)'"
            Set-VMStatus -vm $vm.ID -state $vm.State -desiredState $true
        } else {
            Write-Host "$($vm.Name) not needed. Current status is '$($vm.State)'"
            Set-VMStatus -vm $vm.ID -state $vm.State -desiredState $false
        }
    }
} else {
    Write-Error "Too manay VMs specified. Requested: $vm_number Available: $($vms.Count)"
}