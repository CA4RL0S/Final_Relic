
$jsonPath = "assets/images/tiled/level2.json"
$content = Get-Content $jsonPath -Raw | ConvertFrom-Json

# Find collision layer
$collisionLayer = $content.layers | Where-Object { $_.name -eq "collision" }

if ($collisionLayer) {
    Write-Host "Found collision layer. Updating objects..."
    foreach ($obj in $collisionLayer.objects) {
        $obj.type = "collision"
        # Also set class for newer Tiled/Bonfire versions
        if (-not $obj.PSObject.Properties['class']) {
            $obj | Add-Member -MemberType NoteProperty -Name "class" -Value "collision"
        } else {
            $obj.class = "collision"
        }
    }
    
    # Save back to file
    $jsonContent = $content | ConvertTo-Json -Depth 10
    $jsonContent | Set-Content $jsonPath
    Write-Host "Updated level2.json with collision types."
} else {
    Write-Host "Collision layer not found!"
}
