$base = ".\articles\"

$long_text = ""
for ($i=0; $i -lt 15; $i++) {
    $long_text += "<p>在数字化生活日益普及的今天，网络不仅是我们获取信息的渠道，更是连接世界的桥梁。然而，面对复杂的网络环境，如何高效、安全、无阻碍地访问全球资源，成为了许多用户关注的焦点。本文将为您深入剖析相关背景与操作细节，确保您在使用过程中避免走弯路，获得最佳体验。</p>"
    $long_text += "<h2>🔍 核心原理解析与背景介绍</h2><p>要真正掌握这一领域的技能，首先必须理解其背后的工作原理。当我们通过本地客户端发出请求时，数据并非直接到达目标服务器，而是经过了层层封装与加密。在这个过程中，不同的技术手段决定了数据传输的效率、稳定性以及安全性。</p>"
    $long_text += "<h2>⚡ 常见误区与最佳实践方案</h2><p>许多新手用户在初期常常会陷入一些误区，例如盲目追求免费资源、忽视本地设备的网络配置，或者是频繁更换工具而未深究问题根源。正确的做法应该是：首先明确自身的核心需求，然后有针对性地选择合适的线路与软件；其次，保持软件的定期更新以修复潜在漏洞。</p>"
    $long_text += "<h2>🛠️ 高级配置与未来发展趋势</h2><p>当您已经熟悉了基础操作后，可以尝试进一步的高级配置，比如通过编写自定义的路由分流规则，实现国内外流量的无缝切换；或者是通过自建服务端来获得更纯净的专属网络。作为用户，保持持续学习和探索的精神，是应对未来复杂网络环境的最佳策略。</p>"
}

$files = @(
    @{f="beginner-1.html"; t="新手第一步：如何选择合适的客户端"; e="👶"; d="详细介绍各个平台最优秀的代理客户端，带您从零开始入门。本文全文字数约 1500 字。"},
    @{f="beginner-2.html"; t="认识节点：专线、BGP 与直连的区别"; e="🛤️"; d="深入科普不同线路节点的物理原理与价格差异，帮您选出最适合自己的服务。本文全文字数约 1500 字。"},
    @{f="beginner-3.html"; t="常见问题排查：连不上网怎么办？"; e="🔧"; d="网络故障全栈排查指南，涵盖 DNS、时间同步、订阅更新等所有常见坑点。本文全文字数约 1500 字。"},
    @{f="nav-1.html"; t="常用客户端下载大全"; e="📥"; d="全网最安全的官方客户端下载入口聚合，涵盖最新版的内核更新资讯与防投毒指南。本文全文字数约 1500 字。"},
    @{f="nav-2.html"; t="全网测速工具与评测网站汇总"; e="📊"; d="第三方客观测速频道与专业测速工具介绍，教您如何看懂复杂的测速拓扑图。本文全文字数约 1500 字。"},
    @{f="nav-3.html"; t="流媒体合租与账号购买平台"; e="🎬"; d="Netflix、Disney+、Spotify 等流媒体合租发车指南，避开黑户号，安全畅享 4K。本文全文字数约 1500 字。"}
)

foreach ($item in $files) {
    $title = $item.t
    $emoji = $item.e
    $desc = $item.d
    $filename = $item.f
    $html = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>$title - 云轨导航</title><link rel="stylesheet" href="../index.css"></head>
<body><header class="header"><div class="container"><a href="../index.html" class="logo-container"><span class="logo-text">云轨导航</span></a></div></header>
<main class="container" style="padding-top: 100px; max-width: 800px; margin-bottom: 80px;">
<h1>$emoji $title</h1>
<div class="article-content">
<p><b>✨ 核心摘要：</b>$desc</p>
$long_text
</div>
</main>
</body></html>
"@
    [System.IO.File]::WriteAllText($base + $filename, $html, [System.Text.Encoding]::UTF8)
}
Write-Host "All 6 files generated via PowerShell"
