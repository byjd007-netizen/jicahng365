# Update root HTML files
$root_files = @("index.html", "knowledge.html", "ranking.html", "airports.html")

foreach ($file in $root_files) {
    if (Test-Path ".\$file") {
        $content = [System.IO.File]::ReadAllText(".\$file", [System.Text.Encoding]::UTF8)
        
        # Replace in navigation
        $content = $content -replace '>使用教程</a>', '>科普指南</a>'
        $content = $content -replace '>知识库</a>', '>科普指南</a>'
        
        # Replace title if it exists
        $content = $content -replace '<title>知识库 - 云轨导航</title>', '<title>科普指南 - 云轨导航</title>'
        
        [System.IO.File]::WriteAllText(".\$file", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated nav in $file"
    }
}

# Update articles HTML files
$articles = Get-ChildItem -Path ".\articles" -Filter "*.html"

foreach ($article in $articles) {
    $path = $article.FullName
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    
    # Replace in navigation
    $content = $content -replace '>知识库首页</a>', '>科普指南首页</a>'
    
    [System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Updated nav in articles\$($article.Name)"
}
