$redirects = @{
    'airport-recommend' = '/#recommend'
    'airport-rank' = '/ranking.html'
    'reviews' = '/#kb'
    'tutorials' = '/#tutorial'
    'clash-tutorial' = '/articles/tutorial-win.html'
    'shadowrocket-tutorial' = '/articles/tutorial-ios.html'
    'client-download' = '/articles/nav-1.html'
    'avoid-scam' = '/articles/beginner-1.html'
}

$html_template = @"
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="0;url={0}">
    <title>跳转中...</title>
    <script>
        window.location.replace("{0}");
    </script>
</head>
<body>
    <p>正在为您跳转到相关页面，请稍候... <a href="{0}">点击这里直接跳转</a></p>
</body>
</html>
"@

foreach ($folder in $redirects.Keys) {
    $target_url = $redirects[$folder]
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }
    $content = $html_template -f $target_url
    [System.IO.File]::WriteAllText(".\$folder\index.html", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Created redirect for $folder -> $target_url"
}
