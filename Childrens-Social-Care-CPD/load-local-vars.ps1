# Load the secrets from secrets.json
$jsonContent = Get-Content -Raw -Path .\secrets.json | ConvertFrom-Json

# Set each secret as an environment variable in memory for the current session
$jsonContent.PSObject.Properties.Name | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable($_, $jsonContent.$_)
}

# Display the environment variables
Write-Output "Loaded environment variables:"
$jsonContent.PSObject.Properties.Name | ForEach-Object {
    $envVar = [System.Environment]::GetEnvironmentVariable($_)
    Write-Output "$_=$envVar"
}

# Run docker-compose with the environment variables in memory
# docker-compose up -d
