# Converte Logo.png (traco marrom solido sobre fundo BRANCO OPACO, apesar de
# ser RGBA) para transparencia real. Usa a formula de "des-composicao" sobre
# fundo branco conhecido: alpha = (255 - canal) / (255 - corFG_canal),
# usando o canal azul (maior contraste entre marrom e branco = alpha mais
# preciso nas bordas suavizadas). A cor final e sempre o marrom solido puro,
# ja que a arte e de cor unica (evita ruido de recuperar cor por pixel).
Add-Type -AssemblyName System.Drawing

$origem = "G:\Meu Drive\PROJETOS\Claude\AromaLab\AROMALAB\Logo.png"
$destino = "G:\Meu Drive\PROJETOS\Claude\AromaLab\AROMALAB-PWA\logo.png"

$fgR = 141; $fgG = 72; $fgB = 22
$denom = 255.0 - $fgB   # 233

$src = New-Object System.Drawing.Bitmap -ArgumentList $origem
$w = $src.Width; $h = $src.Height
$bmp = New-Object System.Drawing.Bitmap -ArgumentList $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($src, 0, 0, $w, $h)
$g.Dispose()

$rect = New-Object System.Drawing.Rectangle -ArgumentList 0, 0, $w, $h
$data = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$bytes = New-Object byte[] ($data.Stride * $h)
[System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)

for ($y = 0; $y -lt $h; $y++) {
  $rowStart = $y * $data.Stride
  for ($x = 0; $x -lt $w; $x++) {
    $i = $rowStart + $x * 4   # BGRA
    $b = $bytes[$i]
    $alpha = (255.0 - $b) / $denom * 255.0
    if ($alpha -lt 0) { $alpha = 0 } elseif ($alpha -gt 255) { $alpha = 255 }
    $bytes[$i]     = $fgB
    $bytes[$i + 1] = $fgG
    $bytes[$i + 2] = $fgR
    $bytes[$i + 3] = [byte][Math]::Round($alpha)
  }
}

[System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
$bmp.UnlockBits($data)
$bmp.Save($destino, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose(); $src.Dispose()
Write-Output "OK: $destino"
