$StorageAccount = "sasfswd01"
$Container = "error-pages-d01"
$FilePath = "403.html"
$BlobName = "403.html"

$context = (Get-AzStorageAccount -ResourceGroupName "s212d01-rg-sfsw-app" -Name $StorageAccount).Context

# Upload the blob
try {
    Set-AzStorageBlobContent `
        -Context $context `
        -Container $Container `
        -File $FilePath `
        -Blob $BlobName `
        -ErrorAction Stop
    Write-Host "Blob upload succeeded!" -ForegroundColor Green
} catch {
    Write-Host "Blob upload failed: $_" -ForegroundColor Red
}