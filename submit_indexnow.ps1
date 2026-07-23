# submit_indexnow.ps1 - Submit website URLs from sitemap to IndexNow and Bing APIs
$baseDir = Get-Location
$sitemapPath = Join-Path $baseDir "sitemap.xml"
$key = "2d54406bc91741549e3e7f4bd802613d"
$hostName = "yunguidaohang.com"
$keyLocation = "https://yunguidaohang.com/$key.txt"

if (-not (Test-Path $sitemapPath)) {
    Write-Error "sitemap.xml not found at $sitemapPath"
    exit 1
}

[xml]$sitemapXml = Get-Content $sitemapPath -Encoding UTF8
$urls = $sitemapXml.urlset.url.loc

Write-Host "Found $($urls.Count) URLs in sitemap.xml to submit to IndexNow." -ForegroundColor Cyan

$payload = @{
    host = $hostName
    key = $key
    keyLocation = $keyLocation
    urlList = $urls
} | ConvertTo-Json -Depth 5

$endpoints = @(
    "https://api.indexnow.org/indexnow",
    "https://www.bing.com/indexnow"
)

foreach ($endpoint in $endpoints) {
    Write-Host "Submitting to $endpoint ..." -NoNewline
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method Post -Body $payload -ContentType "application/json; charset=utf-8" -UserAgent "IndexNowSubmitter/1.0"
        Write-Host " [SUCCESS 200 OK]" -ForegroundColor Green
    } catch {
        Write-Host " [Result: $($_.Exception.Message)]" -ForegroundColor Yellow
    }
}

Write-Host "IndexNow submission process finished." -ForegroundColor Green
