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

Write-Host "Note, that image tag for your Docker model image is the step run-id"
Write-Host "Note, that image name for your Docker model image is the step output entity (bentoservice)"

$bentoservicePath = Read-Host -Prompt "Please, enter ENTITY_PATH for your bentoservice: "
$bentoserviceDirname = Split-Path -Path $bentoservicePath
$defaultImageTag =  Split-Path -Path $bentoserviceDirname -Leaf

$dockerRegistry = Read-Host -Prompt "Please, enter Docker registry address for your model image: "

$modelImageTag = "$defaultImageTag"

$bentoserviceDir = Split-Path -Path $bentoservicePath -Leaf

if(Test-Path -Path $bentoserviceDir) {
  Remove-Item -Recurse -Force "$bentoserviceDir"
}

docker cp ${instanceName}:/${bentoservicePath} .

Set-Location -Path $bentoserviceDir

# Expand-Archive cmdlet is only available in PS5+
$shell = New-Object -ComObject shell.application
$zip = $shell.NameSpace("model.zip")
foreach ($item in $zip.items()) {
  $shell.Namespace($bentoserviceDir).CopyHere($item)
}

Remove-Item -Recurse -Force _SUCCESS
Remove-Item -Recurse -Force  model.zip

$saveInfo = Get-Content "save_info.txt" | ConvertFrom-StringData
$modelName = $saveInfo.BENTO_SERVICE -replace '\.[^.]*$',''

docker build . -t $dockerRegistry/${modelName}:${modelImageTag}