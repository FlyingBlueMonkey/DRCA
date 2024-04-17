# Defender Recommended Configuration Analyzer - Reference Generator
# Author: Matt Egen
# Date: 04/15/2024
# Description: This script fetches the current configuration of Windows Defender on a system and saves it to a JSON file for use as a reference configuration in the Defender Recommended Configuration Analyzer script.
Import-Module Defender
$referenceObject = Get-MpPreference
$referenceObject | ConvertTo-Json | Out-File ".\reference.json"
Get-Content .\reference.json | Set-Content -Encoding utf8 ".\reference-utf8.json"
Remove-Item .\reference.json
Rename-Item .\reference-utf8.json reference.json #dumb and hacky but it works and I don't care at this point