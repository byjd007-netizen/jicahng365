$index_path = ".\index.html"
$kb_path = ".\knowledge.html"

$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)

# Extract header
$header = [regex]::Match($content, '(?s)(<!DOCTYPE html>.*?</header>)').Groups[1].Value

# Extract kb
$kb = [regex]::Match($content, '(?s)(<main class="container" id="kb">.*?</main>)').Groups[1].Value

# Extract footer
$footer = [regex]::Match($content, '(?s)(<!-- SEO Links Section -->.*</html>)').Groups[1].Value

# Assemble knowledge.html
$kb_html = $header + "`n<div style=`"margin-top: 100px;`"></div>`n" + $kb + "`n" + $footer

# Update the active class in nav for knowledge.html
$kb_html = $kb_html -replace '<a href="index.html" class="nav-link active">首页探索</a>', '<a href="index.html" class="nav-link">首页探索</a>'
$kb_html = $kb_html -replace '<a href="#kb" class="nav-link">使用教程</a>', '<a href="knowledge.html" class="nav-link active">知识库</a>'
$kb_html = $kb_html -replace '<title>云轨导航 - 专业的全球网络与协议指南</title>', '<title>知识库 - 云轨导航</title>'

# Write knowledge.html
[System.IO.File]::WriteAllText($kb_path, $kb_html, [System.Text.Encoding]::UTF8)
Write-Host "Created knowledge.html"

# Modify index.html
# Replace <main id="kb"> with a banner
$banner = @"
  <section class="container" style="text-align: center; padding: 60px 20px; background: var(--bg-secondary); border-radius: var(--radius-lg); margin-bottom: 60px;">
    <h2 class="section-title">探索云轨知识库</h2>
    <p style="margin-bottom: 30px; color: var(--text-secondary); max-width: 600px; margin-left: auto; margin-right: auto;">全面涵盖从基础原理到高阶玩法的网络指南，海量优质教程助您打造无死角的网络体验。</p>
    <a href="knowledge.html" class="action-btn primary" style="font-size: 1.1rem; padding: 12px 30px;">前往知识库专区 &rarr;</a>
  </section>
"@

$new_content = $content -replace '(?s)<main class="container" id="kb">.*?</main>', $banner

# Update nav menu in index.html
$new_content = $new_content -replace '<a href="#kb" class="nav-link">使用教程</a>', '<a href="knowledge.html" class="nav-link">知识库</a>'
[System.IO.File]::WriteAllText($index_path, $new_content, [System.Text.Encoding]::UTF8)
Write-Host "Updated index.html"

# Update reviews/index.html
$rev_path = ".\reviews\index.html"
if (Test-Path $rev_path) {
    $rev_content = [System.IO.File]::ReadAllText($rev_path, [System.Text.Encoding]::UTF8)
    $rev_content = $rev_content -replace '/#kb', '/knowledge.html'
    [System.IO.File]::WriteAllText($rev_path, $rev_content, [System.Text.Encoding]::UTF8)
    Write-Host "Updated reviews/index.html"
}
