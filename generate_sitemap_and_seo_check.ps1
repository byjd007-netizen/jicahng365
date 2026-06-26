$basePath = "."
$baseUrl = "https://jichang365.com"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Create robots.txt
$robotsContent = "User-agent: *`r`nAllow: /`r`n`r`nSitemap: $baseUrl/sitemap.xml`r`n"
$robotsPath = Join-Path (Get-Location).Path "robots.txt"
[System.IO.File]::WriteAllText($robotsPath, $robotsContent, $utf8NoBom)
Write-Host "Created robots.txt without BOM"

# Find all HTML files
$htmlFiles = Get-ChildItem -Path $basePath -Filter "*.html" -Recurse

$sitemapUrls = @()
$seoIssues = @()
$currentPathLen = (Get-Location).Path.Length

foreach ($file in $htmlFiles) {
    # Skip template or components
    if ($file.Name -match "template" -or $file.Name -match "left.html" -or $file.Name -match "right.html") { continue }

    $relativePath = $file.FullName.Substring($currentPathLen + 1).Replace('\', '/')
    
    $isIndex = $relativePath -eq "index.html"
    $url = if ($isIndex) { "$baseUrl/" } else { "$baseUrl/$relativePath" }
    $priority = if ($isIndex) { "1.0" } else { "0.8" }
    $changefreq = if ($isIndex) { "daily" } else { "weekly" }
    
    # Use the actual last write time of the file
    $lastmod = $file.LastWriteTime.ToString("yyyy-MM-dd")
    
    $sitemapUrls += "    <url>`r`n        <loc>$url</loc>`r`n        <lastmod>$lastmod</lastmod>`r`n        <changefreq>$changefreq</changefreq>`r`n        <priority>$priority</priority>`r`n    </url>"

    # SEO Check
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $issues = @()
    if ($content -notmatch "<title>.*?</title>") {
        $issues += "Missing <title> tag"
    }
    if ($content -notmatch "<meta[^>]+name=['""]description['""][^>]*>" -and $content -notmatch "<meta[^>]+content=['""](.*?)['""][^>]*name=['""]description['""][^>]*>") {
        $issues += "Missing meta description"
    }
    if ($content -notmatch "<h1.*?>.*?</h1>") {
        $issues += "Missing <h1> tag"
    }

    if ($issues.Count -gt 0) {
        $seoIssues += [PSCustomObject]@{
            File = $relativePath
            Issues = $issues -join ", "
        }
    }
}

# Generate sitemap.xml
$sitemapContent = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`r`n<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`">`r`n"
$sitemapContent += ($sitemapUrls -join "`r`n")
$sitemapContent += "`r`n</urlset>`r`n"

$sitemapPath = Join-Path (Get-Location).Path "sitemap.xml"
[System.IO.File]::WriteAllText($sitemapPath, $sitemapContent, $utf8NoBom)
Write-Host "Created sitemap.xml without BOM with $($sitemapUrls.Count) URLs"

# Output SEO Issues
Write-Host "`n--- SEO Report ---"
if ($seoIssues.Count -eq 0) {
    Write-Host "All pages have title, meta description, and h1 tags!"
} else {
    foreach ($issue in $seoIssues) {
        Write-Host "$($issue.File): $($issue.Issues)"
    }
}
