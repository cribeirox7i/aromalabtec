# Gera icon-192.png e icon-512.png (frasco AromaLab) usando System.Drawing
Add-Type -AssemblyName System.Drawing

$dir = "K:\Meu Drive\SHEETS\APP_LEMBRETES\AROMALAB-PWA"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

function New-AromaIcon([int]$size, [string]$path) {
  $bmp = New-Object System.Drawing.Bitmap -ArgumentList $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $s = $size / 512.0

  # fundo gradiente marrom
  $rect = New-Object System.Drawing.Rectangle -ArgumentList 0, 0, $size, $size
  $c1 = [System.Drawing.Color]::FromArgb(58, 42, 24)
  $c2 = [System.Drawing.Color]::FromArgb(18, 11, 6)
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush -ArgumentList $rect, $c1, $c2, ([single]65)
  $g.FillRectangle($bg, $rect)

  function Pt([double]$x, [double]$y) {
    return New-Object System.Drawing.PointF -ArgumentList ([single]($x * $s)), ([single]($y * $s))
  }

  # líquido âmbar
  $liq = [System.Drawing.PointF[]]@( (Pt 183 330), (Pt 329 330), (Pt 392 402), (Pt 120 402) )
  $amber = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(201, 142, 74))
  $g.FillPolygon($amber, $liq)

  # contorno do frasco (dourado)
  $flask = [System.Drawing.PointF[]]@( (Pt 216 150), (Pt 296 150), (Pt 296 250), (Pt 392 402), (Pt 120 402), (Pt 216 250) )
  $gold = [System.Drawing.Color]::FromArgb(224, 184, 120)
  $pen = New-Object System.Drawing.Pen -ArgumentList $gold, ([single](14 * $s))
  $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  $g.DrawPolygon($pen, $flask)

  # rolha
  $cork = New-Object System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(149, 98, 46))
  $g.FillRectangle($cork, [single](208 * $s), [single](126 * $s), [single](96 * $s), [single](30 * $s))

  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $pen.Dispose(); $g.Dispose(); $bmp.Dispose()
}

New-AromaIcon 512 (Join-Path $dir "icon-512.png")
New-AromaIcon 192 (Join-Path $dir "icon-192.png")
Write-Output "Icones gerados em $dir"
