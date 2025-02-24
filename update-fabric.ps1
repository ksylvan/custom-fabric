#!/usr/bin/env pwsh

# Change to the directory containing this script
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

$FABRIC_CONFIG_DIR = "$HOME\.config\fabric"
$PATTERNS_DIR = "$FABRIC_CONFIG_DIR\patterns"

if (-Not (Test-Path -Path $PATTERNS_DIR -PathType Container)) {
    Write-Host "Fabric configuration directory not found at $FABRIC_CONFIG_DIR"
    exit 1
}

Write-Host "Updating Fabric configuration with custom patterns..."
Copy-Item -Path "patterns\*" -Destination $PATTERNS_DIR -Recurse

# Copy each script in the scripts directory to the fabric configuration directory
$SCRIPTS_DIR = "scripts"
$SCRIPT_FILES = Get-ChildItem -Path $SCRIPTS_DIR -Filter *.ps1

foreach ($SCRIPT in $SCRIPT_FILES) {
    Copy-Item -Path $SCRIPT.FullName -Destination $FABRIC_CONFIG_DIR
    Write-Host "Copied $($SCRIPT.Name) to $FABRIC_CONFIG_DIR"
}
