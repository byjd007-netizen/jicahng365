$ErrorActionPreference = "Stop"
$files = Get-ChildItem -Path ".\" -Filter "*.html" -Recurse

$oldString = 'ranking_hero.png'
$newString = 'yungui_logo_1782127474781.png'

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    if ($content.Contains($oldString)) {
        $content = $content.Replace($oldString, $newString)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Replaced logo in: $($file.Name)"
    }
}
Write-Output "Logo replacement complete."
