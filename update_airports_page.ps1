$index_path = ".\index.html"
$k_path = ".\knowledge.html"

# Extract header from knowledge.html
$k_content = [System.IO.File]::ReadAllText($k_path, [System.Text.Encoding]::UTF8)
$header = [regex]::Match($k_content, '(?s)(<!DOCTYPE html>.*?</header>)').Groups[1].Value

# Modify header for airports.html
$header = $header -replace '<a href="knowledge.html" class="nav-link active">科普指南</a>', '<a href="knowledge.html" class="nav-link">科普指南</a>'
$header = $header -replace '<a href="airports.html" class="nav-link">机场测评</a>', '<a href="airports.html" class="nav-link active">机场测评</a>'
$header = $header -replace '<title>科普指南 - 云轨导航</title>', '<title>机场测评 - 云轨导航</title>'

# Extract footer
$footer = [regex]::Match($k_content, '(?s)(<!-- SEO Links Section -->.*</html>)').Groups[1].Value

$main = @"
  <style>
    .article-row {
      display: flex;
      padding: 18px 20px;
      border-bottom: 1px solid var(--border-color);
      text-decoration: none;
      transition: all 0.2s ease;
      align-items: center;
    }
    .article-row:hover {
      background-color: #f8fafc;
    }
    .article-row:hover .article-title {
      color: var(--accent-primary);
    }
    .article-date {
      color: #64748b;
      font-size: 1rem;
      width: 80px;
      flex-shrink: 0;
      font-family: monospace;
    }
    .article-title {
      color: var(--text-primary);
      font-size: 1.05rem;
      transition: color 0.2s ease;
    }
    .page-btn {
      padding: 8px 16px;
      border: 1px solid var(--border-color);
      background: white;
      color: var(--text-primary);
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 0.95rem;
    }
    .page-btn:hover:not(:disabled) {
      background: #f1f5f9;
    }
    .page-btn.active {
      background: var(--accent-primary);
      color: white;
      border-color: var(--accent-primary);
    }
    .page-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
  </style>

  <main class="container" style="max-width: 900px; margin: 60px auto; min-height: 60vh;">
    <div style="margin-bottom: 40px;">
      <h1 style="font-size: 1.4rem; color: #64748b; font-weight: normal;">共计 <span id="totalCount" style="color: var(--text-primary); font-weight: bold;">8</span> 篇评测</h1>
    </div>
    
    <div style="margin-bottom: 20px;">
      <h2 style="font-size: 1.8rem; color: var(--text-primary); margin-bottom: 20px;">2026</h2>
      <div id="articleList" style="border-top: 1px solid var(--border-color);">
         
         <a href="articles/jilianyun.html" class="article-row">
            <span class="article-date">05-24</span>
            <span class="article-title">极连云机场深度评测（2026最新）：全网性价比之王，稳定高速不跑路</span>
         </a>
         <a href="articles/edgenova.html" class="article-row">
            <span class="article-date">05-24</span>
            <span class="article-title">EdgeNova机场深度评测：全线顶级专线，晚高峰无缝秒开流媒体首选</span>
         </a>
         <a href="articles/guangnianti.html" class="article-row">
            <span class="article-date">05-22</span>
            <span class="article-title">光年梯深度评测：专为极客打造，支持最新 Hysteria2 及 VLESS 协议</span>
         </a>
         <a href="articles/huanyuyun.html" class="article-row">
            <span class="article-date">05-22</span>
            <span class="article-title">幻宇云机场深度评测：BGP三网优化+IEPL专线，Netflix/DAZN全解锁</span>
         </a>
         <a href="articles/kexinyun.html" class="article-row">
            <span class="article-date">05-21</span>
            <span class="article-title">可信云机场深度评测：不限速不限设备，老牌稳定专线深度测评</span>
         </a>
         <a href="articles/kuaili.html" class="article-row">
            <span class="article-date">05-17</span>
            <span class="article-title">快狸机场深度评测（2026版）：多地BGP企业专线，流媒体无障碍</span>
         </a>
         <a href="articles/shunyun.html" class="article-row">
            <span class="article-date">05-05</span>
            <span class="article-title">瞬云机场深度评测：主打高频节点轮换，极致抗墙的破冰尖兵</span>
         </a>
         <a href="articles/sujie.html" class="article-row">
            <span class="article-date">04-30</span>
            <span class="article-title">速捷机场深度评测：不限设备连接的2026年高性价比全IPLC专线</span>
         </a>

      </div>
    </div>

    <!-- Pagination controls -->
    <div class="pagination" id="pagination" style="display: flex; justify-content: center; gap: 8px; margin-top: 50px;">
    </div>
  </main>

  <script>
  document.addEventListener('DOMContentLoaded', function() {
    const itemsPerPage = 10;
    const listContainer = document.getElementById('articleList');
    const items = Array.from(listContainer.querySelectorAll('.article-row'));
    const pagination = document.getElementById('pagination');
    const totalPages = Math.ceil(items.length / itemsPerPage);
    let currentPage = 1;

    function renderPage(page) {
      currentPage = page;
      items.forEach((item, index) => {
        if (index >= (page - 1) * itemsPerPage && index < page * itemsPerPage) {
          item.style.display = 'flex';
        } else {
          item.style.display = 'none';
        }
      });
      renderPagination();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function renderPagination() {
      pagination.innerHTML = '';
      if (totalPages <= 1) return;
      
      const prevBtn = document.createElement('button');
      prevBtn.className = 'page-btn';
      prevBtn.textContent = '上一页';
      prevBtn.disabled = currentPage === 1;
      prevBtn.onclick = () => renderPage(currentPage - 1);
      pagination.appendChild(prevBtn);

      for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('button');
        btn.className = i === currentPage ? 'page-btn active' : 'page-btn';
        btn.textContent = i;
        btn.onclick = () => renderPage(i);
        pagination.appendChild(btn);
      }

      const nextBtn = document.createElement('button');
      nextBtn.className = 'page-btn';
      nextBtn.textContent = '下一页';
      nextBtn.disabled = currentPage === totalPages;
      nextBtn.onclick = () => renderPage(currentPage + 1);
      pagination.appendChild(nextBtn);
    }

    if (items.length > itemsPerPage) {
      renderPage(1);
    } else {
      pagination.style.display = 'none';
    }
  });
  </script>
"@

$final_html = $header + "`n" + $main + "`n" + $footer
[System.IO.File]::WriteAllText(".\airports.html", $final_html, [System.Text.Encoding]::UTF8)

# Update href="#recommend" to href="airports.html" globally in root html files
$files = @("index.html", "knowledge.html", "ranking.html")
foreach ($file in $files) {
    if (Test-Path ".\$file") {
        $content = [System.IO.File]::ReadAllText(".\$file", [System.Text.Encoding]::UTF8)
        $content = $content -replace '<a href="#recommend" class="nav-link">机场测评</a>', '<a href="airports.html" class="nav-link">机场测评</a>'
        [System.IO.File]::WriteAllText(".\$file", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated links in $file"
    }
}
