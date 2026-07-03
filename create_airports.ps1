$airports_path = ".\airports.html"

$html = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>全部机场评测 - 云轨导航</title>
  <link rel="stylesheet" href="index.css?v=3">
  <style>
    body {
      background-color: #f1f5f9;
      margin: 0;
      padding: 40px 20px;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: flex-start;
    }
    .modal-container {
      background: #ffffff;
      width: 100%;
      max-width: 900px;
      border-radius: 12px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.05);
      padding: 50px 40px;
      position: relative;
      margin-top: 40px;
    }
    .close-btn {
      position: absolute;
      top: 20px;
      right: 20px;
      width: 36px;
      height: 36px;
      background: #334155;
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      text-decoration: none;
      font-size: 1.2rem;
      transition: background 0.2s;
    }
    .close-btn:hover {
      background: #0f172a;
    }
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
</head>
<body>
  <div class="modal-container">
    <a href="index.html" class="close-btn">&times;</a>
    
    <div style="margin-bottom: 40px;">
      <h1 style="font-size: 1.4rem; color: #64748b; font-weight: normal;">共计 <span id="totalCount" style="color: var(--text-primary); font-weight: bold;">8</span> 篇文章</h1>
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
            <span class="article-title">可信云机场深度评测：高性价比 IEPL 专线机场的晚高峰实测与自研客户端选购边界说明</span>
         </a>
         <a href="articles/kuaili.html" class="article-row">
           <span class="article-date">05-17</span>
           <span class="article-title">快鲤机场深度评测（2026版）：多地BGP企业专线，流媒体无障碍</span>
         </a>
         <a href="articles/shunyun.html" class="article-row">
           <span class="article-date">05-05</span>
           <span class="article-title">瞬云机场深度评测：主打高频节点轮换，极致抗墙的破冰尖兵</span>
         </a>
         <a href="articles/sujie.html" class="article-row">
           <span class="article-date">04-30</span>
           <span class="article-title">速界机场深度评测：高性价比企业级 IEPL 专线的晚高峰实测与选购边界说明</span>
         </a>

      </div>
    </div>

    <!-- Pagination controls -->
    <div class="pagination" id="pagination" style="display: flex; justify-content: center; gap: 8px; margin-top: 50px;">
    </div>
  </div>

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
</body>
</html>
"@

[System.IO.File]::WriteAllText($airports_path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Created airports.html"

# Modify index.html to add the button
$index_path = ".\index.html"
$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)

# Insert the button at the end of the recommend section
$btn_html = @"
    </div>
    <div style="text-align: center; margin-top: 35px;">
      <a href="airports.html" class="action-btn" style="background: white; color: var(--text-primary); border: 1px solid var(--border-color); padding: 12px 30px; font-size: 1.05rem; transition: all 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05);">查看全部评测 &rarr;</a>
    </div>
  </section>
"@

$content = $content -replace '</div>\s*</section>\s*<!-- Beginner Guide Section -->', $btn_html + "`n`n  <!-- Beginner Guide Section -->"

[System.IO.File]::WriteAllText($index_path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Updated index.html"

# Modify SEO reviews/index.html to point to /airports.html
$rev_path = ".\reviews\index.html"
if (Test-Path $rev_path) {
    $rev_content = [System.IO.File]::ReadAllText($rev_path, [System.Text.Encoding]::UTF8)
    $rev_content = $rev_content -replace '/knowledge\.html|/#kb', '/airports.html'
    [System.IO.File]::WriteAllText($rev_path, $rev_content, [System.Text.Encoding]::UTF8)
    Write-Host "Updated reviews/index.html"
}
