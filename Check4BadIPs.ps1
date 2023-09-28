# Author: EverStaR and GPTChat V4.5 AI
# Date: 9/27/2023
# Version: 1.1
# Comments and questions to: scripter@everstar.com

# Configuration
$directoryPath = "Y:\AI\Development\"
$badIPListFile = "${directoryPath}BadIPList.csv"
$netTrafficReportFile = "${directoryPath}NetTrafficReport.csv"
$logFile = "${directoryPath}ScriptLog.txt"

# Initialize log file
"--- Script Execution Started: $(Get-Date) ---" | Out-File -FilePath $logFile -Append

# Function to log messages
function Write-LogMessage {
    param (
        [string]$Message
    )
    "$Message" | Out-File -FilePath $logFile -Append
}

# Function to update bad IP list
function Update-BadIPList {
    Write-Host "`n[Step 1] Update Bad IP List"
    $continue = Read-Host "Do you wish to continue? (y/n)"
    if ($continue -eq 'n') { return }
    
    $url = "https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt"
    $outputFilePath = $badIPListFile

    try {
        if (Test-Path $outputFilePath) {
            $lastWriteTime = Get-Item $outputFilePath | Select-Object -ExpandProperty LastWriteTime
            if ((Get-Date) - $lastWriteTime -gt [TimeSpan]::FromHours(1)) {
                Write-Host -ForegroundColor Green "Updating the bad IP list..."
            } else {
                Write-Host -ForegroundColor Green "Skipping update."
                return
            }
        }
        $ipListContent = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content
        $ipList = $ipListContent -split "`n" | Where-Object { $_ -notmatch "^#" } | ForEach-Object { [PSCustomObject]@{ IP = $_ } }
        $ipList | Export-Csv -Path $outputFilePath -NoTypeInformation
        Write-Host -ForegroundColor Green "The bad IP list has been updated."
    } catch {
        Write-Host -ForegroundColor Red "An error occurred: $_"
        Write-LogMessage "An error occurred during Bad IP list update: $_"
    }
    Write-LogMessage "Bad IP list updated."
}

# Function to generate net traffic report
function Generate-NetTrafficReport {
    Write-Host "`n[Step 2] Generate Net Traffic Report"
    $continue = Read-Host "Do you wish to continue? (y/n)"
    if ($continue -eq 'n') { return }
    
    $udpConnections = Get-NetUDPEndpoint | Select-Object -Property OwningProcess, LocalAddress, RemoteAddress, Protocol
    $tcpConnections = Get-NetTCPConnection | Select-Object -Property OwningProcess, LocalAddress, RemoteAddress, State, OffloadState, CreationTime, CertificateSubject, Protocol
    
    $udpTable = $udpConnections | Sort-Object -Property OwningProcess | Select-Object -Unique -Property OwningProcess, LocalAddress, RemoteAddress, Protocol
    $tcpTable = $tcpConnections | Sort-Object -Property OwningProcess | Select-Object -Unique -Property OwningProcess, LocalAddress, RemoteAddress, State, OffloadState, CreationTime, CertificateSubject, Protocol
    
    $udpTable | Export-Csv -Path $netTrafficReportFile -NoTypeInformation -Force
    $tcpTable | Export-Csv -Path $netTrafficReportFile -NoTypeInformation -Append -Force
    Write-Host -ForegroundColor Green "Net traffic report generated."
    Write-LogMessage "Net traffic report generated."
}

# Function to check for bad IPs
function Check-BadIPs {
    Write-Host "`n[Step 3] Check for Bad IPs"
    $continue = Read-Host "Do you wish to continue? (y/n)"
    if ($continue -eq 'n') { return }

    $badIPList = Import-Csv -Path $badIPListFile
    $netTrafficReport = Import-Csv -Path $netTrafficReportFile
    $badIPs = @()

    foreach ($connection in $netTrafficReport) {
        if ($badIPList.IP -contains $connection.RemoteAddress) {
            $badIPs += $connection.RemoteAddress
        }
    }
    $badIPs = $badIPs | Select-Object -Unique

    if ($badIPs) {
        Write-Host -ForegroundColor Red "WARNING: Your computer is connected to the following bad IPs:"
        $badIPs | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host -ForegroundColor Green "No bad IP connections detected."
    }
    Write-LogMessage "Bad IPs checked."
}

# Main Execution Block
Write-Host "`n=== PowerShell Security Script ==="
Write-Host "This script performs three main functions:"
Write-Host "1. Update the bad IP list."
Write-Host "2. Generate a net traffic report."
Write-Host "3. Check for bad IPs."
$continue = Read-Host "`nDo you wish to proceed with all steps? (y/n)"
if ($continue -eq 'y') {
    try {
        Update-BadIPList
        Generate-NetTrafficReport
        Check-BadIPs
        Write-LogMessage "--- Script Execution Completed Successfully: $(Get-Date) ---"
    } catch {
        Write-Host -ForegroundColor Red "`nAn error occurred: $_"
        Write-LogMessage "An error occurred: $_"
        Write-LogMessage "--- Script Execution Failed: $(Get-Date) ---"
    }
} else {
    Write-Host "`nExiting the script."
    Write-LogMessage "User chose to exit the script."
    Write-LogMessage "--- Script Execution Terminated by User: $(Get-Date) ---"
}
