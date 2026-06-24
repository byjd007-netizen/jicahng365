import os
import re

directory = r"c:\Users\Administrator\Desktop\博客"

count = 0
for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith(".html"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
            
            original = content
            
            content = re.sub(
                r'<img[^>]*blog_logo_light_1782126875936\.png[^>]*>\s*<span class="logo-text gradient-text">便宜机场测评</span>',
                r'<span class="logo-text" style="color: var(--accent-primary); font-weight: bold;">云轨导航</span>',
                content
            )
            
            content = content.replace('<span class="logo-text gradient-text">便宜机场测评</span>', '<span class="logo-text" style="color: var(--accent-primary); font-weight: bold;">云轨导航</span>')
            content = content.replace('便宜机场测评', '云轨导航')
            content = content.replace('blog_logo_light_1782126875936.png', 'yungui_logo_1782127474781.png')
            
            if content != original:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(content)
                count += 1
                print(f"Updated {file_path}")

print(f"Total updated: {count}")
