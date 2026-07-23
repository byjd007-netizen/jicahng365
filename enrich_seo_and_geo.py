# enrich_seo_and_geo.py - Comprehensive SEO & GEO enrichment script
import os
import glob
import re
import datetime

base_dir = r"c:\Users\Administrator\Desktop\博客"
base_url = "https://yunguidaohang.com"

custom_descriptions = {
    "index.html": "云轨导航专注为您提供2026年最新的科学上网机场推荐、IPLC高可靠专线测评、Clash/小火箭/v2rayNG全平台客户端配置教程及节点故障排查指南，助您高速稳定科学上网。",
    "ranking.html": "2026年精选科学上网机场排行榜，严选物理级 IPLC/IEPL 国际专线与多线 BGP 节点，全方位测评晚高峰网速、延迟、4K/8K视频流媒体解锁及稳定性，为您提供性价比高且靠谱的机场推荐。",
    "airports.html": "云轨导航机场测评中心：收录与对比国内主流 SSR/V2Ray/Clash/Trojan 专线机场，涵盖超低延迟 IPLC 专线、按量付费与月付性价比套餐，深度评测节点晚高峰网速与解锁能力。",
    "knowledge.html": "云轨导航网络知识库与技术文档中心：提供权威的 Shadowsocks/VMess/VLESS/Hysteria 2 协议深度解析、机场选购防坑避雷秘籍、网络故障诊断速查表及流媒体解锁实测报告。",
    "about.html": "关于云轨导航编辑团队：我们是由资深网络技术专家组成的独立评测媒体，致力于为全球用户提供客观公正的科学上网机场测试、节点延迟监测、代理协议科普与客户端下载配置教学。",
    "avoid-scam.html": "科学上网机场避坑防跑路指南：详细剖析低价跑路机场的常见套路、钓鱼假冒官网特征、订阅链接泄露隐患及付费购买防踩坑技巧，教您如何选择安全稳定的月付专线机场。",
    "404.html": "抱歉，您访问的页面不存在或已被移除。云轨导航为您提供最新的机场推荐排行榜、Clash/Shadowrocket 客户端配置教程及网络故障排查指南，点击返回首页获取更多内容。",
    "article.html": "云轨导航精选专线机场与代理协议评测文章：涵盖 IPLC 专线优势分析、Shadowrocket/Clash Verge 客户端全平台使用教程以及晚高峰网络延迟优化技巧。"
}

files = glob.glob(os.path.join(base_dir, "*.html")) + glob.glob(os.path.join(base_dir, "articles", "*.html"))

processed_count = 0

for file_path in files:
    filename = os.path.basename(file_path)
    rel_path = os.path.relpath(file_path, base_dir)
    is_root = not rel_path.startswith("articles")

    with open(file_path, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()

    # 1. Canonical URL
    if filename == "index.html" and is_root:
        canonical_url = f"{base_url}/"
    elif is_root:
        canonical_url = f"{base_url}/{filename}"
    else:
        canonical_url = f"{base_url}/articles/{filename}"

    # 2. Extract Title
    title_match = re.search(r"<title>(.*?)</title>", content, re.IGNORECASE)
    raw_title = title_match.group(1) if title_match else "云轨导航 - 跨境网络与协议知识库"
    clean_title = re.sub(r"\s*-\s*云轨导航", "", raw_title).strip()
    title_tag_val = raw_title if (is_root and filename == "index.html") else f"{clean_title} - 云轨导航"

    # 3. Determine Description (target 110 - 150 chars)
    if filename in custom_descriptions:
        final_desc = custom_descriptions[filename]
    else:
        desc_match = re.search(r'<meta\s+name=["\']description["\']\s+content=["\'](.*?)["\']', content, re.IGNORECASE) or \
                     re.search(r'<meta\s+content=["\'](.*?)["\']\s+name=["\']description["\']', content, re.IGNORECASE)
        existing_desc = desc_match.group(1).strip() if desc_match else ""

        if len(existing_desc) >= 105 and len(existing_desc) <= 160:
            final_desc = existing_desc
        else:
            if filename.startswith("tutorial-"):
                final_desc = f"【官方客户端教程】{clean_title}。详细讲解软件下载安装、订阅链接一键导入、分流规则配置及常见连接超时故障排除，助您在 Windows/Mac/iOS/Android 设备上轻松科学上网。"
            elif filename.startswith("beginner-"):
                final_desc = f"【新手必看指南】{clean_title}。零基础全方位了解专线机场选择技巧、常见代理协议区别、客户端使用入门及晚高峰防卡顿防封锁秘籍，快速掌握科学上网核心技巧。"
            elif filename.startswith("nav-"):
                final_desc = f"【导航与资源推荐】{clean_title}。精选优质 Telegram 电报频道、常用网络测试工具、流媒体检测脚本与安全防封导航，为您提供一站式跨境网络资源指引。"
            elif filename in ["edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html"]:
                final_desc = f"【专线机场深度测评】{clean_title}。实测节点晚高峰网速与 Ping 延迟、IPLC 内网专线稳定性、Netflix 奈飞与 ChatGPT 原生 IP 解锁能力，提供真实性价比分析与套餐选购建议。"
            else:
                final_desc = f"关于 {clean_title} 的深度解析与技术指南。由云轨导航编辑团队撰写，提供专业的 IPLC 专线测试、代理协议原理分析、客户端故障排查及极速稳定科学上网最佳实践。"

    if len(final_desc) < 100:
        final_desc += " 欢迎访问云轨导航获取更多专线机场推荐与全平台客户端配置教程。"

    # 4. Clean old SEO & meta tags to prevent duplication
    content = re.sub(r'<link\s+rel=["\']canonical["\'].*?>\r?\n?', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+name=["\']description["\'].*?>\r?\n?', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+content=["\'].*?["\']\s+name=["\']description["\'].*?>\r?\n?', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+property=["\']og:.*?["\'].*?>\r?\n?', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+name=["\']twitter:.*?["\'].*?>\r?\n?', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<script\s+type=["\']application/ld\+json["\']>(.*?)</script>\r?\n?', '', content, flags=re.DOTALL | re.IGNORECASE)

    # Clean title
    content = re.sub(r'<title>(.*?)</title>', f'<title>{title_tag_val}</title>', content, flags=re.IGNORECASE)

    # 5. Build New SEO Meta Tags
    og_image = f"{base_url}/assets/images/new_logo.png"
    seo_block = f"""  <meta name="description" content="{final_desc}">
  <link rel="canonical" href="{canonical_url}">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="云轨导航">
  <meta property="og:url" content="{canonical_url}">
  <meta property="og:title" content="{title_tag_val}">
  <meta property="og:description" content="{final_desc}">
  <meta property="og:image" content="{og_image}">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{title_tag_val}">
  <meta name="twitter:description" content="{final_desc}">
  <meta name="twitter:image" content="{og_image}">"""

    content = re.sub(r'(</head>)', f'{seo_block}\n\\1', content, count=1, flags=re.IGNORECASE)

    # 6. Build Schema.org JSON-LD Data
    mtime = os.path.getmtime(file_path)
    last_mod = datetime.datetime.fromtimestamp(mtime).strftime('%Y-%m-%dT%H:%M:%S+08:00')

    article_schema = {
        "@context": "https://schema.org",
        "@type": "Article",
        "headline": clean_title,
        "description": final_desc,
        "image": og_image,
        "datePublished": "2026-06-22T08:00:00+08:00",
        "dateModified": last_mod,
        "author": {
            "@type": "Organization",
            "name": "云轨导航编辑团队",
            "url": f"{base_url}/about.html"
        },
        "publisher": {
            "@type": "Organization",
            "name": "云轨导航",
            "logo": {
                "@type": "ImageObject",
                "url": og_image
            }
        }
    }

    cat_name = "网络知识库"
    cat_url = f"{base_url}/knowledge.html"
    if filename.startswith("tutorial-"):
        cat_name = "客户端教程"
    elif filename.startswith("beginner-"):
        cat_name = "新手指南"
    elif filename in ["edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html"]:
        cat_name = "机场测评中心"
        cat_url = f"{base_url}/airports.html"

    breadcrumb_schema = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {"@type": "ListItem", "position": 1, "name": "首页", "item": f"{base_url}/"},
            {"@type": "ListItem", "position": 2, "name": cat_name, "item": cat_url},
            {"@type": "ListItem", "position": 3, "name": clean_title, "item": canonical_url}
        ]
    }

    schema_script = f"""  <script type="application/ld+json">
{re.sub(r'^', '  ', repr(article_schema), flags=re.M)}
  </script>
  <script type="application/ld+json">
{re.sub(r'^', '  ', repr(breadcrumb_schema), flags=re.M)}
  </script>"""

    # Format JSON strings cleanly
    import json
    schema_script = f"""  <script type="application/ld+json">
{json.dumps(article_schema, ensure_ascii=False, indent=2)}
  </script>
  <script type="application/ld+json">
{json.dumps(breadcrumb_schema, ensure_ascii=False, indent=2)}
  </script>"""

    if filename == "index.html" and is_root:
        website_schema = {
            "@context": "https://schema.org",
            "@type": "WebSite",
            "name": "云轨导航",
            "url": f"{base_url}/",
            "potentialAction": {
                "@type": "SearchAction",
                "target": f"{base_url}/knowledge.html?q={{search_term_string}}",
                "query-input": "required name=search_term_string"
            }
        }
        schema_script += f"""
  <script type="application/ld+json">
{json.dumps(website_schema, ensure_ascii=False, indent=2)}
  </script>"""

    content = re.sub(r'(</head>)', f'{schema_script}\n\\1', content, count=1, flags=re.IGNORECASE)

    # 7. GEO Cite & Share Card for Articles
    if not is_root and filename != "left.html":
        content = re.sub(r'<div\s+class=["\']geo-cite-card["\'].*?</div>\s*<script>.*?</script>', '', content, flags=re.DOTALL | re.IGNORECASE)

        geo_widget = f"""<div class="geo-cite-card" id="geo-cite-widget">
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
    <input type="text" class="geo-cite-input" id="geoCiteInput" readonly value="[{clean_title}]({canonical_url})">
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
function switchGeoTab(btn, type) {{
  document.querySelectorAll('.geo-cite-tab').forEach(function(t) {{ t.classList.remove('active'); }});
  btn.classList.add('active');
  var input = document.getElementById('geoCiteInput');
  var title = "{clean_title}";
  var url = "{canonical_url}";
  if(type === 'md') {{
    input.value = '[' + title + '](' + url + ')';
  }} else if(type === 'bib') {{
    input.value = '@article{{yunguidaohang,\\n  title={{' + title + '}},\\n  url={{' + url + '}},\\n  publisher={{云轨导航}}\\n}}';
  }} else {{
    input.value = title + ' - ' + url;
  }}
}}
function copyGeoCite() {{
  var input = document.getElementById('geoCiteInput');
  input.select();
  if (navigator.clipboard) {{
    navigator.clipboard.writeText(input.value).then(function() {{
      alert('引用链接已复制到剪贴板！');
    }});
  }} else {{
    document.execCommand('copy');
    alert('引用链接已复制到剪贴板！');
  }}
}}
</script>"""

        if "</article>" in content:
            content = re.sub(r'(</article>)', f'{geo_widget}\n\\1', content, count=1, flags=re.IGNORECASE)
        elif "<footer" in content:
            content = re.sub(r'(<footer)', f'{geo_widget}\n\\1', count=1, flags=re.IGNORECASE)

    with open(file_path, "w", encoding="utf-8") as fp:
        fp.write(content)

    processed_count += 1
    print(f"Processed [{rel_path}] -> Desc length: {len(final_desc)} chars.")

print(f"\nDone! Processed {processed_count} files.")
