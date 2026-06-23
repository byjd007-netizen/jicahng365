$index_path = ".\index.html"
$kb_path = ".\knowledge.html"

$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)

# Extract header
$header = [regex]::Match($content, '(?s)(<!DOCTYPE html>.*?</header>)').Groups[1].Value
$header = $header -replace '<a href="index.html" class="nav-link active">首页探索</a>', '<a href="index.html" class="nav-link">首页探索</a>'
$header = $header -replace '<a href="knowledge.html" class="nav-link">知识库</a>', '<a href="knowledge.html" class="nav-link active">知识库</a>'
$header = $header -replace '<title>云轨导航 - 专业的全球网络与协议指南</title>', '<title>知识库 - 云轨导航</title>'

# Extract footer
$footer = [regex]::Match($content, '(?s)(<!-- SEO Links Section -->.*</html>)').Groups[1].Value

# Construct new main content
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
      <h1 style="font-size: 1.4rem; color: #64748b; font-weight: normal;">共计 <span id="totalCount" style="color: var(--text-primary); font-weight: bold;">16</span> 篇文章</h1>
    </div>
    
    <div style="margin-bottom: 20px;">
      <h2 style="font-size: 1.8rem; color: var(--text-primary); margin-bottom: 20px;">2026</h2>
      <div id="articleList" style="border-top: 1px solid var(--border-color);">
         
         <a href="articles/article-1.html" class="article-row">
           <span class="article-date">06-20</span>
           <span class="article-title">翻墙基础原理：深入浅出讲解 Shadowsocks、V2Ray 等协议工作原理</span>
         </a>
         <a href="articles/article-2.html" class="article-row">
           <span class="article-date">06-18</span>
           <span class="article-title">Clash 全平台指南：导入订阅及高级规则分流配置教程</span>
         </a>
         <a href="articles/article-3.html" class="article-row">
           <span class="article-date">06-15</span>
           <span class="article-title">选购防坑指南：揭秘行业内幕，评估 IPLC 专线与 BGP 直连节点</span>
         </a>
         <a href="articles/article-4.html" class="article-row">
           <span class="article-date">06-12</span>
           <span class="article-title">Apple 设备配置：全面对比 Shadowrocket 与 Quantumult X</span>
         </a>
         <a href="articles/article-5.html" class="article-row">
           <span class="article-date">06-10</span>
           <span class="article-title">流媒体解锁攻略：解析 Netflix/Disney+ 封锁机制及跨区方案</span>
         </a>
         <a href="articles/article-6.html" class="article-row">
           <span class="article-date">06-08</span>
           <span class="article-title">断流超时排查：本地 DNS 污染到运营商封锁的终极解决方法</span>
         </a>
         <a href="articles/article-7.html" class="article-row">
           <span class="article-date">06-05</span>
           <span class="article-title">新一代代理剖析：VLESS/XTLS 与 Hysteria 抗封锁新协议详解</span>
         </a>
         <a href="articles/article-8.html" class="article-row">
           <span class="article-date">06-02</span>
           <span class="article-title">跨境网络拓扑：剖析深港专线、沪日专线背后的物理链路原理</span>
         </a>
         <a href="articles/article-9.html" class="article-row">
           <span class="article-date">05-28</span>
           <span class="article-title">隐私泄漏防范：防范 WebRTC 真实 IP 泄漏与解决 DNS 劫持</span>
         </a>
         <a href="articles/article-10.html" class="article-row">
           <span class="article-date">05-25</span>
           <span class="article-title">路由器翻墙实战：OpenWrt 软路由配置 PassWall / OpenClash 教程</span>
         </a>
         <a href="articles/article-11.html" class="article-row">
           <span class="article-date">05-20</span>
           <span class="article-title">深度解析：代理工具高级进阶玩法与极端网络环境生存指南</span>
         </a>
         <a href="articles/article-12.html" class="article-row">
           <span class="article-date">05-18</span>
           <span class="article-title">网络安全全指南：防止隐私裸奔，从硬件到软件打造无懈可击防线</span>
         </a>
         <a href="articles/tutorial-win.html" class="article-row">
           <span class="article-date">05-15</span>
           <span class="article-title">Windows 新手教程：Clash Verge 导入订阅与基础使用指南</span>
         </a>
         <a href="articles/tutorial-ios.html" class="article-row">
           <span class="article-date">05-12</span>
           <span class="article-title">iOS 新手教程：Shadowrocket (小火箭) 节点添加与分流规则设置</span>
         </a>
         <a href="articles/tutorial-and.html" class="article-row">
           <span class="article-date">05-10</span>
           <span class="article-title">Android 新手教程：v2rayNG 全面配置教程与移动端稳定方案</span>
         </a>
         <a href="articles/tutorial-mac.html" class="article-row">
           <span class="article-date">05-08</span>
           <span class="article-title">Mac 新手教程：Stash / Clash Verge 使用教程与高效分流配置</span>
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
      // Hide all items
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
      
      // Prev button
      const prevBtn = document.createElement('button');
      prevBtn.className = 'page-btn';
      prevBtn.textContent = '上一页';
      prevBtn.disabled = currentPage === 1;
      prevBtn.onclick = () => renderPage(currentPage - 1);
      pagination.appendChild(prevBtn);

      // Page numbers
      for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('button');
        btn.className = i === currentPage ? 'page-btn active' : 'page-btn';
        btn.textContent = i;
        btn.onclick = () => renderPage(i);
        pagination.appendChild(btn);
      }

      // Next button
      const nextBtn = document.createElement('button');
      nextBtn.className = 'page-btn';
      nextBtn.textContent = '下一页';
      nextBtn.disabled = currentPage === totalPages;
      nextBtn.onclick = () => renderPage(currentPage + 1);
      pagination.appendChild(nextBtn);
    }

    // Initial render
    if (items.length > itemsPerPage) {
      renderPage(1);
    } else {
      pagination.style.display = 'none';
    }
  });
  </script>
"@

$kb_html = $header + "`n" + $main + "`n" + $footer
[System.IO.File]::WriteAllText($kb_path, $kb_html, [System.Text.Encoding]::UTF8)
Write-Host "Updated knowledge.html with paginated list UI"
