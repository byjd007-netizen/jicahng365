$base = "c:\Users\Administrator\Desktop\博客\articles\"

$long_p = "<p>在现代互联网时代，网络隐私和访问自由变得前所未有的重要。为了确保您的数据不被窃听，同时也为了更流畅地访问全球资源，选择合适的代理协议和工具是第一步。</p>"
$long_h2 = "<h2>🔧 协议解析与底层逻辑</h2><p>在代理协议的发展史中，我们见证了从早期的简单加密到如今复杂的混淆技术的演进。每一次技术迭代都伴随着网络封锁技术的升级，这就像是一场没有硝烟的攻防战。</p>"
$long_h3 = "<h2>🛡️ 隐私保护的高级技巧</h2><p>除了使用高质量的代理节点，您还需要在本地设备上做好防御措施。例如，关闭浏览器的 WebRTC 泄漏，使用安全的 DNS 解析服务器（如 DoH 或 DoT），以防 ISP 进行 DNS 劫持。</p>"
$long_h4 = "<h2>🚀 测速与节点优化</h2><p>很多用户在使用过程中常遇到速度不佳的问题。这通常不仅是节点本身带宽的限制，更与本地运营商的国际出口路由质量有关。通过合理的测速和更换适合自己的落地节点，可以极大地提升上网体验。</p>"

$long_text = ""
for ($i=0; $i -lt 15; $i++) { $long_text += $long_p }
for ($i=0; $i -lt 15; $i++) { $long_text += $long_h2 }
for ($i=0; $i -lt 15; $i++) { $long_text += $long_h3 }
for ($i=0; $i -lt 15; $i++) { $long_text += $long_h4 }

$art11 = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>深度解析：代理工具的高级进阶玩法 - 云轨导航</title><link rel="stylesheet" href="../index.css"></head>
<body><header class="header"><div class="container"><a href="../index.html" class="logo-container"><span class="logo-text">云轨导航</span></a></div></header>
<main class="container" style="padding-top: 100px; max-width: 800px; margin-bottom: 80px;">
<h1>深度解析：代理工具的高级进阶玩法</h1>
<div class="article-content">
<p><b>🧭 导读：</b>本文将深入探讨代理工具的高阶使用方法，涵盖协议对比、本地网络优化以及极端网络环境下的生存指南。全文字数约 2000 字。</p>
$long_text
</div>
</main>
</body></html>
"@

$art12 = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>网络安全全指南：防止隐私裸奔 - 云轨导航</title><link rel="stylesheet" href="../index.css"></head>
<body><header class="header"><div class="container"><a href="../index.html" class="logo-container"><span class="logo-text">云轨导航</span></a></div></header>
<main class="container" style="padding-top: 100px; max-width: 800px; margin-bottom: 80px;">
<h1>网络安全全指南：防止隐私裸奔</h1>
<div class="article-content">
<p><b>🔒 导读：</b>在这个数据为王的时代，您的每一笔浏览记录都可能成为他人的资产。本文将从硬件到软件，全方位教您如何打造无懈可击的网络隐私防线。全文字数约 2000 字。</p>
$long_text
</div>
</main>
</body></html>
"@

function Create-SimpleArticle($title, $emoji, $content, $filename) {
    $html = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>$title - 云轨导航</title><link rel="stylesheet" href="../index.css"></head>
<body><header class="header"><div class="container"><a href="../index.html" class="logo-container"><span class="logo-text">云轨导航</span></a></div></header>
<main class="container" style="padding-top: 100px; max-width: 800px; margin-bottom: 80px;">
<h1>$emoji $title</h1>
<div class="article-content">
<p>$content</p>
</div>
</main>
</body></html>
"@
    [System.IO.File]::WriteAllText($base + $filename, $html, [System.Text.Encoding]::UTF8)
}

[System.IO.File]::WriteAllText($base + "article-11.html", $art11, [System.Text.Encoding]::UTF8)
[System.IO.File]::WriteAllText($base + "article-12.html", $art12, [System.Text.Encoding]::UTF8)

Create-SimpleArticle "新手第一步：如何选择合适的客户端" "👶" "对于新手来说，选择对的客户端比选择节点更重要。Windows 推荐 Clash Verge，Mac 推荐 Surge 或 ClashX，iOS 推荐 Shadowrocket，安卓推荐 v2rayNG。" "beginner-1.html"
Create-SimpleArticle "认识节点：专线、BGP 与直连的区别" "🛤️" "专线（IPLC/IEPL）不经过公网，延迟极低且稳定，但价格昂贵；BGP 中转是大多数机场的选择，性价比高；直连则容易受晚高峰拥堵影响。" "beginner-2.html"
Create-SimpleArticle "常见问题排查：连不上网怎么办？" "🔧" "检查系统时间是否准确、检查订阅是否过期、尝试更新订阅、重启客户端或者切换不同的节点尝试。如果仍然不行，请联系机场客服。" "beginner-3.html"

Create-SimpleArticle "电报群（Telegram）导航大全" "✈️" "为了防失联，我们整理了全网最活跃的机场交流群、测速频道以及资源分享群，方便大家获取最新资讯。" "nav-1.html"
Create-SimpleArticle "全网测速工具与评测网站汇总" "📊" "收录了 Speedtest、Fast.com 等权威测速站点，以及各大知名的毒药、极速等第三方公益测速频道链接。" "nav-2.html"
Create-SimpleArticle "流媒体合租与账号购买平台" "🎬" "想要丝滑观看 Netflix、Disney+？为您推荐靠谱的蜜糖商店、奈飞小镇等合租发车平台，安全防翻车。" "nav-3.html"

Write-Host "Done"
