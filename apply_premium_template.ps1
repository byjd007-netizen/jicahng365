$ErrorActionPreference = "Stop"
$html_replacement = "`n" + [System.IO.File]::ReadAllText(".\template_premium.txt", [System.Text.Encoding]::UTF8) + "`n"

$files = Get-ChildItem -Path ".\" -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Safe regex without any Chinese characters
    $pattern = '(?s)(\s*<!-- Premium Airport Widget.*?-->\s*)?<div class="widget premium-widget">.*?class="widget-btn primary"[^>]*>.*?</a>\s*</div>'
    
    if ($content -match $pattern) {
        $newContent = [regex]::Replace($content, $pattern, $html_replacement)
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Output "Applied premium template to: $($file.Name)"
    }
}
Write-Output "Premium template apply complete."
