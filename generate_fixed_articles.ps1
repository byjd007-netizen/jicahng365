$origPath = ".\articles\article-1.html"
$jsonPath = ".\articles_content.json"

# Load original template as UTF-8 string
$orig = [System.IO.File]::ReadAllText($origPath, [System.Text.Encoding]::UTF8)

# Load JSON articles data
$jsonRaw = Get-Content -Path $jsonPath -Raw -Encoding UTF8
$data = ConvertFrom-Json $jsonRaw

$labels = $data.labels

# Split header and footer by <main class="main-content">
$mainTag = '<main class="main-content">'
$parts = $orig -split [regex]::Escape($mainTag)
$header = $parts[0] + $mainTag

# Split the remaining part by </main>
$closeMainTag = '</main>'
$remainingParts = $parts[1] -split [regex]::Escape($closeMainTag)
$footer = $closeMainTag + $remainingParts[1]

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Build-And-Save-Article($filename, $articleData) {
    # Replace title in header
    $newHeader = $header -replace '<title>.*?</title>', ("<title>" + $articleData.title + " - " + $labels.wang_luo_ke_pu + "</title>")

    # Build main content
    $breadcrumbs = @"
        <div class="breadcrumbs" style="margin-bottom: 25px; font-size: 0.95rem; color: #64748b; padding-bottom: 15px; border-bottom: 1px dashed #e2e8f0;">
            <a href="../index.html" style="color: #0ea5e9; text-decoration: none; font-weight: 500;">$($labels.shou_ye)</a> &gt; 
            <a href="../knowledge.html" style="color: #0ea5e9; text-decoration: none; font-weight: 500;">$($labels.ke_pu_zhi_nan)</a> &gt; 
            <span class="current" style="color: #94a3b8;">$($articleData.title)</span>
        </div>
"@

    $articleBox = @"
        <article class="article-box">
            <header class="article-header" style="text-align: center; margin-bottom: 40px;">
                <h1 class="article-title" style="font-size: 2.4rem; color: #0f172a; margin: 0 0 20px 0; font-weight: 800; line-height: 1.3;">$($articleData.title)</h1>
                <div class="article-meta" style="display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 20px; color: #64748b; font-size: 0.95rem; margin-bottom: 25px;">
                    <span>$($labels.zuo_zhe): $($labels.ji_shu_bian_ji_bu)</span>
                    <span>$($labels.yue_du_shi_chang): $($labels.yue) $($articleData.read_time) $($labels.fen_zhong)</span>
                    <span>$($labels.fa_bu_yu): 2026-06-22</span>
                    <span>$($labels.geng_xin_yu): 2026-06-22</span>
                </div>
                <div class="article-tags" style="display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 12px; padding-bottom: 25px; border-bottom: 1px solid #e2e8f0;">
                    <span class="tag" style="background:#f1f5f9; color:#3b82f6; padding:6px 12px; border-radius:8px; font-size:0.85rem; font-weight:600;">$($labels.ke_pu_zhi_nan)</span>
                    <span class="tag" style="background:#f1f5f9; color:#3b82f6; padding:6px 12px; border-radius:8px; font-size:0.85rem; font-weight:600;">$($labels.ke_xue_shang_wang)</span>
                    <span class="tag" style="background:#f1f5f9; color:#3b82f6; padding:6px 12px; border-radius:8px; font-size:0.85rem; font-weight:600;">$($labels.wang_luo_ke_pu)</span>
                    <span class="views" style="margin-left: 15px; color:#94a3b8; font-size:0.9rem;">$($labels.yue_du_liang): 12.5k</span>
                </div>
            </header>
            
            <div class="article-intro">
                <strong style="display: block; margin-bottom: 10px;">$($articleData.intro)</strong>
            </div>
            
            <div class="article-body" id="articleBody">
                $($articleData.body)
            </div>
        </article>
"@

    $mainContent = "`r`n" + $breadcrumbs + "`r`n" + $articleBox + "`r`n"

    # Replace reading time in footer
    $patternReadTime = '(?s)<span class="info-label">' + $labels.yue_du_shi_chang + '</span>\s*<span class="info-val"[^>]*>.*?</span>'
    $replacementReadTime = '<span class="info-label">' + $labels.yue_du_shi_chang + '</span>' + "`r`n" + '            <span class="info-val" style="font-weight:600; color:#0f172a;">' + $labels.yue + ' ' + $articleData.read_time + ' ' + $labels.fen_zhong + '</span>'
    $newFooter = $footer -replace $patternReadTime, $replacementReadTime

    # Replace word count in footer
    $patternWordCount = '(?s)<span class="info-label">' + $labels.zi_shu_tong_ji + '</span>\s*<span class="info-val"[^>]*>.*?</span>'
    $replacementWordCount = '<span class="info-label">' + $labels.zi_shu_tong_ji + '</span>' + "`r`n" + '            <span class="info-val" style="font-weight:600; color:#0f172a;">' + $labels.yue + ' ' + $articleData.word_count + ' ' + $labels.zi + '</span>'
    $newFooter = $newFooter -replace $patternWordCount, $replacementWordCount

    $fullHtml = $newHeader + "`r`n" + $mainContent + "`r`n" + $newFooter

    $targetPath = Join-Path ".\articles" $filename
    [System.IO.File]::WriteAllText($targetPath, $fullHtml, $utf8NoBom)
    Write-Host "Generated $filename successfully in UTF-8 without BOM"
}

Build-And-Save-Article "article-11.html" $data.article_11
Build-And-Save-Article "article-12.html" $data.article_12
