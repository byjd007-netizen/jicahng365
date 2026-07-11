$baseDir = "."
$baseUrl = "https://yunguidaohang.com"
$sitemapPath = Join-Path $baseDir "sitemap.xml"
$robotsPath = Join-Path $baseDir "robots.txt"

# 1. Update robots.txt to point to the new domain sitemap url
$robotsContent = @"
User-agent: *
Allow: /

Sitemap: $baseUrl/sitemap.xml
"@
[System.IO.File]::WriteAllText($robotsPath, $robotsContent, [System.Text.Encoding]::UTF8)
Write-Output "Successfully updated robots.txt!"

# 2. Rebuild sitemap.xml
$dateStr = (Get-Date).ToString("yyyy-MM-dd")

# We list all pages manually or scan them
$pages = @()

# Add root pages
$pages += @{ "loc" = "$baseUrl/"; "priority" = "1.0"; "freq" = "daily" }
$pages += @{ "loc" = "$baseUrl/about.html"; "priority" = "0.8"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/airports.html"; "priority" = "0.8"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/knowledge.html"; "priority" = "0.8"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/ranking.html"; "priority" = "0.8"; "freq" = "weekly" }

# Add category landing pages
$pages += @{ "loc" = "$baseUrl/airport/"; "priority" = "0.9"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/review/"; "priority" = "0.9"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/network/"; "priority" = "0.9"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/tutorial/"; "priority" = "0.9"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/ai/"; "priority" = "0.9"; "freq" = "weekly" }
$pages += @{ "loc" = "$baseUrl/avoid-scam/"; "priority" = "0.9"; "freq" = "weekly" }

# Scan articles directory
$articlesDir = Join-Path $baseDir "articles"
$files = Get-ChildItem -Path $articlesDir -Filter *.html
foreach ($file in $files) {
    $pages += @{ "loc" = "$baseUrl/articles/$($file.Name)"; "priority" = "0.8"; "freq" = "weekly" }
}

# Build sitemap XML
$xml = '<?xml version="1.0" encoding="UTF-8"?>' + "`n"
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + "`n"

foreach ($page in $pages) {
    $loc = $page.loc
    $prio = $page.priority
    $freq = $page.freq
    
    $xml += "    <url>`n"
    $xml += "        <loc>$loc</loc>`n"
    $xml += "        <lastmod>$dateStr</lastmod>`n"
    $xml += "        <changefreq>$freq</changefreq>`n"
    $xml += "        <priority>$prio</priority>`n"
    $xml += "    </url>`n"
}

$xml += '</urlset>'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($sitemapPath, $xml, $utf8NoBom)
Write-Output "Successfully compiled sitemap.xml!"
