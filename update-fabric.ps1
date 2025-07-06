#!/usr/bin/env pwsh

# Change to the directory containing this script
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

$FABRIC_CONFIG_DIR = "$HOME\.config\fabric"

Write-Host "Updating Fabric configuration with new bootstrap scripts..."

# Copy each script in the scripts directory to the fabric configuration directory
$SCRIPTS_DIR = "scripts"
$SCRIPT_FILES = Get-ChildItem -Path $SCRIPTS_DIR -Filter *.ps1

foreach ($SCRIPT in $SCRIPT_FILES) {
    Copy-Item -Path $SCRIPT.FullName -Destination $FABRIC_CONFIG_DIR
    Write-Host "Copied $($SCRIPT.Name) to $FABRIC_CONFIG_DIR"
}
