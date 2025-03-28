param (
    [string]$VaultName = "<>",
    [string]$rgName = "<>",
    [string]$SpClientId = "<>",
    [bool]$Remove = $false
)

$principalId = (Get-AzADServicePrincipal -ApplicationId $SpClientId).Id

if ($Remove) {
    Remove-AzKeyVaultAccessPolicy -VaultName $VaultName -ObjectId $principalId -ResourceGroupName $rgName
    Write-Output "Removed access policies for SP with OID: $principalId from Key Vault: $VaultName"
} else {
    Set-AzKeyVaultAccessPolicy -VaultName $VaultName -ObjectId $principalId `
        -PermissionsToSecrets all `
        -PermissionsToKeys all `
        -PermissionsToCertificates all `
        -ResourceGroupName $rgName
    Write-Output "Assigned all permissions to SP with OID: $principalId for Key Vault: $VaultName"
}