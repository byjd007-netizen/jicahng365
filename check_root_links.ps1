
# Check root-level HTML pages for broken internal links
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$linkRx = [System.Text.RegularExpressions.Regex]::new('href="([^"#?]+\.html)"')
$rootHtml = Get-ChildItem "*.html" -File

Write-Host "=== Checking root HTML pages for broken links ===" -ForegroundColor Cyan
foreach ($f in $rootHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $ms = $linkRx.Matches($content)
    foreach ($m in $ms) {
        $href = $m.Groups[1].Value
        if ($href -match '^https?://') { continue }
        if (-not (Test-Path $href)) {
            Write-Host "  BROKEN: $($f.Name) -> $href"
        }
    }
}

Write-Host ""
Write-Host "=== Checking for pages with broken HTML (unclosed style quotes) ===" -ForegroundColor Cyan
$brokenQuoteRx = [System.Text.RegularExpressions.Regex]::new('style="[^"]*;>')
$allFiles = Get-ChildItem "articles" -Filter "*.html"
foreach ($f in $allFiles) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($brokenQuoteRx.IsMatch($content)) {
        Write-Host "  BROKEN HTML (unclosed style quote): $($f.Name)"
        # Count occurrences
        $cnt = $brokenQuoteRx.Matches($content).Count
        Write-Host "    $cnt instance(s)"
    }
}

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Green
