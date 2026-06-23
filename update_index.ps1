$index_path = ".\index.html"
$content = [System.IO.File]::ReadAllText($index_path, [System.Text.Encoding]::UTF8)

$target = @"
      <!-- Recommend: 光年梯 (Right) -->
      <a href="articles/guangnianti.html" class="kb-card card-bg-3">
        <div class="kb-icon" style="font-size: 2rem;">⚡</div>
        <h3>光年梯</h3>
        <p>专为极客打造的轻量级代理，支持最新 Hysteria2 及 VLESS 协议。抗封锁能力极强，晚高峰依然坚挺。</p>
      </a>

    </div>
  </section>
"@

$replacement = @"
      <!-- Recommend: 光年梯 (Right) -->
      <a href="articles/guangnianti.html" class="kb-card card-bg-3">
        <div class="kb-icon" style="font-size: 2rem;">⚡</div>
        <h3>光年梯</h3>
        <p>专为极客打造的轻量级代理，支持最新 Hysteria2 及 VLESS 协议。抗封锁能力极强，晚高峰依然坚挺。</p>
      </a>

    </div>
    <div style="text-align: center; margin-top: 35px;">
      <a href="airports.html" class="action-btn" style="background: white; color: var(--text-primary); border: 1px solid var(--border-color); padding: 12px 30px; font-size: 1.05rem; transition: all 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05); text-decoration: none; display: inline-block;">查看全部机场评测 &rarr;</a>
    </div>
  </section>
"@

$content = $content.Replace($target, $replacement)

[System.IO.File]::WriteAllText($index_path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Updated index.html button successfully"
