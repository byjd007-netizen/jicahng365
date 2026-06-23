$seo_footer = @"
  <!-- SEO Links Section -->
  <section class="container" style="padding: 40px 20px; border-top: 1px solid var(--border-color); margin-top: 60px; margin-bottom: 20px;">
    <h3 style="font-size: 1.1rem; color: var(--text-secondary); margin-bottom: 15px;">🔗 快速导航与热门主题</h3>
    <div style="display: flex; flex-wrap: wrap; gap: 15px; line-height: 1.5;">
      <a href="/airport-recommend/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">优质机场推荐</a>
      <a href="/airport-rank/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">全球机场排行</a>
      <a href="/reviews/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">深度测速评测</a>
      <a href="/tutorials/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">新手配置教程</a>
      <a href="/clash-tutorial/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">Clash 导入教程</a>
      <a href="/shadowrocket-tutorial/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">Shadowrocket 指南</a>
      <a href="/client-download/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">客户端安全下载</a>
      <a href="/avoid-scam/" style="color: var(--text-secondary); font-size: 0.9rem; text-decoration: none; padding: 5px 12px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0; transition: all 0.2s;">机场避坑防骗指南</a>
    </div>
  </section>
"@

$recommend_html = @"
      <!-- Recommended Links -->
      <div class="related-recommendations" style="margin-top: 50px; padding: 30px; background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: var(--radius-lg); box-shadow: 0 4px 15px rgba(0,0,0,0.02);">
        <h3 style="margin-top: 0; font-size: 1.4rem; border-bottom: 2px solid var(--accent-primary); padding-bottom: 10px; display: inline-block; color: var(--text-primary);">🔥 相关推荐</h3>
        <ul style="margin-top: 20px; list-style-type: none; padding-left: 0; display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
          <li>✈️ <a href="/airport-recommend/" style="color: var(--accent-secondary); font-weight: 500; transition: color 0.2s;">相关机场评测 / 同类机场推荐</a></li>
          <li>👶 <a href="/tutorials/" style="color: var(--accent-secondary); font-weight: 500; transition: color 0.2s;">新手教程</a></li>
          <li>📥 <a href="/client-download/" style="color: var(--accent-secondary); font-weight: 500; transition: color 0.2s;">客户端下载</a></li>
          <li>⚠️ <a href="/avoid-scam/" style="color: var(--accent-secondary); font-weight: 500; transition: color 0.2s;">机场避坑指南</a></li>
        </ul>
      </div>
    </article>
  </main>
"@

$index_path = ".\index.html"
$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)
$content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?s)<!-- SEO Links Section -->.*?</section>', $seo_footer)
[System.IO.File]::WriteAllText($index_path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Fixed index.html"

$reviews = @("jilianyun.html", "edgenova.html", "guangnianti.html", "huanyuyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html")
foreach ($rev in $reviews) {
    $path = ".\articles\$rev"
    if (Test-Path $path) {
        $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
        $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?s)<!-- Recommended Links -->.*?<footer class="footer">', $recommend_html + "`n  <footer class=`"footer`">")
        [System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Fixed $rev"
    }
}
