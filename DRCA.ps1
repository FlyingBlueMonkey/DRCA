# Defender Recommended Configuration Analyzer
# Author: Matt Egen
# Date: 04/15/2024
# Description: This script compares the configuration of Windows Defender on a system to a reference configuration file and generates an HTML report of the differences.
Import-Module Defender

# Define constants and variables
$referenceConfigurationUri = "https://raw.githubusercontent.com/flyingbluemonkey/DRCA/main/reference.json"

# Get the local MpPreference configuration and store it in an object
$localConfigurationObject = Get-MpPreference
#Sanity check
Write-Host $localConfigurationObject.GetType()

# Fetch the JSON from the URI and convert it to a PowerShell object
$response = Invoke-WebRequest $referenceConfigurationUri
$jsonString = $response.Content
$parsedData = $jsonString | ConvertFrom-Json

$jsonIntermediateObject = Invoke-RestMethod -Uri $referenceConfigurationUri
$referenceConfigurationObject = [Microsoft.Management.Infrastructure.CimInstance]$parsedData
#Sanity check 2.0
Write-Host $referenceConfigurationObject.GetType()

# Compare the local configuration to the reference configuration
$comparisonResult = Compare-Object -ReferenceObject $referenceConfigurationObject -DifferenceObject $localConfigurationObject -IncludeEqual

# Generate HTML report
$htmlReport = "<html><head><style>table, th, td {border: 1px solid black; border-collapse: collapse;} th, td {padding: 10px;} th {text-align: left;}</style></head><body><h1>Comparison Results</h1>"
if ($null -eq $comparisonResult) {
    $htmlReport += "<p>The local configuration and reference configuration are identical.</p>"
} else {
    $htmlReport += "<table><tr><th>Property</th><th>Reference Value</th><th>Local Value</th><th>Side Indicator</th></tr>"
    foreach ($result in $comparisonResult) {
        $htmlReport += "<tr><td>$($result.Property)</td><td>$($result.ReferenceObject | Select-Object -ExpandProperty $result.Property)</td><td>$($result.DifferenceObject | Select-Object -ExpandProperty $result.Property)</td><td>$($result.SideIndicator)</td></tr>"
    }
    $htmlReport += "</table>"
}

$htmlReport += "</body></html>"

# Output the HTML report to a file
$htmlReport | Out-File ".\DRCA.html"
