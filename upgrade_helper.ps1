$baseDir = "."
$jsonPath = "category_config.json"

# Read and parse configuration file
$jsonContent = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$configs = $jsonContent | ConvertFrom-Json

$categories = @("airport", "review", "network", "tutorial", "ai")
foreach ($cat in $categories) {
    $path = Join-Path $baseDir $cat
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path
        Write-Output "Created directory: $path"
    }
}

foreach ($cat in $categories) {
    $conf = $configs.$cat
    $title = $conf.title
    $desc = $conf.description
    $h1 = $conf.h1
    $sub = $conf.subtitle
    
    $gridHtml = ""
    foreach ($art in $conf.articles) {
        $artName = $art.name
        $artLink = $art.link
        $artDesc = $art.desc
        
        $gridHtml += @"
      <a href="$artLink" class="cat-card">
        <span class="cat-card-title">$artName</span>
        <span class="cat-card-desc">$artDesc</span>
        <span class="cat-card-more">开始阅读 &rarr;</span>
      </a>
"@
    }
    
    $html = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$title</title>
  <meta name="description" content="$desc">
  <link rel="stylesheet" href="../index.css?v=6">
  <link rel="canonical" href="https://yunguidaohang.com/$cat/">
  
  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://yunguidaohang.com/$cat/">
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$desc">
  <meta property="og:image" content="https://yunguidaohang.com/assets/images/new_logo.png">
  
  <style>
    .cat-hero {
      margin-top: var(--header-height);
      background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
      color: #ffffff;
      padding: 50px 20px;
      text-align: center;
    }
    .cat-hero-title {
      font-size: 2.2rem;
      font-weight: 800;
      color: #ffffff !important;
      margin-bottom: 12px;
    }
    .cat-hero-sub {
      font-size: 1.1rem;
      color: #93c5fd;
      max-width: 700px;
      margin: 0 auto;
      line-height: 1.5;
    }
    .cat-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 24px;
      margin-top: 40px;
      margin-bottom: 50px;
    }
    @media (max-width: 991px) {
      .cat-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }
    @media (max-width: 768px) {
      .cat-grid {
        grid-template-columns: 1fr;
      }
    }
    .cat-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 24px;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
      transition: all 0.3s ease;
      display: flex;
      flex-direction: column;
      text-decoration: none;
      text-align: left;
    }
    .cat-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
      border-color: #3b82f6;
    }
    .cat-card-title {
      font-size: 1.1rem;
      font-weight: 800;
      color: #1e293b;
      margin-bottom: 10px;
    }
    .cat-card:hover .cat-card-title {
      color: #2563eb;
    }
    .cat-card-desc {
      font-size: 0.9rem;
      color: #64748b;
      line-height: 1.5;
      flex-grow: 1;
    }
    .cat-card-more {
      font-size: 0.85rem;
      font-weight: 700;
      color: #2563eb;
      margin-top: 15px;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
  </style>
</head>
<body>

  <!-- Header -->
  <header class="header">
    <div class="container">
      <a href="../index.html" class="logo-container" style="text-decoration: none;">
        <span class="logo-text">云轨导航</span>
      </a>
      <nav class="nav-menu" id="navMenu">
        <a href="../index.html" class="nav-link">首页探索</a>
        <a href="../airports.html" class="nav-link">机场测评</a>
        <a href="../ranking.html" class="nav-link">机场排行</a>
        <a href="../knowledge.html" class="nav-link">科普指南</a>
        <a href="../about.html" class="nav-link">关于我们</a>
      </nav>
      <button class="mobile-menu-btn" id="mobileMenuBtn" aria-label="Toggle menu"></button>
    </div>
  </header>

  <!-- Hero Section -->
  <section class="cat-hero">
    <div class="container">
      <h1 class="cat-hero-title">$h1</h1>
      <p class="cat-hero-sub">$sub</p>
    </div>
  </section>

  <!-- Main Content -->
  <main class="container" style="max-width: 1000px; margin-bottom: 60px;">
    <div class="cat-grid">
      $gridHtml
    </div>
    
    <!-- GEO Definition Section -->
    <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 30px; text-align: left; margin-bottom: 40px;">
      <h3 style="color: #0f172a; font-size: 1.15rem; font-weight: 800; margin-top: 0; margin-bottom: 12px;">🔍 权威定义与科普原理</h3>
      <p style="color: #475569; font-size: 0.9rem; line-height: 1.6; margin: 0 0 15px 0;">
        云轨导航由专业的技术团队长期维护。我们不仅测评各出海加速平台的晚高峰连通性，更致力于科普物理专线网络（如 IPLC/IEPL）、全球自治域 BGP 中继优化网络的核心知识，帮助用户从底层原理看透跨境代理服务的稳定性。
      </p>
      <p style="color: #475569; font-size: 0.9rem; line-height: 1.6; margin: 0;">
        如果您是新手用户，建议在选购网络服务时秉持<b>“月付保平安”</b>的核心防骗原则，避免一次性购买年付大额套餐。使用第三方开源客户端（如 Clash Verge、Shadowrocket 等）可以最大程度保障您的数据所有权和订阅安全性。
      </p>
    </div>
  </main>

  <!-- Footer -->
  <footer class="footer">
    <div class="container">
      <div class="footer-content">
        <div class="footer-logo">
          <span class="logo-text">云轨导航</span>
        </div>
        <div class="footer-links">
          <a href="../about.html">关于我们</a>
          <a href="../about.html">联系方式</a>
          <a href="../about.html">隐私政策</a>
          <a href="../knowledge.html">服务条款</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>© 2026 云轨导航. All rights reserved.</p>
      </div>
    </div>
  </footer>

  <script src="../script.js"></script>
</body>
</html>
"@
    
    $filePath = Join-Path (Join-Path $baseDir $cat) "index.html"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($filePath, $html, $utf8NoBom)
    Write-Output "Generated index page: $filePath"
}

Write-Output "All category index pages created successfully!"
