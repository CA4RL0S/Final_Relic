# Final working script to fix level3.json
# Removes ALL embedded tilesets and keeps only external references

Write-Host "=== Level3 Tileset Fixer (Final Version) ===" -ForegroundColor Cyan
Write-Host ""

$sourceFile = "assets\images\tiled\level3.json"
$outputFile = "assets\images\tiled\level3_fixed.json"
$backupFile = "assets\images\tiled\level3_backup.json"

if (-not (Test-Path $sourceFile)) {
    Write-Host "ERROR: Source file not found" -ForegroundColor Red
    exit 1
}

Write-Host "1. Reading file (609KB)..." -ForegroundColor Yellow
$content = Get-Content $sourceFile -Raw -Encoding UTF8

if (-not (Test-Path $backupFile)) {
    Write-Host "2. Creating backup..." -ForegroundColor Yellow
    Copy-Item $sourceFile $backupFile -Force
} else {
    Write-Host "2. Backup exists, skipping..." -ForegroundColor Gray
}

Write-Host "3. Finding embedded tilesets section..." -ForegroundColor Yellow

# The file has this structure:
# ... map data ...
# "tilesets":[ <-- Line 5051
#   { embedded tileset 1 with bad paths },
#   { embedded tileset 2 with bad paths },
#   ...
#   { embedded tileset N with bad paths },
#   { "firstgid":6329, "source":"tile_set3.json" }  <-- This one is good!
# ],
# "tilewidth":16,

# We need to remove everything from "tilesets":[ up to and including the last embedded tileset
# but KEEP the external reference to tile_set3.json

# Find the position of "tilesets":
$tilesetStart = $content.IndexOf('"tilesets":[')
if ($tilesetStart -eq -1) {
    Write-Host "ERROR: Could not find tilesets section" -ForegroundColor Red
    exit 1
}

# Find the last occurrence of "source":"tile_set3.json" (the external reference we want to keep)
$externalTilesetPattern = '\{\s*"firstgid":\d+,\s*"source":"tile_set3\.json"\s*\}'
if ($content -match $externalTilesetPattern) {
    $externalTileset = $matches[0]
    Write-Host "   Found external tileset reference" -ForegroundColor Green
} else {
    Write-Host "ERROR: Could not find external tileset reference" -ForegroundColor Red
    exit 1
}

# Get everything BEFORE "tilesets":[
$beforeTilesets = $content.Substring(0, $tilesetStart)

# Get everything AFTER the tilesets array (from "tilewidth" onwards)
$afterPattern = '\],\s*"tilewidth"'
if ($content -match $afterPattern) {
    $afterMatch = $content.IndexOf($matches[0], $tilesetStart)
    $afterTilesets = $content.Substring($afterMatch + 2) # Skip "],
    Write-Host "   Found end of tilesets section" -ForegroundColor Green
} else {
    Write-Host "ERROR: Could not find end of tilesets section" -ForegroundColor Red
    exit 1
}

Write-Host "4. Creating new tilesets section..." -ForegroundColor Yellow

# Create new clean tilesets section with ONLY external references
$newTilesets = '"tilesets":[' + "`r`n" +
               '        {' + "`r`n" +
               '         "firstgid":1,' + "`r`n" +
               '         "source":"tileSet.json"' + "`r`n" +
               '        },' + "`r`n" +
               '        {' + "`r`n" +
               '         "firstgid":187,' + "`r`n" +
               '         "source":"tile_set3.json"' + "`r`n" +
               '        }],' + "`r`n" +
               ' '

Write-Host "5. Assembling new file..." -ForegroundColor Yellow
$newContent = $beforeTilesets + $newTilesets + $afterTilesets

Write-Host "6. Saving..." -ForegroundColor Yellow
$newContent | Out-File -FilePath $outputFile -Encoding UTF8 -NoNewline

if (Test-Path $outputFile) {
    $newSize = (Get-Item $outputFile).Length
    $originalSize = (Get-Item $sourceFile).Length
    
    Write-Host ""
    Write-Host "=== SUCCESS ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Original: $([math]::Round($originalSize/1KB, 2)) KB" -ForegroundColor White
    Write-Host "New: $([math]::Round($newSize/1KB, 2)) KB" -ForegroundColor White
    Write-Host "Saved: $([math]::Round(($originalSize - $newSize)/1KB, 2)) KB" -ForegroundColor Green
    Write-Host ""
    Write-Host "Files:" -ForegroundColor Cyan
    Write-Host "  Backup: $backupFile" -ForegroundColor White
    Write-Host "  Fixed map: $outputFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. Open $outputFile in Tiled to verify" -ForegroundColor White
    Write-Host "2. Some tiles may need manual replacement" -ForegroundColor Magenta
    Write-Host "3. Update level3.dart line 11 to: mapPath: 'tiled/level3_fixed.json'," -ForegroundColor White
    Write-Host "4. Test with: flutter run" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "ERROR: Failed to create output" -ForegroundColor Red
    exit 1
}
