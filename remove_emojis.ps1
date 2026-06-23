$emojis = @(
    "🚀", "📅", "👶", "💻", "⚡", "🍎", "📱", "⭐", "🏆", "🥇", "🥈", "🥉", 
    "🛡️", "🔰", "🎬", "🌍", "🌐", "🔒", "🧭", "🔗", "🔥", "✈️", "📥", "⚠️",
    "🛡", "✈"
)

$files = Get-ChildItem -Path "." -Recurse -Filter "*.html"

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $modified = $false
    
    foreach ($emoji in $emojis) {
        if ($content.Contains($emoji)) {
            $content = $content.Replace($emoji, "")
            $modified = $true
        }
    }
    
    if ($modified) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Removed emojis from $($file.Name)"
    }
}
