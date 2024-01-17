# Check if the script is running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Please run the script as an administrator to ensure proper execution."
    exit 1
}

# Error handling function
function Handle-Error {
    param(
        [string]$errorMessage
    )
    Write-Host "Error: $errorMessage"
    exit 1
}

# Get the most recent restore point
$restorePoint = Get-ComputerRestorePoint | Sort-Object -Property CreationTime -Descending | Select-Object -First 1

if ($restorePoint) {
    # Display information about the restore point
    Write-Host "Found restore point:"
    Write-Host "Description: $($restorePoint.Description)"
    Write-Host "Creation Time: $($restorePoint.CreationTime)"

    # Prompt for confirmation
    $confirmation = Read-Host "Do you want to restore to this point? (Y/N)"
    if ($confirmation -eq 'Y') {
        # Perform the system restore
        Write-Host "Restoring to the selected restore point..."
        $result = Restart-Computer -Restore -Confirm:$false

        if ($result) {
            Write-Host "System restore completed successfully."
        } else {
            Write-Host "System restore failed."
        }
    } else {
        Write-Host "System restore canceled."
    }
} else {
    Write-Host "No restore points found."
}
