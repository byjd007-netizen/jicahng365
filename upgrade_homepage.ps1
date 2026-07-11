$baseDir = "."
$htmlPath = Join-Path $baseDir "index.html"
$jsonPath = Join-Path $baseDir "homepage_faqs.json"
$configJsonPath = Join-Path $baseDir "homepage_upgrade_config.json"

# Load JSON configs with UTF8
$jsonContent = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$faqs = $jsonContent | ConvertFrom-Json

$configContent = [System.IO.File]::ReadAllText($configJsonPath, [System.Text.Encoding]::UTF8)
$config = $configContent | ConvertFrom-Json

# Load the current index.html content
$html = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# 1. Replace domain 'jichang365.com' with 'yunguidaohang.com'
$html = $html.Replace("jichang365.com", "yunguidaohang.com")

# 2. Replace the old redirect paths with real routes
$html = $html.Replace("airport-recommend/", "airport/")
$html = $html.Replace("airport-rank/", "review/")
$html = $html.Replace("clash-tutorial/", "tutorial/")
$html = $html.Replace("shadowrocket-tutorial/", "tutorial/")
$html = $html.Replace("client-download/", "articles/beginner-1.html")

# 3. Add styling for wiki cards, keyword tags, and FAQ adjustments in style block
$extraStyles = @"

    /* SEO & GEO Upgrade Styles */
    .seo-tags-section {
      background: #ffffff;
      padding: 30px 0;
      border-bottom: 1px solid #e2e8f0;
      text-align: center;
    }
    .seo-tags-title {
      font-size: 1.1rem;
      font-weight: 800;
      color: #0f172a;
      margin-bottom: 15px;
      letter-spacing: 0.5px;
    }
    .seo-tags-grid {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 12px;
      max-width: 900px;
      margin: 0 auto;
    }
    .seo-tag-link {
      background: #f1f5f9;
      color: #334155;
      font-size: 0.9rem;
      font-weight: 600;
      padding: 8px 16px;
      border-radius: 20px;
      text-decoration: none;
      transition: all 0.2s ease;
      border: 1px solid #e2e8f0;
    }
    .seo-tag-link:hover {
      background: #2563eb;
      color: #ffffff;
      border-color: #2563eb;
      transform: translateY(-1px);
    }
    
    .wiki-entries-section {
      background: #ffffff;
      padding: 60px 0;
      border-bottom: 1px solid #e2e8f0;
    }
    .wiki-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-top: 30px;
    }
    @media (max-width: 991px) {
      .wiki-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }
    @media (max-width: 576px) {
      .wiki-grid {
        grid-template-columns: 1fr;
      }
    }
    .wiki-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 24px;
      transition: all 0.3s ease;
      text-decoration: none;
      display: flex;
      flex-direction: column;
      text-align: left;
    }
    .wiki-card:hover {
      background: #ffffff;
      border-color: #2563eb;
      box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
      transform: translateY(-2px);
    }
    .wiki-card-q {
      font-size: 1.05rem;
      font-weight: 800;
      color: #0f172a;
      margin-bottom: 8px;
    }
    .wiki-card:hover .wiki-card-q {
      color: #2563eb;
    }
    .wiki-card-a {
      font-size: 0.9rem;
      color: #64748b;
      line-height: 1.5;
      flex-grow: 1;
    }
    .wiki-card-more {
      font-size: 0.85rem;
      font-weight: 700;
      color: #2563eb;
      margin-top: 15px;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .faq-v3-grid {
      grid-template-columns: 1fr !important;
      gap: 12px !important;
    }
    .faq-v3-item {
      margin-bottom: 0 !important;
    }
"@

# Inject styles before </style> in the index.html
$html = $html -replace "(</style>)", "$extraStyles`n`$1"

# 4. Inject Module 1 and Module 2
$module1Html = $config.module1_html
$module2Html = $config.module2_html
$html = $html -replace "(<!-- Stats Bar -->)", "$module1Html`n`$module2Html`n`$1"

# 5. Construct Module 3: 20 FAQ Accordions
$faqAccordionHtml = ""
foreach ($faq in $faqs) {
    $num = $faq.num
    $q = $faq.q
    $desc = $faq.desc
    $a = $faq.a
    $faqAccordionHtml += @"
              <!-- Item $num -->
              <details class="faq-v3-item" name="faq-acc">
                <summary class="faq-v3-q-box">
                  <div class="faq-v3-q-left">
                    <span class="faq-v3-num">$num</span>
                    <div class="faq-v3-q-text">
                      <span class="faq-v3-title">$q</span>
                      <span class="faq-v3-desc">$desc</span>
                    </div>
                  </div>
                  <span class="faq-v3-arrow"></span>
                </summary>
                <div class="faq-v3-answer">
                  $a
                </div>
              </details>
"@
}

$targetFaqBlockPattern = '(?s)<div class="faq-v3-grid">.*?</div>'
$replacementFaqBlock = "<div class=`"faq-v3-grid`">`n$faqAccordionHtml`n            </div>"
$html = [System.Text.RegularExpressions.Regex]::Replace($html, $targetFaqBlockPattern, $replacementFaqBlock)

# Replace the total question count text
$targetFaqText = $config.target_faq_text
$replaceFaqText = $config.replace_faq_text
$html = $html.Replace($targetFaqText, $replaceFaqText)

# 6. Generate FAQ Schema (JSON-LD)
$mainEntityArray = @()
foreach ($faq in $faqs) {
    $mainEntityArray += @{
        "@type" = "Question"
        "name" = $faq.q
        "acceptedAnswer" = @{
            "@type" = "Answer"
            "text" = $faq.a
        }
    }
}

$faqSchemaObj = @{
    "@context" = "https://schema.org"
    "@type" = "FAQPage"
    "mainEntity" = $mainEntityArray
}

$faqSchemaJson = $faqSchemaObj | ConvertTo-Json -Depth 5
$faqSchemaScript = @"
  <script type="application/ld+json">
$faqSchemaJson
  </script>
"@

# Inject FAQ schema right before </head>
$html = $html -replace "(</head>)", "$faqSchemaScript`n`$1"

# 7. Write index.html back with no-BOM UTF-8
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($htmlPath, $html, $utf8NoBom)
Write-Output "Successfully upgraded index.html!"
