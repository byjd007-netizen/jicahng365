$basePath = "."
$articlesPath = ".\articles"
$baseUrl = "https://jichang365.com"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Load faqs.json with UTF-8 encoding
$jsonRaw = Get-Content -Path ".\faqs.json" -Raw -Encoding UTF8
$data = ConvertFrom-Json $jsonRaw

$settings = $data.settings
$customFaqs = $data.custom_faqs
$airportFaqs = $data.airport_faqs

function Process-Html-File($filePath, $filename, $isRoot) {
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

    # Determine Canonical URL
    $pathSuffix = if ($isRoot) { $filename } else { "articles/$filename" }
    $canonicalUrl = if ($filename -eq "index.html" -and $isRoot) { "$baseUrl/" } else { "$baseUrl/$pathSuffix" }

    # Extract Title
    $title = "云轨导航"
    if ($content -match "<title>(.*?)</title>") {
        $title = $Matches[1].Trim()
    }
    
    # Format Title tag correctly
    $brandSuffix = " - " + $settings.publisher_name
    $titleTagVal = $title
    if ($title -notmatch $settings.publisher_name -and -not $isRoot) {
        $titleTagVal = $title + $brandSuffix
    }

    # Extract Meta Description
    $description = $settings.default_description -f $title
    if ($content -match "<meta[^>]+name=['""]description['""][^>]+content=['""](.*?)['""]" -or $content -match "<meta[^>]+content=['""](.*?)['""][^>]+name=['""]description['""]") {
        $description = $Matches[1].Trim()
    }

    # Clean existing SEO tags (case-insensitively)
    $content = $content -replace "(?i)<link\s+rel=['""]canonical['""].*?>", ""
    $content = $content -replace "(?i)<meta\s+property=['""]og:.*?['""].*?>", ""
    $content = $content -replace "(?i)<meta\s+name=['""]twitter:.*?['""].*?>", ""
    $content = $content -replace "(?is)<script\s+type=['""]application/ld\+json['""]>(.*?)</script>", ""

    # 1. Build Meta tags block
    $metaBlock = @"
  <link rel="canonical" href="$canonicalUrl">
  <meta name="description" content="$description">
  <meta property="og:type" content="article">
  <meta property="og:url" content="$canonicalUrl">
  <meta property="og:title" content="$titleTagVal">
  <meta property="og:description" content="$description">
  <meta property="og:image" content="$baseUrl/assets/images/new_logo.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$titleTagVal">
  <meta name="twitter:description" content="$description">
  <meta name="twitter:image" content="$baseUrl/assets/images/new_logo.png">
"@

    # 2. Build Schemas
    $lastMod = (Get-Item $filePath).LastWriteTime.ToString("yyyy-MM-ddTHH:mm:ss+08:00")
    
    # 2.1 Article Schema
    $articleSchema = @{
        "@context" = "https://schema.org"
        "@type" = "Article"
        "headline" = ($title -split " - ")[0]
        "description" = $description
        "image" = "$baseUrl/assets/images/new_logo.png"
        "datePublished" = "2026-06-22T08:00:00+08:00"
        "dateModified" = $lastMod
        "author" = @{
            "@type" = "Organization"
            "name" = $settings.author_name
            "url" = "$baseUrl/about.html"
        }
        "publisher" = @{
            "@type" = "Organization"
            "name" = $settings.publisher_name
            "logo" = @{
                "@type" = "ImageObject"
                "url" = "$baseUrl/assets/images/new_logo.png"
            }
        }
    }

    # 2.2 Breadcrumb Schema
    $categoryName = $settings.categories.default
    $categoryUrl = "$baseUrl/knowledge.html"
    if ($filename -like "tutorial-*") {
        $categoryName = $settings.categories.tutorial
    } elseif ($filename -like "beginner-*") {
        $categoryName = $settings.categories.beginner
    } elseif ($filename -like "nav-*") {
        $categoryName = $settings.categories.nav
    } elseif ($filename -in "edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html") {
        $categoryName = $settings.categories.airport
        $categoryUrl = "$baseUrl/airports.html"
    }

    $breadcrumbSchema = @{
        "@context" = "https://schema.org"
        "@type" = "BreadcrumbList"
        "itemListElement" = @(
            @{
                "@type" = "ListItem"
                "position" = 1
                "name" = $settings.home_breadcrumb_name
                "item" = "$baseUrl/"
            },
            @{
                "@type" = "ListItem"
                "position" = 2
                "name" = $categoryName
                "item" = $categoryUrl
            },
            @{
                "@type" = "ListItem"
                "position" = 3
                "name" = ($title -split " - ")[0]
                "item" = $canonicalUrl
            }
        )
    }

    # 2.3 FAQ Schema
    $faqSchema = $null
    $faqs = $null
    if ($customFaqs.PSObject.Properties.Name -contains $filename) {
        $faqs = $customFaqs.$filename
    } elseif (-not $isRoot -and $categoryName -eq $settings.categories.airport) {
        $faqs = $airportFaqs
    }

    if ($null -ne $faqs -and $faqs.Count -gt 0) {
        $entities = @()
        foreach ($faq in $faqs) {
            $entities += @{
                "@type" = "Question"
                "name" = $faq.q
                "acceptedAnswer" = @{
                    "@type" = "Answer"
                    "text" = $faq.a
                }
            }
        }
        $faqSchema = @{
            "@context" = "https://schema.org"
            "@type" = "FAQPage"
            "mainEntity" = $entities
        }
    }

    # Convert schemas to JSON
    $articleJson = ConvertTo-Json -InputObject $articleSchema -Depth 10 -Compress
    $articleJson = $articleJson -replace '\\/', '/'
    
    $breadcrumbJson = ConvertTo-Json -InputObject $breadcrumbSchema -Depth 10 -Compress
    $breadcrumbJson = $breadcrumbJson -replace '\\/', '/'

    $schemasBlock = @"
  <script type="application/ld+json">
  $articleJson
  </script>
  <script type="application/ld+json">
  $breadcrumbJson
  </script>
"@

    if ($null -ne $faqSchema) {
        $faqJson = ConvertTo-Json -InputObject $faqSchema -Depth 10 -Compress
        $faqJson = $faqJson -replace '\\/', '/'
        $schemasBlock += "`r`n  <script type=`"application/ld+json`">`r`n  $faqJson`r`n  </script>"
    }

    # Clean empty links
    $content = $content -replace 'href=""', 'href="/"'
    $content = $content -replace 'href="#"', 'href="/"'

    # Insert tags and schemas into head
    $injection = "`r`n" + $metaBlock + "`r`n" + $schemasBlock
    $content = $content -replace "(?i)</head>", ($injection + "`r`n</head>")

    [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
    Write-Host "Processed $filename"
}

# Process all articles
Get-ChildItem -Path $articlesPath -Filter "*.html" | ForEach-Object {
    Process-Html-File $_.FullName $_.Name $false
}

# Process root pages
$rootPages = @("ranking.html", "airports.html", "knowledge.html", "about.html")
foreach ($page in $rootPages) {
    $filePath = Join-Path $basePath $page
    if (Test-Path $filePath) {
        Process-Html-File $filePath $page $true
    }
}

Write-Host "All files processed successfully via PowerShell ASCII-only script!"
