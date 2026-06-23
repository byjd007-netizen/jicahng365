$index_path = ".\index.html"
$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)

$old_banner = @"
  <section class="container" style="text-align: center; padding: 60px 20px; background: var(--bg-secondary); border-radius: var(--radius-lg); margin-bottom: 60px;">
    <h2 class="section-title">探索云轨知识库</h2>
    <p style="margin-bottom: 30px; color: var(--text-secondary); max-width: 600px; margin-left: auto; margin-right: auto;">全面涵盖从基础原理到高阶玩法的网络指南，海量优质教程助您打造无死角的网络体验。</p>
    <a href="knowledge.html" class="action-btn primary" style="font-size: 1.1rem; padding: 12px 30px;">前往知识库专区 &rarr;</a>
  </section>
"@

$new_banner = @"
  <section class="container" style="position: relative; text-align: center; padding: 80px 20px; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); border-radius: var(--radius-lg); margin-bottom: 60px; overflow: hidden; border: 1px solid #bae6fd; box-shadow: 0 10px 30px rgba(14, 165, 233, 0.1);">
    
    <!-- Breathing Lights (Decorations) -->
    <style>
      @keyframes breathe {
        0% { transform: scale(0.8); opacity: 0.3; }
        50% { transform: scale(1.2); opacity: 0.6; }
        100% { transform: scale(0.8); opacity: 0.3; }
      }
      .glow-orb {
        position: absolute;
        border-radius: 50%;
        filter: blur(60px);
        animation: breathe 8s infinite ease-in-out;
        z-index: 0;
        pointer-events: none;
      }
      .orb-1 {
        width: 300px; height: 300px;
        background: rgba(56, 189, 248, 0.5);
        top: -100px; left: -50px;
        animation-delay: 0s;
      }
      .orb-2 {
        width: 250px; height: 250px;
        background: rgba(14, 165, 233, 0.4);
        bottom: -80px; right: -50px;
        animation-delay: -4s;
      }
      .orb-3 {
        width: 150px; height: 150px;
        background: rgba(2, 132, 199, 0.3);
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        animation: breathe 10s infinite ease-in-out;
        animation-delay: -2s;
      }
      .kb-banner-content {
        position: relative;
        z-index: 1;
      }
      .kb-banner-title {
        font-size: 2rem;
        font-weight: 700;
        color: #0c4a6e;
        margin-bottom: 20px;
        letter-spacing: 1px;
        text-shadow: 0 2px 10px rgba(255,255,255,0.8);
      }
      .kb-banner-desc {
        margin-bottom: 40px; 
        color: #0284c7; 
        max-width: 600px; 
        margin-left: auto; 
        margin-right: auto; 
        font-size: 1.15rem; 
        line-height: 1.7;
        font-weight: 500;
      }
      .kb-banner-btn {
        display: inline-block;
        font-size: 1.15rem; 
        padding: 14px 38px; 
        background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%); 
        color: white;
        text-decoration: none;
        border-radius: 50px;
        font-weight: 600;
        box-shadow: 0 8px 20px rgba(2, 132, 199, 0.3);
        transition: all 0.3s ease;
      }
      .kb-banner-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 25px rgba(2, 132, 199, 0.4);
        color: white;
      }
    </style>
    
    <div class="glow-orb orb-1"></div>
    <div class="glow-orb orb-2"></div>
    <div class="glow-orb orb-3"></div>

    <div class="kb-banner-content">
      <h2 class="kb-banner-title">探索云轨科普指南</h2>
      <p class="kb-banner-desc">全面涵盖从基础原理到高阶玩法的网络指南，海量优质教程助您打造无死角的网络体验。</p>
      <a href="knowledge.html" class="kb-banner-btn">前往科普指南专区 &rarr;</a>
    </div>
  </section>
"@

$content = $content.Replace($old_banner, $new_banner)

[System.IO.File]::WriteAllText($index_path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Updated banner successfully."
