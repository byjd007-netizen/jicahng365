# enrich_seo_and_geo.ps1 - Enrich Meta Descriptions, OpenGraph, Schema.org and GEO Citation Cards
$ErrorActionPreference = "Stop"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$baseDir = Get-Location
$baseUrl = "https://yunguidaohang.com"

# Specialized Meta Descriptions for root/main pages (110~140 chars)
$customDescriptions = @{
    "index.html" = "云轨导航专注为您提供2026年最新的科学上网机场推荐、IPLC高可靠专线测评、Clash/小火箭/v2rayNG全平台客户端配置教程及节点故障排查指南，助您高速稳定科学上网。"
    "ranking.html" = "2026年精选科学上网机场排行榜，严选物理级 IPLC/IEPL 国际专线与多线 BGP 节点，全方位测评晚高峰网速、延迟、4K/8K视频流媒体解锁及稳定性，为您提供性价比高且靠谱的机场推荐。"
    "airports.html" = "云轨导航机场测评中心：收录与对比国内主流 SSR/V2Ray/Clash/Trojan 专线机场，涵盖超低延迟 IPLC 专线、按量付费与月付性价比套餐，深度评测节点晚高峰网速与解锁能力。"
    "knowledge.html" = "云轨导航网络知识库与技术文档中心：提供权威的 Shadowsocks/VMess/VLESS/Hysteria 2 协议深度解析、机场选购防坑避雷秘籍、网络故障诊断速查表及流媒体解锁实测报告。"
    "about.html" = "关于云轨导航编辑团队：我们是由资深网络技术专家组成的独立评测媒体，致力于为全球用户提供客观公正的科学上网机场测试、节点延迟监测、代理协议科普与客户端下载配置教学。"
    "avoid-scam.html" = "科学上网机场避坑防跑路指南：详细剖析低价跑路机场的常见套路、钓鱼假冒官网特征、订阅链接泄露隐患及付费购买防踩坑技巧，教您如何选择安全稳定的月付专线机场。"
    "404.html" = "抱歉，您访问的页面不存在或已被移除。云轨导航为您提供最新的机场推荐排行榜、Clash/Shadowrocket 客户端配置教程及网络故障排查指南，点击返回首页获取更多内容。"
    "article.html" = "云轨导航精选专线机场与代理协议评测文章：涵盖 IPLC 专线优势分析、Shadowrocket/Clash Verge 客户端全平台使用教程以及晚高峰网络延迟优化技巧。"
}

$allHtmlFiles = Get-ChildItem -Path $baseDir -Filter "*.html" -Recurse

$updatedCount = 0

foreach ($file in $allHtmlFiles) {
    $relPath = $file.FullName.Replace($baseDir.Path, "").TrimStart("\")
    $filename = $file.Name
    $isRoot = -not $relPath.Contains("\")
    
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

    # 1. Determine Canonical URL
    if ($filename -eq "index.html" -and $isRoot) {
        $canonicalUrl = "$baseUrl/"
    } elseif ($isRoot) {
        $canonicalUrl = "$baseUrl/$filename"
    } else {
        $canonicalUrl = "$baseUrl/articles/$filename"
    }

    # 2. Extract Title
    $titleMatch = [System.Text.RegularExpressions.Regex]::Match($content, '<title>(.*?)</title>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $rawTitle = if ($titleMatch.Success) { $titleMatch.Groups[1].Value } else { "云轨导航 - 跨境网络与协议知识库" }
    
    # Ensure title tag has "- 云轨导航" suffix on subpages
    $cleanTitleNoSuffix = $rawTitle -replace '\s*-\s*云轨导航', ''
    $titleTagVal = if ($isRoot -and $filename -eq "index.html") { $rawTitle } else { "$cleanTitleNoSuffix - 云轨导航" }

    # 3. Determine/Generate High Quality Meta Description (110 - 150 chars)
    $finalDesc = ""
    if ($customDescriptions.ContainsKey($filename)) {
        $finalDesc = $customDescriptions[$filename]
    } else {
        # Check current description
        $descMatch = [System.Text.RegularExpressions.Regex]::Match($content, '<meta\s+name=["'']description["'']\s+content=["''](.*?)["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if (-not $descMatch.Success) {
            $descMatch = [System.Text.RegularExpressions.Regex]::Match($content, '<meta\s+content=["''](.*?)["'']\s+name=["'']description["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        }
        
        $existingDesc = if ($descMatch.Success) { $descMatch.Groups[1].Value.Trim() } else { "" }

        if ($existingDesc.Length -ge 105 -and $existingDesc.Length -le 160) {
            $finalDesc = $existingDesc
        } else {
            # Build detailed description
            if ($filename.StartsWith("tutorial-")) {
                $finalDesc = "【官方客户端教程】$cleanTitleNoSuffix。详细讲解软件下载安装、订阅链接一键导入、分流规则配置及常见连接超时故障排除，助您在 Windows/Mac/iOS/Android 设备上轻松科学上网。"
            } elseif ($filename.StartsWith("beginner-")) {
                $finalDesc = "【新手必看指南】$cleanTitleNoSuffix。零基础全方位了解专线机场选择技巧、常见代理协议区别、客户端使用入门及晚高峰防卡顿防封锁秘籍，快速掌握科学上网核心技巧。"
            } elseif ($filename.StartsWith("nav-")) {
                $finalDesc = "【导航与资源推荐】$cleanTitleNoSuffix。精选优质 Telegram 电报频道、常用网络测试工具、流媒体检测脚本与安全防封导航，为您提供一站式跨境网络资源指引。"
            } elseif ($filename -in @("edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html")) {
                $finalDesc = "【专线机场深度测评】$cleanTitleNoSuffix。实测节点晚高峰网速与 Ping 延迟、IPLC 内网专线稳定性、Netflix 奈飞与 ChatGPT 原生 IP 解锁能力，提供真实性价比分析与套餐选购建议。"
            } else {
                $finalDesc = "关于 $cleanTitleNoSuffix 的深度解析与技术指南。由云轨导航编辑团队撰写，提供专业的 IPLC 专线测试、代理协议原理分析、客户端故障排查及极速稳定科学上网最佳实践。"
            }
        }
    }

    # Ensure finalDesc length is solid
    if ($finalDesc.Length -lt 100) {
        $finalDesc += " 欢迎访问云轨导航获取更多专线机场推荐与全平台客户端配置教程。"
    }

    # 4. Remove old SEO tags to prevent duplicates
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<link\s+rel=["'']canonical["''].*?>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<meta\s+name=["'']description["''].*?>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<meta\s+content=["''].*?["'']\s+name=["'']description["''].*?>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<meta\s+property=["'']og:.*?["''].*?>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<meta\s+name=["'']twitter:.*?["''].*?>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<script\s+type=["'']application/ld\+json["'']>(.*?)</script>\r?\n?', '', [System.Text.RegularExpressions.RegexOptions]::Singleline -or [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Clean existing title and inject clean title
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<title>(.*?)</title>', "<title>$titleTagVal</title>", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # 5. Build New Meta, OpenGraph and Twitter Tags
    $ogImage = "$baseUrl/assets/images/new_logo.png"
    $seoBlock = @"
  <meta name="description" content="$finalDesc">
  <link rel="canonical" href="$canonicalUrl">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="云轨导航">
  <meta property="og:url" content="$canonicalUrl">
  <meta property="og:title" content="$titleTagVal">
  <meta property="og:description" content="$finalDesc">
  <meta property="og:image" content="$ogImage">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$titleTagVal">
  <meta name="twitter:description" content="$finalDesc">
  <meta name="twitter:image" content="$ogImage">
"@

    # Inject Meta tags into <head>
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(</head>)', "$seoBlock`n`$1", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # 6. Build Schema.org JSON-LD Data
    $lastMod = $file.LastWriteTime.ToString("yyyy-MM-ddTHH:mm:ss+08:00")
    
    # Article Schema
    $articleSchema = @"
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "$cleanTitleNoSuffix",
    "description": "$finalDesc",
    "image": "$ogImage",
    "datePublished": "2026-06-22T08:00:00+08:00",
    "dateModified": "$lastMod",
    "author": {
      "@type": "Organization",
      "name": "云轨导航编辑团队",
      "url": "$baseUrl/about.html"
    },
    "publisher": {
      "@type": "Organization",
      "name": "云轨导航",
      "logo": {
        "@type": "ImageObject",
        "url": "$ogImage"
      }
    }
  }
  </script>
"@

    # Breadcrumb Schema
    $catName = "网络知识库"
    $catUrl = "$baseUrl/knowledge.html"
    if ($filename.StartsWith("tutorial-")) {
        $catName = "客户端教程"
    } elseif ($filename.StartsWith("beginner-")) {
        $catName = "新手指南"
    } elseif ($filename -in @("edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html")) {
        $catName = "机场测评中心"
        $catUrl = "$baseUrl/airports.html"
    }

    $breadcrumbSchema = @"
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "首页",
        "item": "$baseUrl/"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "$catName",
        "item": "$catUrl"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "$cleanTitleNoSuffix",
        "item": "$canonicalUrl"
      }
    ]
  }
  </script>
"@

    # WebSite Schema (Only on index.html)
    $websiteSchema = ""
    if ($filename -eq "index.html" -and $isRoot) {
        $websiteSchema = @"
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "name": "云轨导航",
    "url": "$baseUrl/",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "$baseUrl/knowledge.html?q={search_term_string}",
      "query-input": "required name=search_term_string"
    }
  }
  </script>
"@
    }

    $schemaBlocks = "$articleSchema`n$breadcrumbSchema"
    if ($websiteSchema) { $schemaBlocks += "`n$websiteSchema" }

    # Inject Schemas into <head>
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(</head>)', "$schemaBlocks`n`$1", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # 7. Inject GEO Citation Widget for Article files if not present
    if (-not $isRoot -and $filename.EndsWith(".html") -and $filename -ne "left.html") {
        # Remove any existing geo-cite-card
        $content = [System.Text.RegularExpressions.Regex]::Replace($content, '<div\s+class=["'']geo-cite-card["''].*?</div>\s*<script>.*?</script>', '', [System.Text.RegularExpressions.RegexOptions]::Singleline -or [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        $geoCiteWidget = @"
<div class="geo-cite-card" id="geo-cite-widget">
  <div class="geo-cite-header">
    <h4 class="geo-cite-title">
      <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"></path></svg>
      引用与分享此文 (Cite & Share)
    </h4>
    <span class="geo-cite-badge">GEO AI 搜索索引推荐</span>
  </div>
  <div class="geo-cite-tabs">
    <button class="geo-cite-tab active" onclick="switchGeoTab(this, 'md')">Markdown 引用</button>
    <button class="geo-cite-tab" onclick="switchGeoTab(this, 'bib')">BibTeX 格式</button>
    <button class="geo-cite-tab" onclick="switchGeoTab(this, 'text')">纯文本链接</button>
  </div>
  <div class="geo-cite-box">
    <input type="text" class="geo-cite-input" id="geoCiteInput" readonly value="[$cleanTitleNoSuffix]($canonicalUrl)">
    <button class="geo-cite-btn" onclick="copyGeoCite()">
      <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
      复制
    </button>
  </div>
  <div class="geo-cc-banner">
    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
    <span><strong>版权与转载声明：</strong> 本文由云轨导航原创，允许在保留原文 URL 链接及署名的前提下自由转载与引用。</span>
  </div>
</div>
<script>
function switchGeoTab(btn, type) {
  document.querySelectorAll('.geo-cite-tab').forEach(function(t) { t.classList.remove('active'); });
  btn.classList.add('active');
  var input = document.getElementById('geoCiteInput');
  var title = "$cleanTitleNoSuffix";
  var url = "$canonicalUrl";
  if(type === 'md') {
    input.value = '[' + title + '](' + url + ')';
  } else if(type === 'bib') {
    input.value = '@article{yunguidaohang,\n  title={' + title + '},\n  url={' + url + '},\n  publisher={云轨导航}\n}';
  } else {
    input.value = title + ' - ' + url;
  }
}
function copyGeoCite() {
  var input = document.getElementById('geoCiteInput');
  input.select();
  if (navigator.clipboard) {
    navigator.clipboard.writeText(input.value).then(function() {
      alert('引用链接已复制到剪贴板！');
    });
  } else {
    document.execCommand('copy');
    alert('引用链接已复制到剪贴板！');
  }
}
</script>
"@

        # Insert widget right before </article> or before </footer>
        if ($content -match '</article>') {
            $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
            $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(</article>)', "$geoCiteWidget`n`$1", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        } elseif ($content -match '<footer') {
            $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(<footer)', "$geoCiteWidget`n`$1", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        }
    }

    # Write updated content back with UTF-8 No BOM
    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
    $updatedCount++
    Write-Host "Processed [$relPath] -> Meta description len: $($finalDesc.Length) chars."
}

Write-Host "`nSuccessfully processed $updatedCount HTML files!" -ForegroundColor Green
