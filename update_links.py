import os
import re

articles_dir = r"c:\Users\Administrator\Desktop\博客\articles"
new_related_links = """<div class="related-links">
        <h3 style="margin-bottom: 1rem;">相关阅读推荐</h3>
        <a href="tutorial-ios.html">Shadowrocket iOS配置教程</a>
        <a href="tutorial-win.html">Clash Verge Windows使用指南</a>
        <a href="tutorial-and.html">v2rayNG安卓教程</a>
        <a href="beginner-1.html">机场订阅是什么意思？</a>
        <a href="article-1.html">节点测速方法详解</a>
        <a href="../airports.html">稳定机场推荐合集</a>
      </div>"""

count = 0
for file in os.listdir(articles_dir):
    if file.endswith(".html"):
        file_path = os.path.join(articles_dir, file)
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
        
        # Regex to match the related-links div and its contents
        # We need to make sure we only replace the innermost or the specific related links div
        pattern = re.compile(r'<div class="related-links">\s*<h3[^>]*>相关阅读推荐</h3>.*?</div>', re.DOTALL)
        
        if pattern.search(content):
            new_content = pattern.sub(new_related_links, content)
            
            if new_content != content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                count += 1
                print(f"Updated related links in {file}")

print(f"Total updated: {count}")
