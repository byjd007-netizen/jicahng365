
# Comprehensive site cleanup script
# Removes blank lines in <head> sections and checks for broken internal links

$rootDir = "c:\Users\Administrator\Desktop\博客"
$articlesDir = Join-Path $rootDir "articles"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# ===== Step 1: Clean blank lines in <head> sections of article files =====
Write-Host "=== Step 1: Cleaning excessive blank lines in <head> sections ===" -ForegroundColor Cyan

$allHtml = Get-ChildItem (Join-Path $articlesDir "*.html")

foreach ($f in $allHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Remove sequences of 3+ consecutive blank/whitespace-only lines (compress to max 1 blank line)
    $cleaned = [System.Text.RegularExpressions.Regex]::Replace($content, "(\r?\n\s*){3,}", "`r`n`r`n")
    
    if ($cleaned.Length -ne $content.Length) {
        [System.IO.File]::WriteAllText($f.FullName, $cleaned, $utf8NoBom)
        Write-Host "  Compacted blank lines: $($f.Name)"
    }
}

# ===== Step 2: Check for broken internal links (404-causing) in root pages =====
Write-Host ""
Write-Host "=== Step 2: Checking for internally-linked pages that do not exist ===" -ForegroundColor Cyan

# Collect all actual files
$existingFiles = @{}
Get-ChildItem $rootDir -Filter "*.html" | ForEach-Object { $existingFiles[$_.Name] = $true }
Get-ChildItem $articlesDir -Filter "*.html" | ForEach-Object { $existingFiles["articles/" + $_.Name] = $true }

# Check article files for broken links (hrefs pointing to non-existent files)
$linkPattern = 'href="([^"#?]+\.html[^"]*)"'

foreach ($f in $allHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $matches = [System.Text.RegularExpressions.Regex]::Matches($content, $linkPattern)
    
    foreach ($m in $matches) {
        $href = $m.Groups[1].Value
        # Normalize: remove query strings and anchors
        $href = $href -replace '\?.*$', '' -replace '#.*$', ''
        
        # Only check relative internal links
        if ($href -notmatch '^https?://' -and $href -ne '') {
            # Resolve relative to articles dir
            if ($href -match '^\.\./') {
                $resolved = $href -replace '^\.\.\/', ''
                $exists = $existingFiles.ContainsKey($resolved)
            } else {
                $resolved = "articles/" + $href
                $exists = $existingFiles.ContainsKey($resolved)
            }
            
            if (-not $exists) {
                Write-Host "  BROKEN LINK in $($f.Name): $href (resolved: $resolved)"
            }
        }
    }
}

Write-Host ""
Write-Host "=== Step 3: Check root HTML files for injected blocks ===" -ForegroundColor Cyan
$rootHtml = Get-ChildItem $rootDir -Filter "*.html" -File
foreach ($f in $rootHtml) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match "INJECTED_SEO_START") {
        Write-Host "  HAS INJECTED BLOCK: $($f.Name)"
        $cleaned = [System.Text.RegularExpressions.Regex]::Replace($content, "(?s)\s*<!--\s*INJECTED_SEO_START\s*-->.*?<!--\s*INJECTED_SEO_END\s*-->", "")
        [System.IO.File]::WriteAllText($f.FullName, $cleaned, $utf8NoBom)
        Write-Host "    -> Cleaned."
    }
}

Write-Host ""
Write-Host "=== All checks complete ===" -ForegroundColor Green
