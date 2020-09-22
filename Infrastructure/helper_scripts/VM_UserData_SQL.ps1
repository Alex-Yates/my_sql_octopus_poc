<powershell>
$ErrorActionPreference = "stop"

$startupDir = "C:\Startup"
if ((test-path $startupDir) -ne $true) {
  New-Item -ItemType "Directory" -Path $startupDir
}

Set-Location $startupDir

# If for whatever reason this doesn't work, check this file:
$log = ".\StartupLog.txt"
Write-Output " Creating log file at $log"
Start-Transcript -path $log -append

Function Get-Script{
  param (
    [Parameter(Mandatory=$true)][string]$script,
    [string]$owner = "__REPOOWNER__",
    [string]$repo = "__REPONAME__",
    [string]$branch = "main",
    [string]$path = "scripts",
    [string]$outFile = ".\$path\$script"
  )
  if ((test-path $repo) -ne $true) {
    Write-Output "  Creating directory $startupDir\$repo"
    New-Item -ItemType "Directory" -Path $repo
  }
  $uri = "https://raw.githubusercontent.com/$owner/$repo/$branch/$path/$script"
  Write-Output "Downloading $script"
  Write-Output "  from: $uri"
  Write-Output "  to: $outFile"
  Invoke-WebRequest -Uri $uri -OutFile $outFile -Verbose
}

Write-Output "*"
Get-Script -script "setup_users.ps1"
Write-Output "Executing ./$path/setup_users.ps1"
./$path/setup_users.ps1

Write-Output "To do: install SQL - probably via a container"

<# DEPLOY TENTACLE
$octopusServerUrl = "__OCTOPUSURL__"
$registerInEnvironments = "__ENV__"

Write-Output "*"
Get-Script -script "install_tentacle.ps1"
Write-Output "Executing ./$path/install_tentacle.ps1 -octopusServerUrl $octopusServerUrl -registerInEnvironments $registerInEnvironments"
./$path/install_tentacle.ps1 -octopusServerUrl $octopusServerUrl -registerInEnvironments $registerInEnvironments
DEPLOY TENTACLE #>

Write-Output "VM_UserData startup script completed..."
</powershell>



