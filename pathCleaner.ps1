# Function to get the system environment variable
function Get-SystemEnvVariable {
    param (
        [string]$variableName
    )
    $value = [System.Environment]::GetEnvironmentVariable($variableName, [System.EnvironmentVariableTarget]::Machine)
    if ($null -eq $value) {
        Write-Output "Environment variable '$variableName' does not exist."
    } else {
        Write-Output "$variableName = $value"
    }
}

# Function to set the system environment variable
function Set-SystemEnvVariable {
    param (
        [string]$variableName,
        [string]$variableValue
    )
    [System.Environment]::SetEnvironmentVariable($variableName, $variableValue, [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Environment variable '$variableName' set to '$variableValue'."
}

# Function to remove the system environment variable
function Remove-SystemEnvVariable {
    param (
        [string]$variableName
    )
    [System.Environment]::SetEnvironmentVariable($variableName, $null, [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Environment variable '$variableName' has been removed."
}

# Function to add a path to the system PATH variable
function Add-ToSystemPath {
    param (
        [string]$newPath
    )
    $currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    if ($currentPath -notlike "*$newPath*") {
        $newPath = "$currentPath;$newPath"
        [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Path '$newPath' has been added to the system PATH variable."
    } else {
        Write-Output "Path '$newPath' is already in the system PATH variable."
    }
}

# Function to remove a path from the system PATH variable
function Remove-FromSystemPath {
    param (
        [string]$oldPath
    )
    $currentPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    $newPath = $currentPath -replace [Regex]::Escape($oldPath + ';'), ''
    $newPath = $newPath -replace [Regex]::Escape(';' + $oldPath), ''
    $newPath = $newPath -replace [Regex]::Escape($oldPath), ''
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
    Write-Output "Path '$oldPath' has been removed from the system PATH variable."
}

# Function to list all system environment variables
function List-SystemEnvVariables {
    $envVars = [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::Machine)
    foreach ($envVar in $envVars.Keys) {
        Write-Output "$envVar = $envVars[$envVar]"
    }
}

# Main script logic
Write-Output "Select an option:"
Write-Output "1. Get a system environment variable"
Write-Output "2. Set a system environment variable"
Write-Output "3. Remove a system environment variable"
Write-Output "4. Add a path to the system PATH variable"
Write-Output "5. Remove a path from the system PATH variable"
Write-Output "6. List all system environment variables"

$option = Read-Host "Enter your option (1-6)"

switch ($option) {
    1 {
        $varName = Read-Host "Enter the name of the environment variable"
        Get-SystemEnvVariable -variableName $varName
    }
    2 {
        $varName = Read-Host "Enter the name of the environment variable"
        $varValue = Read-Host "Enter the value of the environment variable"
        Set-SystemEnvVariable -variableName $varName -variableValue $varValue
    }
    3 {
        $varName = Read-Host "Enter the name of the environment variable"
        Remove-SystemEnvVariable -variableName $varName
    }
    4 {
        $newPath = Read-Host "Enter the path to add to the system PATH variable"
        Add-ToSystemPath -newPath $newPath
    }
    5 {
        $oldPath = Read-Host "Enter the path to remove from the system PATH variable"
        Remove-FromSystemPath -oldPath $oldPath
    }
    6 {
        List-SystemEnvVariables
    }
    default {
        Write-Output "Invalid option selected."
    }
}
