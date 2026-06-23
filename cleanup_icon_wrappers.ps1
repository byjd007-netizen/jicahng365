$files = Get-ChildItem -Path "." -Recurse -Filter "*.html"

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $original = $content
    
    # 1. Remove left over emojis
    $emojis = @("👑", "☁️", "🤖", "☁", "🍎", "📱")
    foreach ($emoji in $emojis) {
        $content = $content.Replace($emoji, "")
    }

    # 2. Remove empty icon wrappers
    # Target Hero section
    $content = [regex]::Replace($content, '(?s)<div style="width: 46px; height: 46px;[^>]+>\s*</div>', '')
    
    # Target Airport section
    $content = [regex]::Replace($content, '(?s)<div class="kb-icon"[^>]*>\s*</div>', '')
    
    # Target Tutorial section
    $content = [regex]::Replace($content, '(?s)<div class="kb-icon-wrap[^>]*>\s*</div>', '')

    if ($content -cne $original) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Cleaned wrappers from $($file.Name)"
    }
}
