$baseDir = "."
$htmlPath = Join-Path $baseDir "index.html"
$jsonPath = Join-Path $baseDir "homepage_faqs.json"
$configJsonPath = Join-Path $baseDir "homepage_upgrade_config.json"

# Load JSON configs with UTF8
$jsonContent = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$faqs = $jsonContent | ConvertFrom-Json

$configContent = [System.IO.File]::ReadAllText($configJsonPath, [System.Text.Encoding]::UTF8)
$config = $configContent | ConvertFrom-Json

# Restore index.html from layout-fix commit cf92b21 to start completely clean before applying changes
Write-Output "Restoring index.html to layout-fix commit cf92b21..."
& git checkout cf92b21 -- index.html

# Load the current index.html content
$html = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# Normalize newlines to LF for robust matching
$html = $html -replace "`r`n", "`n"
$oldFooterBlock = $config.old_footer_block -replace "`r`n", "`n"
$newFooterBlockTemplate = $config.new_footer_block -replace "`r`n", "`n"
$module1Html = $config.module1_html -replace "`r`n", "`n"
$module2Html = $config.module2_html -replace "`r`n", "`n"

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
    .faq-hidden-item-hide {
      display: none !important;
    }
"@

# Inject styles before </style> in the index.html
$html = $html.Replace("</style>", "$extraStyles`n</style>")

# 4. Inject Module 1 and Module 2 using literal Replace
$html = $html.Replace("<!-- Stats Bar -->", "$module1Html`n$module2Html`n<!-- Stats Bar -->")

# 5. Construct Module 3: 20 FAQ Accordions
$faqAccordionHtml = ""
$i = 0
foreach ($faq in $faqs) {
    $i++
    $num = $faq.num
    $q = $faq.q
    $desc = $faq.desc
    $a = $faq.a
    $classes = "faq-v3-item"
    $extraAttr = ""
    if ($i -gt 10) {
        $classes = "faq-v3-item faq-hidden-item faq-hidden-item-hide"
    }
    if ($i -eq 11) {
        $extraAttr = "id=`"faq-item-11`""
    }
    $faqAccordionHtml += @"
              <!-- Item $num -->
              <details class="$classes" name="faq-acc" $extraAttr>
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

# Match entire grid block up to the footer block using regex lookahead
$targetFaqBlockPattern = '(?s)<div class="faq-v3-grid">.*?(?=<div class="faq-v3-footer">)'
$replacementFaqBlock = "<div class=`"faq-v3-grid`">`n$faqAccordionHtml`n            </div>`n            `n            "
$html = [System.Text.RegularExpressions.Regex]::Replace($html, $targetFaqBlockPattern, $replacementFaqBlock)

# Replace the total question count text
$targetFaqText = $config.target_faq_text
$replaceFaqText = $config.replace_faq_text
$html = $html.Replace($targetFaqText, $replaceFaqText)

# Replace the footer block to contain the trigger button
$btnExpand = $config.btn_expand_text
$newFooterBlock = $newFooterBlockTemplate -f $btnExpand
$html = $html.Replace($oldFooterBlock, $newFooterBlock)

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
$html = $html.Replace("</head>", "$faqSchemaScript`n</head>")

# 7. Inject FAQ Toggle Micro-interaction script before </body>
$btnCollapse = $config.btn_collapse_text
$toggleScript = @"
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var toggleBtn = document.getElementById('faqToggleBtn');
      var hiddenItems = document.querySelectorAll('.faq-hidden-item');
      var btnExpandText = "$btnExpand";
      var btnCollapseText = "$btnCollapse";
      if (toggleBtn && hiddenItems.length > 0) {
        toggleBtn.addEventListener('click', function() {
          var isExpanded = toggleBtn.getAttribute('data-expanded') === 'true';
          if (isExpanded) {
            // Collapse
            hiddenItems.forEach(function(item) {
              item.classList.add('faq-hidden-item-hide');
            });
            toggleBtn.innerHTML = btnExpandText;
            toggleBtn.setAttribute('data-expanded', 'false');
          } else {
            // Expand
            hiddenItems.forEach(function(item) {
              item.classList.remove('faq-hidden-item-hide');
            });
            toggleBtn.innerHTML = btnCollapseText;
            toggleBtn.setAttribute('data-expanded', 'true');
            
            // Smooth scroll to item 11 (internal jump)
            var targetItem = document.getElementById('faq-item-11');
            if (targetItem) {
              setTimeout(function() {
                targetItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
              }, 80);
            }
          }
        });
      }
    });
  </script>
"@

$html = $html.Replace("</body>", "$toggleScript`n</body>")

# Normalize back to CRLF (Windows standard)
$html = $html -replace "`n", "`r`n"

# 8. Write index.html back with no-BOM UTF-8
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($htmlPath, $html, $utf8NoBom)
Write-Output "Successfully upgraded index.html with inline collapsed FAQ toggle link!"
