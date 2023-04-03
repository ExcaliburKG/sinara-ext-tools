param (
    [string]$instanceName = "",
    [string]$withVolumes = "no"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$containerName = "jovyan-single-use"

if (!$instanceName) {
    $instanceName = $containerName
}

Write-Host "Please, keep in mind, that 'remove.ps1' will not delete any volumes by default."
Write-Host "To delete volumes use '--withVolumes yes'"
Write-Host "Your custom folders will never be deleted"

$container_created = docker ps -a --filter "status=created" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch
$container_exited = docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch

if ( $container_created -or $container_exited) {
    Write-Host "Your jovyan single use container is found. Removing it.."
    docker rm -f "$instanceName"
}
else {
    if (docker ps | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
        Write-Host "Your jovyan single use container is already running. Stopping and removing it.."
        docker stop "$instanceName"
        docker rm -f "$instanceName"
    }
    else {
        Write-Host "Your jovyan single use container is not found. Nothing to remove."
    }
}

if ($withVolumes -eq "yes") {
    $dataVolume = "jovyan-data-${instanceName}"
    $workVolume = "jovyan-work-${instanceName}"
    $tmpVolume = "jovyan-tmp-${instanceName}"

    if (docker volume ls | Out-String -stream | Select-String -Pattern "$dataVolume" -SimpleMatch) {
        Write-Host "Docker volume with jovyan data is found. Removing it.."
        docker volume rm -f $dataVolume
    }

    if (docker volume ls | Out-String -stream | Select-String -Pattern "$workVolume" -SimpleMatch) {
        Write-Host "Docker volume with jovyan work is found. Removing it.."
        docker volume rm -f $workVolume
    }  

    if (docker volume ls | Out-String -stream | Select-String -Pattern "$tmpVolume" -SimpleMatch) {
        Write-Host "Docker volume with jovyan tmp data is found. Removing it.."
        docker volume rm -f $tmpVolume
    }
}