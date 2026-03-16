# Fix level3.json image paths - replace absolute paths with relative paths

$inputFile = "assets\images\tiled\level3.json"
$outputFile = "assets\images\tiled\level3_fixed.json"

Write-Host "Reading level3.json..." -ForegroundColor Yellow
$content = Get-Content $inputFile -Raw -Encoding UTF8

Write-Host "Replacing absolute paths..." -ForegroundColor Yellow

# Replace all paths that contain Pictures with just the filename
$pattern = '"image":\s*"[^"]*\\([^\\]+\.png)"'
$replacement = '"image": "$1"'
$content = [regex]::Replace($content, $pattern, $replacement)

Write-Host "Saving to level3_fixed.json..." -ForegroundColor Yellow
$content | Out-File -FilePath $outputFile -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "SUCCESS! File saved to: $outputFile" -ForegroundColor Green
Write-Host ""
Write-Host "Next: Open level3_fixed.json in Tiled to verify" -ForegroundColor Cyan
