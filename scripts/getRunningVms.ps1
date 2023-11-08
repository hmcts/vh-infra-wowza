$envs = @('ITHC','TEST','STG','DEMO')
$all_vms = @()

foreach ($env in $envs)
{
    write-host "Getting VMs in $env"
    az account set -n DTS-SHAREDSERVICES-$env
    $running_vms = az vm list --resource-group vh-infra-wowza-$env -d --query "[?starts_with(name,'vh-infra-wowza-')].{Name:name, State:powerState}" | ConvertFrom-Json
    $all_vms += $running_vms
} 

$all_vms