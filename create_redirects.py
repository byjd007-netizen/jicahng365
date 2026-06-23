import os

redirects = {
    'airport-recommend': '/#recommend',
    'airport-rank': '/ranking.html',
    'reviews': '/#kb',
    'tutorials': '/#tutorial',
    'clash-tutorial': '/articles/article-2.html',
    'shadowrocket-tutorial': '/articles/article-4.html',
    'client-download': '/articles/nav-1.html',
    'avoid-scam': '/articles/article-3.html'
}

html_template = """<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="0;url={url}">
    <title>跳转中...</title>
    <script>
        window.location.replace("{url}");
    </script>
</head>
<body>
    <p>正在为您跳转到相关页面，请稍候... <a href="{url}">点击这里直接跳转</a></p>
</body>
</html>"""

for folder, target_url in redirects.items():
    if not os.path.exists(folder):
        os.makedirs(folder)
    with open(os.path.join(folder, 'index.html'), 'w', encoding='utf-8') as f:
        f.write(html_template.format(url=target_url))
    print(f'Created redirect for {folder} -> {target_url}')
