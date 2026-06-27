$ErrorActionPreference = "Stop"
$files = Get-ChildItem -Path ".\" -Filter "*.html" -Recurse

$oldString = '<div class="ranking-header" style="display: flex; align-items: center; margin-bottom: 20px;">'
$newString = '<div class="promo-ranking-header" style="display: flex; align-items: center; margin-bottom: 20px;">'

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    if ($content.Contains($oldString)) {
        $content = $content.Replace($oldString, $newString)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "Fixed class collision in: $($file.Name)"
    }
}
Write-Output "Class collision fix complete."
