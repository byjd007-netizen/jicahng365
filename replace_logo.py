import os
import glob

directory = r"c:\Users\Administrator\Desktop\博客"
html_files = glob.glob(os.path.join(directory, "**", "*.html"), recursive=True)

count = 0
for file_path in html_files:
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    original = content
    
    # Replace logic
    content = content.replace('<span class="logo-text gradient-text">便宜机场测评</span>', '<span class="logo-text" style="color: var(--accent-primary); font-weight: bold;">云轨导航</span>')
    content = content.replace('便宜机场测评', '云轨导航')
    content = content.replace('blog_logo_light_1782126875936.png', 'yungui_logo_1782127474781.png')
    
    if content != original:
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)
        count += 1
        print(f"Updated {os.path.basename(file_path)}")

print(f"\nTotal files updated: {count}")
