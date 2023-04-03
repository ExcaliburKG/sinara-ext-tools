param (
    [string]$instanceName = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$containerName = "jovyan-single-use"

if (!$instanceName) {
    $instanceName = $containerName
}

if (docker ps -a --filter "status=created" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
    Write-Host "Your jovyan single use container is created. Start it.."
    docker start "$instanceName"
}
else {
    if (docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
        Write-Host "Your jovyan single use container is stopped. Start it.."
        docker start "$instanceName"
    }
    else {
        if (docker ps | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
            Write-Host "Your jovyan single use container is already running"
        }
    }
}

if (!(docker ps | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch)) {
      Write-Host "Your jovyan single use container is not found. Please, create it with 'create.ps1' "
}
else {
    # fix permissions
	docker exec -u 0:0 $instanceName chown -R jovyan /tmp
	docker exec -u 0:0 $instanceName chown -R jovyan /data

    # clean tmp if exists
	docker exec -u 0:0 $instanceName bash -c 'rm -rf /tmp/*'

    Write-Host "Please, follow the URL http://127.0.0.1:8888/lab to access your jovyan single use, by using CTRL key"
}