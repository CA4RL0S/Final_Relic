$jsonPath = "assets\images\tiled\level3.json"
$content = Get-Content $jsonPath -Raw
# Reemplazar rutas absolutas largas con solo el nombre del archivo
# Busca "image":".../NombreArchivo.png" y lo reemplaza por "image":"NombreArchivo.png"
$newContent = $content -replace '"image":"[^"]*[\\/]([^\\/]+\.png)"', '"image":"$1"'
Set-Content $jsonPath $newContent -NoNewline
Write-Host "Rutas de imágenes corregidas en level3.json"
