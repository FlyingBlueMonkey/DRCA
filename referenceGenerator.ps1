# Defender Recommended Configuration Analyzer - Reference Generator
# Author: Matt Egen
# Date: 04/15/2024
# Description: This script fetches the current configuration of Windows Defender on a system and saves it to a JSON file for use as a reference configuration in the Defender Recommended Configuration Analyzer script.
Import-Module Defender
$referenceObject = Get-MpPreference
$referenceObject | ConvertTo-Json | Out-File ".\reference.json"