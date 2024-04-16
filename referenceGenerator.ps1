# Defender Recommended Configuration Analyzer - Reference Generator
# Author: Matt Egen
# Date: 04/15/2024
# Description: This script fetches the current configuration of Windows Defender on a system and saves it to a JSON file for use as a reference configuration in the Defender Recommended Configuration Analyzer script.
Import-Module Defender
$referenceObject = Get-MpPreference

# Create a custom object or hashtable (if selective properties are needed)
$customObject = New-Object -TypeName PSObject

foreach ($prop in $referenceObject.PSObject.Properties) {
    # Add each property to the custom object
    $customObject | Add-Member -MemberType NoteProperty -Name $prop.Name -Value $prop.Value
}

# Convert to JSON and save to a file
$jsonContent = $customObject | ConvertTo-Json -Depth 10  # Adjust depth as necessary
$jsonContent | Out-File -FilePath ".\reference.json"
