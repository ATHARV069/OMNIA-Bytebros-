$content = Get-Content "D:\Atharv\OMNIA\packages\web\src\pages\Dashboard.tsx" -Raw
$lines = $content.Split([Environment]::NewLine)
$line = $lines[248]
Write-Host "Line 249 length: $($line.Length)"
for ($i=0; $i -lt $line.Length; $i++) {
    Write-Host "Pos $i: [$($line[$i])]"
}