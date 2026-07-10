import os
import re
import json
import datetime

# Root directory of the workspace
base_dir = r"c:\Users\Administrator\Desktop\博客"
articles_dir = os.path.join(base_dir, "articles")
base_url = "https://jichang365.com"

# Global FAQ database for pages that don't have explicit FAQ content, mapping by filename
custom_faqs = {
    "article-1.html": [
        {"q": "如何选购适合自己的机场？", "a": "选择机场时需优先考虑线路类型（如 IPLC/IEPL 专线中转）、晚高峰稳定度、月付套餐模式，并根据自身设备选择支持 Clash、小火箭等客户端的机场。"},
        {"q": "便宜机场能长期使用吗？", "a": "便宜机场通常采用公网直连或合租中继，容易在晚高峰网络拥堵或被墙。建议采取月付方式，并准备备用节点防失联。"}
    ],
    "article-2.html": [
        {"q": "Shadowrocket 与 Quantumult X 哪个更适合新手？", "a": "Shadowrocket（小火箭）更适合新手，其支持一键扫码导入和简易配置；Quantumult X（圈叉）功能更强，但配置规则较复杂，适合进阶极客。"},
        {"q": "iOS 客户端如何实现分流？", "a": "iOS 客户端通过导入预设的规则文件（如 ACL4SSR 规则），自动判断网络请求并实现国内流量直连、国外流量代理的分流效果。"}
    ],
    "article-3.html": [
        {"q": "为什么我的节点解锁不了 Netflix 奈飞非自制剧？", "a": "Netflix 奈飞会对其非自制剧（有版权限制的剧集）实施严格的 IP 风控。必须使用经过原生 IP 级别解锁的节点才能完整观看。"},
        {"q": "流媒体合租平台蜜糖商店靠谱吗？", "a": "蜜糖商店、奈飞小镇等大牌合租平台提供自动发号与售后保障，相比个人私下拼车要安全得多，不易发生中途跑路或密码失效。"}
    ],
    "article-4.html": [
        {"q": "Clash 订阅更新报错 'Request Timeout' 怎么解决？", "a": "这通常是由于本地宽带限制了订阅链接的托管服务器域名。可以尝试连接手机热点、利用在线订阅转换器转换，或者开启临时系统代理进行更新。"},
        {"q": "Clash Verge 的 TUN 模式有什么用？", "a": "TUN 模式会建立一个虚拟网卡，接管设备底层的全部网络流量，使那些不支持系统代理的软件（如命令行、各类游戏客户端）也能走代理。"}
    ],
    "article-5.html": [
        {"q": "安卓手机最推荐哪款代理软件？", "a": "最推荐使用 v2rayNG 或 NekoBox。v2rayNG 简单易用，支持导入多协议订阅，适合大多数普通用户。"},
        {"q": "Android 客户端如何配置分应用代理？", "a": "在 v2rayNG 的设置菜单中开启“分应用代理”，然后勾选需要走代理的软件（如 Telegram、YouTube），其余软件即可直连。"}
    ],
    "article-6.html": [
        {"q": "节点连接成功却频繁断流超时是什么原因？", "a": "断流通常由于本地运营商对 UDP 或特定端口进行限速 QoS，或是由于服务器负载过高导致丢包。可以尝试切换 Hysteria 2 等抗封锁强的协议。"},
        {"q": "Clash 客户端显示 TIMEOUT 怎么排除故障？", "a": "1) 检查系统时间是否与北京时间同步；2) 确认订阅是否到期；3) 检查本地宽带是否欠费；4) 重启客户端并更新订阅。"}
    ],
    "article-7.html": [
        {"q": "VLESS 协议相比 VMess 有什么优势？", "a": "VLESS 协议是轻量级的传输协议，去除了 VMess 的复杂加密机制，性能更好；结合 Reality 技术后能完美抵御防火墙的主动探测。"},
        {"q": "为什么 Hysteria 2 协议晚高峰速度快？", "a": "Hysteria 2 协议基于 UDP 的 QUIC 协议，内置自研的拥塞控制算法，即使在网络高丢包环境下也能够最大化榨干本地带宽。"}
    ],
    "article-8.html": [
        {"q": "什么是 IPLC 专线？其优势是什么？", "a": "IPLC（国际私人租用线路）是物理跨国专线。它不经过公网，完全避开 GFW 审查，晚高峰不拥堵，具有超低延迟和 0% 丢包率的绝对优势。"},
        {"q": "什么是 BGP 中转线路？", "a": "BGP 线路通过在国内入口部署多线接入服务器，自动为电信、联通、移动用户匹配最佳中转路径，极大改善了网络跨网延迟。"}
    ],
    "article-9.html": [
        {"q": "如何客观测试机场节点的速度？", "a": "使用专业的 Speedtest 测速工具或三方开源测速脚本，在晚高峰（20:00 - 23:00）测试多线程下载带宽和 YouTube 的连接速度。"},
        {"q": "节点测试延迟（Ping）越低就代表网速越快吗？", "a": "不一定。延迟只代表数据包往返时间，不代表带宽上限。很多专线延迟虽高于直连，但由于零丢包，实际使用反而更流畅。"}
    ],
    "article-10.html": [
        {"q": "国内用户注册 ChatGPT 遇到 'Access Denied' 怎么破？", "a": "这是因为所选节点 IP 纯净度过低，已被 OpenAI 拉黑。必须切换到日本、新加坡或美国的原生双 ISP 住宅 IP 节点访问。"},
        {"q": "Claude 3 注册如何避免封号？", "a": "注册 Claude 3 时需使用纯净节点，并搭配接码平台提供的干净手机号码进行二次验证。登录期间切忌频繁更换节点国家 IP。"}
    ],
    "tutorial-win.html": [
        {"q": "Windows下最推荐使用哪款代理软件？", "a": "目前最推荐 Clash Verge。它界面美观，完美支持 Clash Meta 内核，全面兼容 VLESS Reality 和 Hysteria 2 协议。"},
        {"q": "Clash Verge 如何开启系统代理？", "a": "安装并导入订阅后，在软件的 Dashboard 或 Settings 页面，找到 System Proxy（系统代理）开关并将其打开即可。"}
    ],
    "tutorial-ios.html": [
        {"q": "苹果手机小火箭 Shadowrocket 无法下载怎么办？", "a": "由于国内 App Store 下架，您需要购买或注册一个美区 Apple ID，并在美区 App Store 搜索购买下载 Shadowrocket。"},
        {"q": "小火箭如何通过扫码导入节点？", "a": "打开小火箭后，点击右上角的扫描图标，直接对准机场官网提供的订阅二维码进行扫描，即可自动完成配置导入。"}
    ],
    "tutorial-and.html": [
        {"q": "安卓版 v2rayNG 下载好后打不开怎么办？", "a": "请确保下载自 GitHub 官方发布页或 Google Play 商店，避开未授权的三方应用商店。如果闪退，请检查系统版本或尝试切换 NekoBox。"},
        {"q": "v2rayNG 如何更新订阅节点？", "a": "进入软件主界面，点击左上角菜单，选择‘订阅设置’，添加您的机场订阅。返回主页后，点击右上角三点，选择‘更新订阅’即可。"}
    ],
    "tutorial-mac.html": [
        {"q": "Mac平台科学上网用什么客户端最稳？", "a": "Mac端推荐使用 Stash 或 Clash Verge。Stash 是 iOS 圈叉的高级替代品，而 Clash Verge 开源且与 Windows 使用逻辑一致，十分方便。"},
        {"q": "macOS 提示软件损坏无法打开 Clash Verge 怎么解决？", "a": "打开终端输入 `sudo xattr -r -d com.apple.quarantine /Applications/Clash\\ Verge.app` 并回车输入开机密码，即可解锁运行权限。"}
    ],
    "beginner-1.html": [
        {"q": "新手第一次接触科学上网，应该先做什么？", "a": "新手应首先注册一个靠谱的专线中转机场，然后根据自己的系统设备（Win/Mac/iOS/安卓）下载安装对应的客户端软件，导入订阅即可。"},
        {"q": "如何避免买机场被割韭菜？", "a": "不要一次性年付，尽量按月购买；多参考第三方客观的测速排行榜，避开那些只有直连没有中转节点的低价垃圾机场。"}
    ],
    "beginner-2.html": [
        {"q": "专线和直连节点用起来有什么差别？", "a": "直连节点通过普通宽带公网连接，受晚高峰出口限制，丢包率高；专线（IPLC）走内网通道不经过公网，晚高峰依旧坚挺，非常稳定。"},
        {"q": "游戏专线和普通中转有什么不同？", "a": "游戏专线通常是专门针对某些游戏服务器（如港服、日服）进行低延迟优化的 IPLC 专线，支持 UDP 转发，防止游戏过程中瞬移或掉线。"}
    ],
    "beginner-3.html": [
        {"q": "导入订阅后客户端显示连接成功，但依然打不开谷歌怎么办？", "a": "请排查：1) 本地系统时间是否准确；2) 是否开启了‘系统代理’开关；3) 尝试切换节点或者检查节点延迟是否为 -1。"},
        {"q": "手机连接 WiFi 能上谷歌，换成移动数据流量就不行了，怎么解决？", "a": "这是因为本地移动运营商屏蔽了当前机场的订阅入口或节点端口。可以在客户端中开启‘启用 Mux’或更换其他备用节点。"}
    ]
}

# General airport pages FAQ mapping
airport_faqs = [
    {"q": "该机场支持哪些科学上网客户端？", "a": "该机场全面兼容主流代理客户端，包括 Windows/Mac 平台的 Clash Verge, Clash for Windows, Stash，以及手机端的 Shadowrocket (小火箭), v2rayNG, Sing-box 等。"},
    {"q": "该机场采用什么网络线路？", "a": "该机场主力节点均部署了企业级 IPLC/IEPL 国际专线，并搭配国内多线 BGP 智能入口中转，能够有效避开公网高峰期拥堵，提供零丢包的稳定连接。"},
    {"q": "购买套餐后无法使用可以退款吗？", "a": "机场属于数字带宽服务，一般不支持无理由退款。建议购买前先选择最便宜的月付套餐进行本地网速测试，满意后再续费高阶配置。"}
]

def clean_links(html_content):
    # Fix empty hrefs to prevent broken links
    html_content = re.sub(r'href=""', 'href="/"', html_content)
    html_content = re.sub(r'href="#"', 'href="/"', html_content)
    return html_content

def process_file(file_path, filename, is_root=False):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Determine Canonical URL
    path_suffix = f"articles/{filename}" if not is_root else filename
    if filename == "index.html" and is_root:
        canonical_url = f"{base_url}/"
    else:
        canonical_url = f"{base_url}/{path_suffix}"

    # Extract Title
    title_match = re.search(r"<title>(.*?)</title>", content, re.IGNORECASE)
    title = title_match.group(1) if title_match else "云轨导航 - 跨境网络与协议知识库"
    # Clean title suffix if repeated
    if " - 云轨导航" not in title and not is_root:
        title_tag_val = f"{title} - 云轨导航"
    else:
        title_tag_val = title

    # Extract or Generate Description
    desc_match = re.search(r'<meta\s+name=["\']description["\']\s+content=["\'](.*?)["\']', content, re.IGNORECASE)
    if not desc_match:
        desc_match = re.search(r'<meta\s+content=["\'](.*?)["\']\s+name=["\']description["\']', content, re.IGNORECASE)
    
    if desc_match:
        description = desc_match.group(1)
    else:
        # Build description from title
        description = f"关于{title}的详细配置说明与网络知识介绍。由云梯指南技术编辑团队撰写，提供深度专线评测及客户端教程。"

    # Clean existing SEO tags (canonical, OG, twitter card, schemas) to prevent duplicates
    content = re.sub(r'<link\s+rel=["\']canonical["\'].*?>', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+property=["\']og:.*?["\'].*?>', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<meta\s+name=["\']twitter:.*?["\'].*?>', '', content, flags=re.IGNORECASE)
    content = re.sub(r'<script\s+type=["\']application/ld\+json["\']>(.*?)</script>', '', content, flags=re.DOTALL | re.IGNORECASE)

    # 1. Build new Meta and OG Tags
    seo_meta_tags = f"""  <link rel="canonical" href="{canonical_url}">
  <meta property="og:type" content="article">
  <meta property="og:url" content="{canonical_url}">
  <meta property="og:title" content="{title_tag_val}">
  <meta property="og:description" content="{description}">
  <meta property="og:image" content="{base_url}/assets/images/new_logo.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{title_tag_val}">
  <meta name="twitter:description" content="{description}">
  <meta name="twitter:image" content="{base_url}/assets/images/new_logo.png">"""

    # Insert seo_meta_tags right before </head>
    content = re.sub(r'(</head>)', f'\n{seo_meta_tags}\n\\1', content, count=1, flags=re.IGNORECASE)

    # 2. Build Schema JSON-LD Data
    # 2.1 Article Schema
    last_mod_time = datetime.datetime.fromtimestamp(os.path.getmtime(file_path)).strftime('%Y-%m-%dT%H:%M:%S+08:00')
    article_schema = {
        "@context": "https://schema.org",
        "@type": "Article",
        "headline": title.split(" - ")[0],
        "description": description,
        "image": f"{base_url}/assets/images/new_logo.png",
        "datePublished": "2026-06-22T08:00:00+08:00",
        "dateModified": last_mod_time,
        "author": {
            "@type": "Organization",
            "name": "云梯指南技术编辑团队",
            "url": f"{base_url}/about.html"
        },
        "publisher": {
            "@type": "Organization",
            "name": "云轨导航",
            "logo": {
                "@type": "ImageObject",
                "url": f"{base_url}/assets/images/new_logo.png"
            }
        }
    }

    # 2.2 Breadcrumb Schema
    # Map categorizations
    category_name = "网络知识库"
    category_url = f"{base_url}/knowledge.html"
    if filename.startswith("tutorial-"):
      category_name = "客户端教程"
      category_url = f"{base_url}/knowledge.html"
    elif filename.startswith("beginner-"):
      category_name = "新手指南"
      category_url = f"{base_url}/knowledge.html"
    elif filename.startswith("nav-"):
      category_name = "电报与常用导航"
      category_url = f"{base_url}/knowledge.html"
    elif filename in ["edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html"]:
      category_name = "机场测评中心"
      category_url = f"{base_url}/airports.html"

    breadcrumb_schema = {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "首页",
                "item": f"{base_url}/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": category_name,
                "item": category_url
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": title.split(" - ")[0],
                "item": canonical_url
            }
        ]
    }

    # 2.3 FAQPage Schema
    faq_schema = None
    faqs = []
    
    # Try finding in predefined faqs
    if filename in custom_faqs:
        faqs = custom_faqs[filename]
    elif not is_root and category_name == "机场测评中心":
        faqs = airport_faqs
        
    if faqs:
        faq_schema = {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": []
        }
        for item in faqs:
            faq_schema["mainEntity"].append({
                "@type": "Question",
                "name": item["q"],
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": item["a"]
                }
            })

    # Build Schema injection blocks
    schema_blocks = f"""
  <script type="application/ld+json">
  {json.dumps(article_schema, ensure_ascii=False, indent=2)}
  </script>
  <script type="application/ld+json">
  {json.dumps(breadcrumb_schema, ensure_ascii=False, indent=2)}
  </script>"""

    if faq_schema:
        schema_blocks += f"""
  <script type="application/ld+json">
  {json.dumps(faq_schema, ensure_ascii=False, indent=2)}
  </script>"""

    # Inject Schema scripts right before </head>
    content = re.sub(r'(</head>)', f'{schema_blocks}\n\\1', content, count=1, flags=re.IGNORECASE)

    # Clean empty links
    content = clean_links(content)

    # Write back
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Processed {filename} -> Canonical, OG, & Structured Data injected.")

# Process all articles
for filename in os.listdir(articles_dir):
    if filename.endswith(".html"):
        process_file(os.path.join(articles_dir, filename), filename)

# Process root pages
root_pages = ["ranking.html", "airports.html", "knowledge.html", "about.html"]
for filename in root_pages:
    process_file(os.path.join(base_dir, filename), filename, is_root=True)

print("All files processed successfully!")
