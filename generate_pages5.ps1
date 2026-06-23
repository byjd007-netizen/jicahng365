$base = ".\articles\"

$files = @(
    @{f="beginner-1.html"; t="新手第一步：如何选择合适的客户端"; e="👶"; c="对于新手来说，选择对的客户端比选择节点更重要。Windows 推荐 Clash Verge，Mac 推荐 Surge 或 ClashX，iOS 推荐 Shadowrocket，安卓推荐 v2rayNG。"},
    @{f="beginner-2.html"; t="认识节点：专线、BGP 与直连的区别"; e="🛤️"; c="专线（IPLC/IEPL）不经过公网，延迟极低且稳定，但价格昂贵；BGP 中转是大多数机场的选择，性价比高；直连则容易受晚高峰拥堵影响。"},
    @{f="beginner-3.html"; t="常见问题排查：连不上网怎么办？"; e="🔧"; c="检查系统时间是否准确、检查订阅是否过期、尝试更新订阅、重启客户端或者切换不同的节点尝试。如果仍然不行，请联系机场客服。"},
    @{f="nav-1.html"; t="电报群（Telegram）导航大全"; e="✈️"; c="为了防失联，我们整理了全网最活跃的机场交流群、测速频道以及资源分享群，方便大家获取最新资讯。"},
    @{f="nav-2.html"; t="全网测速工具与评测网站汇总"; e="📊"; c="收录了 Speedtest、Fast.com 等权威测速站点，以及各大知名的毒药、极速等第三方公益测速频道链接。"},
    @{f="nav-3.html"; t="流媒体合租与账号购买平台"; e="🎬"; c="想要丝滑观看 Netflix、Disney+？为您推荐靠谱的蜜糖商店、奈飞小镇等合租发车平台，安全防翻车。"}
)

foreach ($item in $files) {
    $title = $item.t
    $emoji = $item.e
    $content = $item.c
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
    [System.IO.File]::WriteAllText($base + $item.f, $html, [System.Text.Encoding]::UTF8)
}
Write-Host "Done"
