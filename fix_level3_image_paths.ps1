# Script para reemplazar rutas absolutas con rutas relativas en level3.json
# Todas las imágenes ya están en assets/images/tiled

Write-Host "=== Reemplazando rutas absolutas en level3.json ===" -ForegroundColor Cyan
Write-Host ""

$inputFile = "assets\images\tiled\level3.json"
$outputFile = "assets\images\tiled\level3_fixed.json"
$backupFile = "assets\images\tiled\level3_backup.json"

if (-not (Test-Path $inputFile)) {
    Write-Host "ERROR: No se encontró $inputFile" -ForegroundColor Red
    exit 1
}

Write-Host "1. Leyendo archivo..." -ForegroundColor Yellow
$content = Get-Content $inputFile -Raw -Encoding UTF8

# Crear backup si no existe
if (-not (Test-Path $backupFile)) {
    Write-Host "2. Creando backup..." -ForegroundColor Yellow
    Copy-Item $inputFile $backupFile -Force
} else {
    Write-Host "2. Backup ya existe, saltando..." -ForegroundColor Gray
}

Write-Host "3. Reemplazando rutas absolutas..." -ForegroundColor Yellow

# Lista de archivos PNG que necesitan ser corregidos
$imageFiles = @(
    "decorative_cracks_walls.png",
    "decorative_cracks_floor.png",
    "walls_floor.png",
    "Water_coasts_animation.png",
    "water_details_animation.png",
    "decorative_cracks_coasts_animation.png",
    "fire_animation.png",
    "fire_animation2.png",
    "doors_lever_chest_animation.png",
    "Objects.png",
    "trap_animation.png"
)

$replacementCount = 0

foreach ($imageFile in $imageFiles) {
    # Patrón regex para encontrar cualquier ruta que termine con este archivo
    # Ejemplo: "../../../.../Pictures/.../Tiled_files/water_details_animation.png"
    $pattern = '"image":\s*"[^"]*' + [regex]::Escape($imageFile) + '"'
    
    # Reemplazo: solo el nombre del archivo (ruta relativa)
    $replacement = '"image": "' + $imageFile + '"'
    
    # Contar cuántas veces se encuentra
    $matches = [regex]::Matches($content, $pattern)
    if ($matches.Count -gt 0) {
        Write-Host "  ✓ $imageFile ($($matches.Count) ocurrencias)" -ForegroundColor Green
        $replacementCount += $matches.Count
        $content = [regex]::Replace($content, $pattern, $replacement)
    }
}

Write-Host ""
Write-Host "4. Guardando archivo corregido..." -ForegroundColor Yellow
$content | Out-File -FilePath $outputFile -Encoding UTF8 -NoNewline

if (Test-Path $outputFile) {
    $originalSize = (Get-Item $inputFile).Length
    $newSize = (Get-Item $outputFile).Length
    
    Write-Host ""
    Write-Host "=== ÉXITO ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Rutas reemplazadas: $replacementCount" -ForegroundColor White
    Write-Host "Tamaño original: $([math]::Round($originalSize/1KB, 2)) KB" -ForegroundColor White
    Write-Host "Tamaño nuevo: $([math]::Round($newSize/1KB, 2)) KB" -ForegroundColor White
    Write-Host ""
    Write-Host "Archivos:" -ForegroundColor Cyan
    Write-Host "  Backup: $backupFile" -ForegroundColor White
    Write-Host "  Corregido: $outputFile" -ForegroundColor Green
    Write-Host ""
    Write-Host "PRÓXIMOS PASOS:" -ForegroundColor Yellow
    Write-Host "1. Abre $outputFile en Tiled para verificar" -ForegroundColor White
    Write-Host "2. Si todo se ve bien, puedes reemplazar level3.json" -ForegroundColor White
    Write-Host "3. Prueba con: flutter run" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "ERROR: No se pudo crear el archivo de salida" -ForegroundColor Red
    exit 1
}
