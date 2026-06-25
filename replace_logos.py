import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Determine relative path prefix for assets
    is_article = 'articles' in filepath.replace('\\', '/')
    prefix = '../' if is_article else ''

    # Replace Header Logo
    # Match `<a ... class="logo-container" ...> ... </a>`
    header_pattern = r'(<a[^>]*class="logo-container"[^>]*>)\s*([\s\S]*?)\s*(</a>)'
    header_replacement = r'\1\n        <img src="{}assets/images/logo.png" alt="云轨导航 Logo" class="logo-img">\n        <span class="logo-text">云轨导航</span>\n      \3'.format(prefix)
    
    new_content = re.sub(header_pattern, header_replacement, content)

    # Replace Footer Logo
    # Match `<div class="footer-logo"> ... </div>`
    footer_pattern = r'(<div[^>]*class="footer-logo"[^>]*>)\s*([\s\S]*?)\s*(</div>)'
    footer_replacement = r'\1\n          <img src="{}assets/images/logo.png" alt="云轨导航 Logo" class="logo-img">\n          <span class="logo-text">云轨导航</span>\n        \3'.format(prefix)

    new_content = re.sub(footer_pattern, footer_replacement, new_content)
    
    # Add Favicon if not exists
    if '<link rel="icon"' not in new_content:
        # Add after <title> or <meta name="description">
        favicon_str = f'\n  <link rel="icon" href="{prefix}assets/images/logo.png" type="image/png">'
        new_content = re.sub(r'(</title>)', r'\1' + favicon_str, new_content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

if __name__ == "__main__":
    base_dir = r"c:\Users\Administrator\Desktop\博客"
    for root, dirs, files in os.walk(base_dir):
        if '.git' in root or 'node_modules' in root:
            continue
        for file in files:
            if file.endswith('.html'):
                process_file(os.path.join(root, file))
