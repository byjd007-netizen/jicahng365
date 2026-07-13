$baseDir = "."
$articlesDir = Join-Path $baseDir "articles"
$faqsPath = Join-Path $baseDir "faqs.json"
$templatesPath = Join-Path $baseDir "seo_templates.json"
$baseUrl = "https://yunguidaohang.com"

# Load databases
$faqsJson = [System.IO.File]::ReadAllText($faqsPath, [System.Text.Encoding]::UTF8)
$faqsDb = $faqsJson | ConvertFrom-Json

$templatesJson = [System.IO.File]::ReadAllText($templatesPath, [System.Text.Encoding]::UTF8)
$templatesDb = $templatesJson | ConvertFrom-Json

# Helper to clean links
function Clean-HtmlLinks($content) {
    # Replace href="" or href="#" with valid links
    $content = $content -replace 'href=""', 'href="/"'
    $content = $content -replace 'href="#"', 'href="/"'
    # Brand Clean-up
    $content = $content -replace 'jichang365.com', 'yunguidaohang.com'
    return $content
}

# Helper to process a single file
function Process-File($filePath, $filename, $isRoot) {
    Write-Output "Processing: $filename"
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

    # 1. Clean existing SEO structures to prevent duplication
    # Clean Canonical, OG, Twitter, description, and LD-JSON scripts
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<link\s+rel=["'']canonical["''].*?>', '')
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<meta\s+property=["'']og:.*?["''].*?>', '')
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<meta\s+name=["'']twitter:.*?["''].*?>', '')
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<meta\s+name=["'']description["''].*?>', '')
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<meta\s+content=["''].*?["'']\s+name=["'']description["''].*?>', '')
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<script\s+type=["'']application/ld\+json["''].*?>.*?</script>', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

    # 2. Extract title
    $titleMatch = [System.Text.RegularExpressions.Regex]::Match($content, '(?i)<title>(.*?)</title>')
    $rawTitle = "Brand Title Placeholder"
    if ($titleMatch.Success) {
        $rawTitle = $titleMatch.Groups[1].Value.Trim()
    }
    
    # Ensure title contains brand
    $brandSuff = " - " + $templatesDb.settings.brand_name
    if (-not $rawTitle.Contains($brandSuff) -and -not $isRoot) {
        # Clean old brand suffixes
        $cleanTitle = $rawTitle
        foreach ($suff in $templatesDb.settings.brand_suffixes) {
            $cleanTitle = $cleanTitle -replace $suff, ""
        }
        $titleTagVal = "$cleanTitle$brandSuff"
    } else {
        $titleTagVal = $rawTitle -replace "jichang365.com", $templatesDb.settings.brand_name
    }

    # Replace Title Tag
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)<title>.*?</title>', "<title>$titleTagVal</title>")

    # 3. Generate description
    $desc = $templatesDb.settings.default_description -f ($titleTagVal -split " - ")[0]
    if ($filename -eq "index.html" -and $isRoot) {
        $desc = $templatesDb.settings.home_description
    } elseif ($filename -eq "ranking.html" -and $isRoot) {
        $desc = $templatesDb.settings.ranking_description
    } elseif ($filename -eq "airports.html" -and $isRoot) {
        $desc = $templatesDb.settings.airports_description
    }

    # Determine Canonical URL
    $pathSuffix = if ($isRoot) { $filename } else { "articles/$filename" }
    $canonicalUrl = if ($filename -eq "index.html" -and $isRoot) { "$baseUrl/" } else { "$baseUrl/$pathSuffix" }

    # 4. Build Meta and OG Tags
    $seoMetaTags = @"
  <link rel="canonical" href="$canonicalUrl">
  <meta name="description" content="$desc">
  <meta property="og:type" content="article">
  <meta property="og:url" content="$canonicalUrl">
  <meta property="og:title" content="$titleTagVal">
  <meta property="og:description" content="$desc">
  <meta property="og:image" content="$baseUrl/assets/images/new_logo.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$titleTagVal">
  <meta name="twitter:description" content="$desc">
  <meta name="twitter:image" content="$baseUrl/assets/images/new_logo.png">
"@

    # Inject Meta Tags right before </head>
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)</head>', "$seoMetaTags`n</head>")

    # 5. Build Structured Schema (JSON-LD)
    $lastModTime = [System.IO.File]::GetLastWriteTime($filePath).ToString("yyyy-MM-ddTHH:mm:ss+08:00")
    
    # 5.1 Article Schema
    $articleSchema = @{
        "@context" = "https://schema.org"
        "@type" = "Article"
        "headline" = ($titleTagVal -split " - ")[0]
        "description" = $desc
        "image" = "$baseUrl/assets/images/new_logo.png"
        "datePublished" = "2026-06-22T08:00:00+08:00"
        "dateModified" = $lastModTime
        "author" = @{
            "@type" = "Organization"
            "name" = $templatesDb.settings.author_name
            "url" = "$baseUrl/about.html"
        }
        "publisher" = @{
            "@type" = "Organization"
            "name" = $templatesDb.settings.brand_name
            "logo" = @{
                "@type" = "ImageObject"
                "url" = "$baseUrl/assets/images/new_logo.png"
            }
        }
    }

    # 5.2 Breadcrumb Schema
    $categoryName = $templatesDb.settings.category_mappings.default_name
    $categoryUrl = "$baseUrl/knowledge.html"
    if ($filename.StartsWith("tutorial-")) {
        $categoryName = $templatesDb.settings.category_mappings.tutorial_name
        $categoryUrl = "$baseUrl/knowledge.html"
    } elseif ($filename.StartsWith("beginner-")) {
        $categoryName = $templatesDb.settings.category_mappings.beginner_name
        $categoryUrl = "$baseUrl/knowledge.html"
    } elseif ($filename.StartsWith("nav-")) {
        $categoryName = $templatesDb.settings.category_mappings.nav_name
        $categoryUrl = "$baseUrl/knowledge.html"
    } elseif ($filename -in @("edgenova.html", "guangnianti.html", "huanyuyun.html", "jilianyun.html", "kexinyun.html", "kuaili.html", "shunyun.html", "sujie.html")) {
        $categoryName = $templatesDb.settings.category_mappings.review_name
        $categoryUrl = "$baseUrl/airports.html"
    }

    $breadcrumbSchema = @{
        "@context" = "https://schema.org"
        "@type" = "BreadcrumbList"
        "itemListElement" = @(
            @{
                "@type" = "ListItem"
                "position" = 1
                "name" = $templatesDb.settings.breadcrumb_home
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
                "name" = ($titleTagVal -split " - ")[0]
                "item" = $canonicalUrl
            }
        )
    }

    # 5.3 FAQ Schema
    $faqSchema = $null
    $faqsList = @()
    if ($faqsDb.custom_faqs.$filename) {
        $faqsList = $faqsDb.custom_faqs.$filename
    } elseif (-not $isRoot -and $categoryName -eq $templatesDb.settings.category_mappings.review_name) {
        $faqsList = $faqsDb.airport_faqs
    }

    if ($faqsList.Count -gt 0) {
        $mainEntities = @()
        foreach ($faq in $faqsList) {
            $mainEntities += @{
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
            "mainEntity" = $mainEntities
        }
    }

    # Build schema block scripts
    $articleSchemaJson = $articleSchema | ConvertTo-Json -Depth 5
    $breadcrumbSchemaJson = $breadcrumbSchema | ConvertTo-Json -Depth 5
    
    $schemaScripts = @"
  <script type="application/ld+json">
$articleSchemaJson
  </script>
  <script type="application/ld+json">
$breadcrumbSchemaJson
  </script>
"@

    if ($null -ne $faqSchema) {
        $faqSchemaJson = $faqSchema | ConvertTo-Json -Depth 5
        $schemaScripts += @"
  <script type="application/ld+json">
$faqSchemaJson
  </script>
"@
    }

    # Inject Schemas before </head>
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)</head>', "$schemaScripts`n</head>")

    # 6. For Articles: Inject GEO definitions, related articles, visible FAQs and tag clouds
    if (-not $isRoot) {
        # Check if the article already contains our injected blocks to prevent duplicate injection
        $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?s)<!-- INJECTED_SEO_START -->.*?<!-- INJECTED_SEO_END -->', '')

        # Build Visible FAQs section
        $visibleFaqHtml = ""
        if ($faqsList.Count -gt 0) {
            $faqTitle = $templatesDb.labels.faq_title
            $visibleFaqHtml += "`n      <div class=`"article-faqs-block`" style=`"margin-top: 40px; padding: 25px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px;`">"
            $visibleFaqHtml += "`n        <h3 style=`"font-size: 1.3rem; color: #0f172a; font-weight: 800; margin-top: 0; margin-bottom: 20px; border-left: 4px solid #2563eb; padding-left: 10px;`">$faqTitle</h3>"
            foreach ($faq in $faqsList) {
                $qPrefix = $templatesDb.labels.faq_q_prefix
                $aPrefix = $templatesDb.labels.faq_a_prefix
                $visibleFaqHtml += @"
        <div class="faq-item" style="margin-bottom: 18px;">
          <h4 style="font-size: 1.05rem; font-weight: 800; color: #1e293b; margin: 0 0 6px 0;">$qPrefix$($faq.q)</h4>
          <p style="font-size: 0.95rem; color: #475569; line-height: 1.5; margin: 0;">$aPrefix$($faq.a)</p>
        </div>
"@
            }
            $visibleFaqHtml += "`n      </div>"
        }

        # Build GEO definitions content block for article-1.html to article-10.html
        $geoBlockHtml = ""
        if ($templatesDb.geo_content_blocks.$filename) {
            $geoData = $templatesDb.geo_content_blocks.$filename
            $geoTitles = $templatesDb.geo_titles
            $geoHeader = $templatesDb.labels.geo_header
            
            $geoBlockHtml = @"
      <div class="article-geo-block" style="margin-top: 40px; padding: 25px; border: 1px solid #fee2e2; background: #fff5f5; border-radius: 12px;">
        <h3 style="font-size: 1.3rem; color: #991b1b; font-weight: 800; margin-top: 0; margin-bottom: 20px; border-left: 4px solid #ef4444; padding-left: 10px;">$geoHeader</h3>
        
        <div style="margin-bottom: 15px;">
          <h4 style="font-size: 1.05rem; font-weight: 800; color: #991b1b; margin: 0 0 6px 0;">$($geoTitles.definition)</h4>
          <p style="font-size: 0.95rem; color: #7f1d1d; line-height: 1.5; margin: 0;">$($geoData.def)</p>
        </div>
        
        <div style="margin-bottom: 15px;">
          <h4 style="font-size: 1.05rem; font-weight: 800; color: #991b1b; margin: 0 0 6px 0;">$($geoTitles.mechanics)</h4>
          <p style="font-size: 0.95rem; color: #7f1d1d; line-height: 1.5; margin: 0;">$($geoData.mech)</p>
        </div>
        
        <div style="margin-bottom: 15px;">
          <h4 style="font-size: 1.05rem; font-weight: 800; color: #991b1b; margin: 0 0 6px 0;">$($geoTitles.advantages)</h4>
          <p style="font-size: 0.95rem; color: #7f1d1d; line-height: 1.5; margin: 0;">$($geoData.adv)</p>
        </div>
        
        <div>
          <h4 style="font-size: 1.05rem; font-weight: 800; color: #991b1b; margin: 0 0 6px 0;">$($geoTitles.applications)</h4>
          <p style="font-size: 0.95rem; color: #7f1d1d; line-height: 1.5; margin: 0;">$($geoData.app)</p>
        </div>
      </div>
"@
        }

        # Build Related Articles Section
        $relatedTitle = $templatesDb.labels.related_title
        # Load other articles dynamically
        $otherArticles = @()
        if ($filename.StartsWith("tutorial-")) {
            $otherArticles = $templatesDb.related_articles.tutorial
        } elseif ($filename.StartsWith("beginner-")) {
            $otherArticles = $templatesDb.related_articles.beginner
        } elseif ($categoryName -eq $templatesDb.settings.category_mappings.review_name) {
            $otherArticles = $templatesDb.related_articles.review
        } else {
            $otherArticles = $templatesDb.related_articles.default
        }

        $relatedHtml = @"
      <div class="article-related-block" style="margin-top: 40px; padding: 25px; border: 1px solid #e2e8f0; border-radius: 12px;">
        <h3 style="font-size: 1.2rem; color: #0f172a; font-weight: 800; margin-top: 0; margin-bottom: 15px;">$relatedTitle</h3>
        <ul style="padding-left: 20px; margin: 0; line-height: 1.8;">
"@
        foreach ($rel in $otherArticles) {
            if ($rel.url -ne $filename) {
                $relatedHtml += "`n          <li><a href=`"$($rel.url)`" style=`"color: #2563eb; text-decoration: none; font-weight: 600;`">$($rel.name)</a></li>"
            }
        }
        $relatedHtml += "`n        </ul>`n      </div>"

        # Build Injected tag cloud HTML
        $tagCloudHtml = @"
      <div class="article-tags-cloud" style="margin-top: 30px; display: flex; flex-wrap: wrap; gap: 8px;">
        <a href="../airports.html" style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; text-decoration: none; font-weight: 600;">$($templatesDb.labels.tag_airport)</a>
        <a href="../ranking.html" style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; text-decoration: none; font-weight: 600;">$($templatesDb.labels.tag_review)</a>
        <a href="../knowledge.html" style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; text-decoration: none; font-weight: 600;">$($templatesDb.labels.tag_network)</a>
        <a href="../knowledge.html" style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; text-decoration: none; font-weight: 600;">$($templatesDb.labels.tag_tutorial)</a>
        <a href="../knowledge.html" style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 15px; font-size: 0.8rem; text-decoration: none; font-weight: 600;">$($templatesDb.labels.tag_ai)</a>
      </div>
"@

        # Assemble the entire injected assets block
        $injectedBlock = @"
      <!-- INJECTED_SEO_START -->
      $geoBlockHtml
      $visibleFaqHtml
      $relatedHtml
      $tagCloudHtml
      <!-- INJECTED_SEO_END -->
"@

        # Inject into the article body. We locate '<div class="article-body" id="articleBody">' or '</div>' before script blocks
        # Let's inject right before '</article>'
        $content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?i)</article>', "$injectedBlock`n</article>")
    }

    # Clean links
    $content = Clean-HtmlLinks($content)

    # Compress 3+ consecutive blank lines to 1 blank line
    $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(\r?\n[ \t]*){3,}", "`r`n`r`n")

    # Save file back in UTF-8 no BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
}

# Run loop over articles directory
$files = Get-ChildItem -Path $articlesDir -Filter *.html
foreach ($file in $files) {
    Process-File $file.FullName $file.Name $false
}

# Run loop over root directory files
$rootPages = @("ranking.html", "airports.html", "knowledge.html", "about.html", "article.html", "avoid-scam.html")
foreach ($page in $rootPages) {
    $filePath = Join-Path $baseDir $page
    if (Test-Path $filePath) {
        Process-File $filePath $page $true
    }
}

Write-Output "All metadata and schema injections executed successfully!"
