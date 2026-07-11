
# Fix all issues found by audit
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Write-Host "=== Fix 1: Replace broken contact/privacy/terms links in root pages ===" -ForegroundColor Cyan

$rootPagesToFix = @("index.html", "404.html", "ranking.html", "airports.html", "knowledge.html", "about.html")
foreach ($page in $rootPagesToFix) {
    if (-not (Test-Path $page)) { continue }
    $content = [System.IO.File]::ReadAllText($page, [System.Text.Encoding]::UTF8)
    $original = $content
    $content = $content.Replace('"contact.html"', '"about.html"')
    $content = $content.Replace('"privacy.html"', '"about.html"')
    $content = $content.Replace('"terms.html"', '"knowledge.html"')
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($page, $content, $utf8NoBom)
        Write-Host "  Fixed: $page"
    }
}

Write-Host ""
Write-Host "=== Fix 2: Fix unclosed style quotes in airport review pages ===" -ForegroundColor Cyan

$airportPages = @(
    "articles\edgenova.html",
    "articles\guangnianti.html",
    "articles\huanyuyun.html",
    "articles\jilianyun.html",
    "articles\kexinyun.html",
    "articles\kuaili.html",
    "articles\shunyun.html",
    "articles\sujie.html"
)

$brokenRx = [System.Text.RegularExpressions.Regex]::new('(style="[^"]*?;)>')
foreach ($page in $airportPages) {
    if (-not (Test-Path $page)) { continue }
    $content = [System.IO.File]::ReadAllText($page, [System.Text.Encoding]::UTF8)
    $original = $content
    # Fix: style="...;" followed immediately by > (missing closing quote)
    # Replace style="...;> with style="...;">
    $content = $brokenRx.Replace($content, '$1">')
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($page, $content, $utf8NoBom)
        $cnt = $brokenRx.Matches($original).Count
        Write-Host "  Fixed $cnt unclosed quotes: $page"
    }
}

Write-Host ""
Write-Host "=== Fix 3: Delete orphan/template files that have broken links ===" -ForegroundColor Cyan

# right.html and template.html are orphan/template files not linked from nav, safe to delete
$orphanFiles = @("right.html", "template.html")
foreach ($f in $orphanFiles) {
    if (Test-Path $f) {
        Remove-Item $f -Force
        Write-Host "  Deleted orphan: $f"
    }
}

Write-Host ""
Write-Host "=== Fix 4: Also fix broken links in article sidebars ===" -ForegroundColor Cyan
# Fix contact/privacy/terms in article files too
$allArticles = Get-ChildItem "articles" -Filter "*.html"
foreach ($f in $allArticles) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    $content = $content.Replace('"../contact.html"', '"../about.html"')
    $content = $content.Replace('"contact.html"', '"../about.html"')
    $content = $content.Replace('"../privacy.html"', '"../about.html"')
    $content = $content.Replace('"../terms.html"', '"../knowledge.html"')
    if ($content -ne $original) {
        [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
        Write-Host "  Fixed article links: $($f.Name)"
    }
}

Write-Host ""
Write-Host "=== All fixes applied ===" -ForegroundColor Green
