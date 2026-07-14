# Gera icon-192.png e icon-512.png (logo AromaLabTec) compondo logo.png
# sobre um fundo escuro solido - PNGs "maskable" do PWA precisam de fundo
# opaco (o SO recorta em circulo/squircle, entao o conteudo fica dentro de
# uma "safe zone" central pra nao ser cortado).
Add-Type -AssemblyName System.Drawing

$dir = "G:\Meu Drive\PROJETOS\Claude\AromaLab\AROMALAB-PWA"
$logoPath = Join-Path $dir "logo.png"

function New-AromaIcon([int]$size, [string]$path, [double]$fracConteudo) {
  $bmp = New-Object System.Drawing.Bitmap -ArgumentList $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

  # fundo gradiente escuro (mesmo tom do tema do app)
  $rect = New-Object System.Drawing.Rectangle -ArgumentList 0, 0, $size, $size
  $c1 = [System.Drawing.Color]::FromArgb(26, 20, 16)
  $c2 = [System.Drawing.Color]::FromArgb(11, 8, 6)
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush -ArgumentList $rect, $c1, $c2, ([single]45)
  $g.FillRectangle($bg, $rect)

  # logo centralizado, ocupando fracConteudo da menor dimensao (safe zone)
  $logo = [System.Drawing.Image]::FromFile($logoPath)
  $maxLado = $size * $fracConteudo
  $escala = [Math]::Min($maxLado / $logo.Width, $maxLado / $logo.Height)
  $w = $logo.Width * $escala
  $h = $logo.Height * $escala
  $x = ($size - $w) / 2
  $y = ($size - $h) / 2
  $g.DrawImage($logo, [single]$x, [single]$y, [single]$w, [single]$h)

  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $logo.Dispose(); $g.Dispose(); $bmp.Dispose()
}

# 0.74 = conteudo ocupa 74% do canvas (26% de margem) - dentro da safe zone
# recomendada para icones maskable (Android recorta ate ~20% das bordas)
New-AromaIcon 512 (Join-Path $dir "icon-512.png") 0.74
New-AromaIcon 192 (Join-Path $dir "icon-192.png") 0.74
Write-Output "Icones gerados em $dir"
