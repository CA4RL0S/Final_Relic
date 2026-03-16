# Script to fix level3_fixed.json by removing ALL embedded tileset data
# Keeps only external tileset references

Write-Host "=== Fixing level3_fixed.json JSON Structure ===" -ForegroundColor Cyan
Write-Host ""

$inputFile = "assets\images\tiled\level3_fixed.json"

if (-not (Test-Path $inputFile)) {
    Write-Host "ERROR: File not found: $inputFile" -ForegroundColor Red
    exit 1
}

Write-Host "1. Reading file..." -ForegroundColor Yellow
$json = Get-Content $inputFile -Raw -Encoding UTF8 | ConvertFrom-Json

Write-Host "2. Removing embedded tilesets..." -ForegroundColor Yellow

# Create new tilesets array with ONLY external references
$newTilesets = @(
    @{
        firstgid = 1
        source = "tileSet.json"
    },
    @{
        firstgid = 187
        source = "tile_set3.json"
    }
)

# Replace the tilesets array
$json.tilesets = $newTilesets

Write-Host "3. Saving fixed JSON..." -ForegroundColor Yellow
$json | ConvertTo-Json -Depth 100 -Compress:$false | Out-File -FilePath $inputFile -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "=== SUCCESS ===" -ForegroundColor Green
Write-Host "File fixed: $inputFile" -ForegroundColor White
Write-Host ""
Write-Host "The file now contains only external tileset references." -ForegroundColor Green
Write-Host ""
