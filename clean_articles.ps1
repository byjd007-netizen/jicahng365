
# Clean all article files - remove INJECTED_SEO blocks
# Run from the blog root: powershell -ExecutionPolicy Bypass -File clean_articles.ps1

$files = Get-ChildItem "articles\*.html" | Where-Object { $_.Name -match "article-|beginner-|tutorial-|nav-" }

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$cleaned = 0

foreach ($f in $files) {
    $raw = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Remove the injected SEO block
    $before = $raw.Length
    
    # Pattern: everything from INJECTED_SEO_START to INJECTED_SEO_END (inclusive)
    $pattern = "(?s)\s*<!--\s*INJECTED_SEO_START\s*-->.*?<!--\s*INJECTED_SEO_END\s*-->"
    $cleaned_content = [System.Text.RegularExpressions.Regex]::Replace($raw, $pattern, "")
    
    if ($cleaned_content.Length -lt $before) {
        [System.IO.File]::WriteAllText($f.FullName, $cleaned_content, $utf8NoBom)
        Write-Host "Cleaned: $($f.Name) (removed $($before - $cleaned_content.Length) bytes)"
        $cleaned++
    } else {
        Write-Host "No change: $($f.Name)"
    }
}

Write-Host ""
Write-Host "Done: $cleaned files cleaned."
