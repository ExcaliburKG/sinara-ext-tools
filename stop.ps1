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

if (docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
    Write-Host "Your jovyan single use container is found. It is stopped.";
}
else {
    if (docker ps | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
      Write-Host "Your jovyan single use container is running. Stopping it.."
      docker stop "$instanceName"
   }
}

if (docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch) {
    Write-Host "Your jovyan single use container is successfully stopped. "
}
else {
    Write-Host "Your jovyan single use container is not found."
}