$ErrorActionPreference = "Stop"
$html_replacement = "`n" + [System.IO.File]::ReadAllText(".\template.txt", [System.Text.Encoding]::UTF8) + "`n"

$files = Get-ChildItem -Path ".\" -Filter "*.html" -Recurse

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Safe regex without any Chinese characters to avoid PowerShell ANSI parsing bugs
    $pattern = '(?s)(\s*<!-- Beginner Guide Widget.*?-->\s*)?<div class="widget guide-widget">.*?class="widget-btn"[^>]*>.*?</a>\s*</div>'
    
    if ($content -match $pattern) {
        $newContent = [regex]::Replace($content, $pattern, $html_replacement)
        [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        Write-Output "Applied to: $($file.Name)"
    }
}
Write-Output "Template apply complete."
