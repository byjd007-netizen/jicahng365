
# Fix broken footer links in the 6 new tool articles
# Replace non-existent privacy.html/terms.html with about.html/knowledge.html

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$toolArticles = @(
    "articles\clash-verge.html",
    "articles\shadowrocket.html",
    "articles\v2rayn.html",
    "articles\hiddify-next.html",
    "articles\speedtest.html",
    "articles\wireshark.html"
)

foreach ($path in $toolArticles) {
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    
    # Replace broken footer links
    $content = $content.Replace('../privacy.html', '../about.html')
    $content = $content.Replace('../terms.html', '../knowledge.html')
    
    [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
    Write-Host "Fixed footer links: $path"
}

Write-Host "Done."
