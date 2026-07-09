$file = "articles\edgenova.html"
$content = Get-Content -Path $file -Raw -Encoding UTF8
$target = "绝无任何弄虚作假。</p>"
$replacement = $target + "`n`n<figure class=`"article-image-container`" style=`"margin: 30px 0; text-align: center;`">`n    <img src=`"../assets/images/edgenova_speedtest.png`" alt=`"EdgeNova MiaoKo 测速图`" style=`"max-width: 100%; height: auto; border-radius: 12px; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);`">`n    <figcaption style=`"margin-top: 12px; font-size: 0.9rem; color: #64748b;`">EdgeNova 晚高峰 MiaoKo 节点测速实况（全线飘绿）</figcaption>`n</figure>"
$content = $content.Replace($target, $replacement)
Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Replaced successfully."
