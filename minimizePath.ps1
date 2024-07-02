# Function to get the current system PATH variable
function Get-SystemPath {
    $currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    return $currentPath
}

# Function to set the system PATH variable
function Set-SystemPath {
    param (
        [string]$newPath
    )
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Output "System PATH variable has been updated."
}

# Function to minimize the system PATH variable
function Minimize-SystemPath {
    $currentPath = Get-SystemPath
    $pathArray = $currentPath -split ';'
    $cleanPathArray = @()
    $invalidPaths = @()

    foreach ($path in $pathArray) {
        $trimmedPath = $path.Trim()
        if ($trimmedPath -ne '' -and $cleanPathArray -notcontains $trimmedPath) {
            # Replace paths with abbreviated/shortened versions if possible
            $shortenedPath = [System.IO.Path]::GetFullPath($trimmedPath)
            if ($shortenedPath -ne $null -and $cleanPathArray -notcontains $shortenedPath) {
                # Check if the path is valid
                if (Test-Path $shortenedPath) {
                    $cleanPathArray += $shortenedPath
                } else {
                    $invalidPaths += $shortenedPath
                }
            } else {
                if (Test-Path $trimmedPath) {
                    $cleanPathArray += $trimmedPath
                } else {
                    $invalidPaths += $trimmedPath
                }
            }
        }
    }

    $newPath = $cleanPathArray -join ';'
    Set-SystemPath -newPath $newPath
    Write-Output "System PATH variable has been minimized."
    if ($invalidPaths.Count -gt 0) {
        Write-Output "Invalid paths that were removed:"
        $invalidPaths | ForEach-Object { Write-Output $_ }
    }
}

# Function to list the current system PATH variable
function List-SystemPath {
    $currentPath = Get-SystemPath
    Write-Output "Current system PATH variable:"
    $currentPath -split ';' | ForEach-Object { Write-Output $_ }
}

# Main script logic
Write-Output "Minimizing the system PATH variable..."
Minimize-SystemPath

Write-Output "`nUpdated system PATH variable:"
List-SystemPath
