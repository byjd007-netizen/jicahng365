
# site_audit_v2.ps1 - use relative paths only
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Write-Host "=== Cleaning blank lines in article head sections ===" -ForegroundColor Cyan

$allHtml = Get-ChildItem "articles" -Filter "*.html"
$compacted = 0

foreach ($f in $allHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    # Compress 3+ consecutive blank lines to 1
    $cleaned = [System.Text.RegularExpressions.Regex]::Replace($content, "(\r?\n[ \t]*){3,}", "`r`n`r`n")
    if ($cleaned.Length -ne $content.Length) {
        [System.IO.File]::WriteAllText($f.FullName, $cleaned, $utf8NoBom)
        $compacted++
        Write-Host "  Compacted: $($f.Name)"
    }
}
Write-Host "  Total compacted: $compacted files"

Write-Host ""
Write-Host "=== Checking for broken internal links in articles ===" -ForegroundColor Cyan

$existingArticles = @{}
$allHtml | ForEach-Object { $existingArticles[$_.Name] = $true }
$rootFiles = @{}
Get-ChildItem "*.html" -File | ForEach-Object { $rootFiles[$_.Name] = $true }

$linkRx = [System.Text.RegularExpressions.Regex]::new('href="([^"#?]+\.html)"')

foreach ($f in $allHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $matches2 = $linkRx.Matches($content)
    foreach ($m in $matches2) {
        $href = $m.Groups[1].Value
        if ($href -match '^https?://') { continue }
        if ($href -match '^\.\./') {
            $rel = $href -replace '^\.\.\/', ''
            if (-not $rootFiles.ContainsKey($rel)) {
                Write-Host "  BROKEN: $($f.Name) -> $href"
            }
        } else {
            if (-not $existingArticles.ContainsKey($href)) {
                Write-Host "  BROKEN: $($f.Name) -> $href"
            }
        }
    }
}

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Green
