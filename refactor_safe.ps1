$articlesDir = Join-Path $PSScriptRoot "articles"
$template = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot "template.html"), [System.Text.Encoding]::UTF8)
$leftSidebar = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot "left.html"), [System.Text.Encoding]::UTF8)
$rightSidebar = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot "right.html"), [System.Text.Encoding]::UTF8)

# The intro text base64 encoded
$introBase64 = "5Zyo546w5Luj572R57uc546v5aKD5Lit77yM4oCc5Luj55CG4oCd5bey5oiQ5Li66L+e5o6l5YWo55CD5LqS6IGU572R55qE6YeN6KaB5oqA5pyv5omL5q6144CC5LqG6Kej5Luj55CG55qE5Y6f55CG5LiO5bi46KeB5Y2P6K6u77yM5piv5o+Q5Y2H572R57uc5L2T6aqM55qE5YWz6ZSu5LiA5q2l44CC"
$introText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($introBase64))

$files = Get-ChildItem -Path $articlesDir -Filter "*.html"
$count = 0

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    $title = "文章 - 云轨导航"
    if ($content -match '(?i)<title>(.*?)</title>') { $title = $matches[1] }
    
    $h1 = $title.Split('-')[0].Trim()
    if ($content -match '(?i)<h1[^>]*>(.*?)</h1>') { $h1 = $matches[1] }
    
    $shortTitle = $h1
    if ($shortTitle.Length -gt 15) { $shortTitle = $shortTitle.Substring(0, 15) + "..." }
    
    # Base64 encoded categories
    $catKpz = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("56eR5pmu5oyH5Y2X"))
    $catKhd = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("5a6i5oi356uv5pWZ56iL"))
    $catXs = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("5paw5omL5YWl6Zeo"))
    
    $category = $catKpz
    if ($f.Name -match "tutorial") { $category = $catKhd }
    elseif ($f.Name -match "beginner") { $category = $catXs }
    
    $bodyContent = ""
    if ($content -match '(?s)<div class="article-body">(.*?)</div>\s*</div>\s*</main>') {
        $bodyContent = $matches[1]
    } elseif ($content -match '(?s)<div class="article-body">(.*?)</div>\s*(?:<!--)?\s*</main>') {
        $bodyContent = $matches[1]
    } elseif ($content -match '(?s)<div class="article-body">(.*?)<div class="related-links">') {
        $bodyContent = $matches[1]
    } else {
        if ($content -match '(?si)(<h2.*?</main>)') {
            $bodyContent = $matches[1]
            $bodyContent = $bodyContent -replace '(?i)</main>', ''
        } else {
            $bodyContent = "<p>正文内容加载失败。</p>"
        }
    }
    
    $bodyContent = [System.Text.RegularExpressions.Regex]::Replace($bodyContent, '(?s)<div class="related-links">.*?</div>', '')
    $bodyContent = [System.Text.RegularExpressions.Regex]::Replace($bodyContent, '(?i)<img[^>]*>', '')
    
    $currentIntro = $introText
    if ($bodyContent -match '(?s)<div class="highlight-box">(.*?)</div>') {
        $currentIntro = $matches[1]
        $bodyContent = [System.Text.RegularExpressions.Regex]::Replace($bodyContent, '(?s)<div class="highlight-box">.*?</div>', '')
    }
    
    if ($rightSidebar -ne $null) {
        $rightContent = $rightSidebar.Replace('__CATEGORY__', $category)
    } else {
        $rightContent = ""
    }
    
    $newHtml = $template
    $newHtml = $newHtml.Replace('__TITLE__', $title)
    $newHtml = $newHtml.Replace('__H1_TITLE__', $h1)
    $newHtml = $newHtml.Replace('__SHORT_TITLE__', $shortTitle)
    $newHtml = $newHtml.Replace('__CATEGORY__', $category)
    $newHtml = $newHtml.Replace('__LEFT_SIDEBAR__', $leftSidebar)
    $newHtml = $newHtml.Replace('__RIGHT_SIDEBAR__', $rightContent)
    $newHtml = $newHtml.Replace('__INTRO_TEXT__', $currentIntro)
    $newHtml = $newHtml.Replace('__BODY_CONTENT__', $bodyContent)
                        
    [System.IO.File]::WriteAllText($f.FullName, $newHtml, [System.Text.Encoding]::UTF8)
    $count++
    Write-Host "Processed: $($f.Name)"
}

Write-Host "Total Refactored: $count"
