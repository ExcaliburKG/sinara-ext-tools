param (
    [string]$instanceName,
    [string]$runMode = "q",
    [string]$memRequest = "4g",
    [string]$memLimit = "8g",
    [string]$cpuLimit = "4",
    [string]$jovyanDataPath = "",
    [string]$jovyanWorkPath = "",  
    [string]$jovyanTmpPath = "",
    [string]$jovyanRootPath = "",
    [string]$createFolders = "y"
 )

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

 $containerName="jovyan-single-use"

 if (-Not $instanceName) {
    $instanceName = $containerName
 }

Write-Host "Please, keep in mind, that Sinara will be running in a quick start mode."
Write-Host "After familiarization, we recommend starting in basic mode via 'powershell create.ps1 -runMode b'"
Write-Host "It will start asking for paths for code (work), data, tmp."
Write-Host "For any run mode, the following compute resources are allocated as if we run it via 'bash create.sh --memRequest 4g --memLimit 8g --cpuLimit 4'"
Write-Host "You can set them by your demand."
Write-Host "You can name your Sinara instance with 'bash create.sh --instanceName your_name' "
Write-Host "And then use that parameter in all other tools to control your instance."
Write-Host "If you want to change the run mode, you need to issue 'remove.sh' in advance."

if ( $runMode -eq "q" ) {
    $dataVolume="jovyan-data-${instanceName}"
    $workVolume="jovyan-work-${instanceName}"
    $tmpVolume="jovyan-tmp-${instanceName}"

    $volume = docker volume ls | Out-String -stream | Select-String -Pattern $dataVolume -SimpleMatch
    if (!$volume) {
        docker volume create $dataVolume
    }
    else {
        Write-Host "Docker volume with jovyan data is found"
    }

    $volume = docker volume ls | Out-String -stream | Select-String -Pattern $workVolume -SimpleMatch
    if (!$volume) {
        docker volume create $workVolume
    }
    else {
        Write-Host "Docker volume with jovyan work is found"
    }

    $volume = docker volume ls | Out-String -stream | Select-String -Pattern $tmpVolume -SimpleMatch
    if (!$volume) {
        docker volume create $tmpVolume
    }
    else {
        Write-Host "Docker volume with jovyan tmp data is found"
    }

    if( docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch ) {
        Write-Host "Your jovyan single use container is found"
        docker start $instanceName
    }
    else {
        if( docker ps | Out-String -stream | Select-String -Pattern "$instanceName" -SimpleMatch ) {
            Write-Host "Your jovyan single use container is already running"
        }
        else {
            docker create -p 8888:8888 -p 4040-4060:4040-4060 -v ${workVolume}:/home/jovyan/work -v ${dataVolume}:/data -v ${tmpVolume}:/tmp -e DSML_USER=jovyan `
            --name "$instanceName" `
            --memory-reservation=$memRequest `
            --memory=$memLimit `
            --cpus=$cpuLimit `
            -w /home/jovyan/work `
            buslovaev/sinara-notebook `
            start-notebook.sh `
            --ip=0.0.0.0 `
            --port=8888 `
            --NotebookApp.default_url=/lab `
            --NotebookApp.token='' `
            --NotebookApp.password=''

            Write-Host "Your jovyan single use container is created"
        }
    }
}
else {
    if($runMode -eq "b") {
        if($createFolders -eq "y"){
            if ( !$jovyanRootPath ) {
                $jovyanRootPath = Read-Host -Prompt "Please, choose jovyan Root folder path (data, work and tmp will be created there): "
            }  
            $jovyanDataPath="${jovyanRootPath}\data"
            $jovyanWorkPath="${jovyanRootPath}\work"
            $jovyanTmpPath="${jovyanRootPath}\tmp"
            Write-Host "Creating folders"
            mkdir -p "$jovyanDataPath"
            mkdir -p "$jovyanWorkPath"
            mkdir -p "$jovyanTmpPath"
        }
        else {
            if ( !$jovyanDataPath ) {
                $jovyanDataPath = Read-Host -Prompt "Please, choose a jovyan Data path: "
            }   
    
            if ( !$jovyanWorkPath ) {
                $jovyanWorkPath = Read-Host -Prompt "Please, choose a jovyan Work path: "
            }
    
            if ( !$jovyanTmpPath ) {
                $jovyanTmpPath = Read-Host -Prompt "Please, choose a jovyan Tmp path: "
            }
        }

        $foldersExist = Read-Host -Prompt "Please, ensure that the folders exist (y/n): "
        if ($foldersExist -eq "y") {
            Write-Host "Trying to run your environment"
        }
        else {
            Write-Host "Sorry, you should prepare the folders beforehand"
            exit 1
        }

        if (docker ps -a --filter "status=exited" | Out-String -stream | Select-String -Pattern $instanceName -SimpleMatch) {
        Write-Host "Your jovyan single use container is found"
        docker start $instanceName
        }
        else {
            if (docker ps |  Out-String -stream | Select-String -Pattern $instanceName -SimpleMatch) {
                Write-Host "Your jovyan single use container is already running"
            }
            else {
                docker create -p 8888:8888 -p 4040-4060:4040-4060 -v ${jovyanWorkPath}:/home/jovyan/work -v ${jovyanDataPath}:/data -v ${jovyanTmpPath}:/tmp -e DSML_USER=jovyan `
                --name "$instanceName" `
                --memory-reservation=$memRequest `
                --memory=$memLimit `
                --cpus=$cpuLimit `
                -w /home/jovyan/work `
                buslovaev/sinara-notebook `
                start-notebook.sh `
                --ip=0.0.0.0 `
                --port=8888 `
                --NotebookApp.default_url=/lab `
                --NotebookApp.token='' `
                --NotebookApp.password=''
                
                Write-Host "Your jovyan single use container is created"
            }
        }
    }
}

# End
#echo "Please, follow the URL http://127.0.0.1:8888/lab to access your jovyan single use, by using CTRL key"

