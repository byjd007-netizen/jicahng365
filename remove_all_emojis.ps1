# Search for all html, json, js files in workspace recursively
$files = Get-ChildItem -Path "." -Include *.html, *.json, *.js -Recurse

$emojiPattern = '\p{Cs}|[\u2600-\u27bf]|[\u2300-\u23ff]|[\u2b50-\u2b55]|[\u2934-\u2935]|[\u3297-\u3299]|[\u303d]|[\u3030]|[\u24c2]|[\ufe0f]'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

foreach ($file in $files) {
    # Skip files inside .git directory
    if ($file.FullName -like "*\.git\*") { continue }
    
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Count matches
    $matches = [regex]::Matches($content, $emojiPattern)
    if ($matches.Count -gt 0) {
        Write-Host "File: $($file.FullName) - Found $($matches.Count) emojis. Removing..."
        
        $cleaned = $content -replace $emojiPattern, ""
        [System.IO.File]::WriteAllText($file.FullName, $cleaned, $utf8NoBom)
    }
}
Write-Host "Emoji removal completed!"
