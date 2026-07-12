document.addEventListener('DOMContentLoaded', () => {
  const mobileMenuBtn = document.getElementById('mobileMenuBtn');
  const navMenu = document.getElementById('navMenu');

  // Toggle mobile menu
  if (mobileMenuBtn && navMenu) {
    mobileMenuBtn.addEventListener('click', () => {
      navMenu.classList.toggle('active');
      if (navMenu.classList.contains('active')) {
        mobileMenuBtn.textContent = '';
      } else {
        mobileMenuBtn.textContent = '';
      }
    });
  }

  // Smooth scroll for anchor links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const targetId = this.getAttribute('href');
      if (targetId === '#') return;
      
      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        e.preventDefault();
        targetElement.scrollIntoView({
          behavior: 'smooth'
        });
        
        // Close mobile menu if open
        if (navMenu && navMenu.classList.contains('active')) {
          navMenu.classList.remove('active');
          mobileMenuBtn.textContent = '';
        }
      }
    });
  });

  // Add glassmorphism blur dynamically based on scroll
  const header = document.querySelector('.header');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      header.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.2)';
      header.style.borderBottom = '1px solid rgba(255, 255, 255, 0.05)';
    } else {
      header.style.boxShadow = 'none';
      header.style.borderBottom = '1px solid rgba(255, 255, 255, 0.1)';
    }
  });

  // FAQ Accordion Toggle
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const question = item.querySelector('.faq-question');
    if (question) {
      question.addEventListener('click', () => {
        const isActive = item.classList.contains('active');
        // Close other items
        faqItems.forEach(i => i.classList.remove('active'));
        // Toggle current item
        if (!isActive) {
          item.classList.add('active');
        }
      });
    }
  });

  // --- COMMENTS SYSTEM CODE START ---
  const defaultComments = {
    "index.html": [
      { name: "技术先锋", avatar: "J", time: "2 小时前", content: "云轨导航的文章写得太客观了，尤其是关于 IPLC 和 IEPL 的科普，把小白最容易混淆的概念讲得很透彻，收藏了！", likes: 24, replies: [] },
      { name: "网速飞快", avatar: "W", time: "5 小时前", content: "之前买了别的站长推荐的垃圾机场，天天断流。看了这里的避坑指南，换了 EdgeNova 专线，晚高峰看 4K 极速流畅，太爽了！", likes: 18, replies: [] },
      { name: "小火箭初学者", avatar: "X", time: "1 天前", content: "请问那个 Shadowrocket (小火箭) 的节点怎么配置订阅啊？找了好多教程都不如这里的详细，照着配置一次就成功了！", likes: 9, replies: [
        { name: "云轨编辑组", avatar: "编", isEditor: true, time: "18 小时前", content: "不客气！可以关注我们的‘客户端教程’板块，里面有针对 iOS、Windows、macOS 和 Android 的最全配置说明。" }
      ]}
    ],
    "sujie.html": [
      { name: "游戏狂人", avatar: "Y", time: "3 小时前", content: "速界的 IPLC 专线打游戏确实爽，打 APEX 丢包率几乎是 0，延迟只有 40ms 左右，强烈推荐给需要联机的朋友！", likes: 15, replies: [] },
      { name: "白天不懂夜的黑", avatar: "B", time: "8 小时前", content: "买了他家的月付套餐试试水，高峰期看 Netflix 4K 的加载速度很快，比我之前的普通中转要强不少。", likes: 7, replies: [] }
    ],
    "edgenova.html": [
      { name: "学术研究员", avatar: "X", time: "1 小时前", content: "这家的流媒体 and ChatGPT 解锁非常完美，每次用都很顺利，适合我们需要查资料写论文的用户，稳定性首选。", likes: 32, replies: [] },
      { name: "网络搬砖工", avatar: "W", time: "4 小时前", content: "EdgeNova 算是老牌子的天花板了，除了价格稍微贵一点，稳定性没得说，适合作为主力机场使用。", likes: 14, replies: [] }
    ],
    "guangnianti.html": [
      { name: "追剧达人", avatar: "Z", time: "2 小时前", content: "光年梯的节点比较多，特别是亚太地区的节点，看 Disney+ 和 YouTube 4k 完全不卡，性价比很高！", likes: 11, replies: [] }
    ],
    "huanyuyun.html": [
      { name: "大流量用户", avatar: "D", time: "6 小时前", content: "寰宇云的限速给得很宽，大带宽下载大文件或者看高清视频都很舒服，中转入口也很稳定。", likes: 19, replies: [] }
    ],
    "jilianyun.html": [
      { name: "性价比之王", avatar: "J", time: "1 天前", content: "极连云的十元档套餐是真的香，节点多速度也不慢，对学生党或者轻度科学上网用户来说无敌了。", likes: 21, replies: [] }
    ],
    "kexinyun.html": [
      { name: "备用小能手", avatar: "B", time: "12 小时前", content: "可信云的稳定性不错，用来做主力或者备用都很合适，这篇评测的数据很客观，给博主点赞！", likes: 8, replies: [] }
    ],
    "shunyun.html": [
      { name: "快意恩仇", avatar: "K", time: "2 天前", content: "瞬云的按量计费套餐很划算，平时用得少的人买这个最省钱了，不用担心月度流量过期清零。", likes: 13, replies: [] }
    ]
  };

  const generalComments = [
    { name: "网络安全新手", avatar: "W", time: "4 小时前", content: "跟着教程一步步配置好了，Clash Verge 用起来比之前的客户端要顺手很多，多谢博主分享！", likes: 12, replies: [] },
    { name: "爱思考的猫", avatar: "A", time: "1 天前", content: "请问一下，TUN 模式和普通系统代理模式相比，除了流量接管更全，会对网速有明显影响吗？", likes: 6, replies: [
      { name: "云轨编辑组", avatar: "编", isEditor: true, time: "20 小时前", content: "通常情况下对网速没有可感知的负面影响，反而因为接管了所有底层流量，对很多不支持代理的软件和游戏非常有帮助。" }
    ]}
  ];

  function getPageKey() {
    let path = window.location.pathname;
    let filename = path.substring(path.lastIndexOf('/') + 1);
    if (filename === '' || filename === 'index.html') {
      return 'index.html';
    }
    return filename;
  }

  function getRandomAvatarColor() {
    const colors = [
      '#3b82f6', '#10b981', '#f59e0b', '#ef4444', 
      '#8b5cf6', '#ec4899', '#06b6d4', '#14b8a6'
    ];
    return colors[Math.floor(Math.random() * colors.length)];
  }

  function initComments() {
    const pageKey = getPageKey();
    if (pageKey === '404.html' || pageKey === 'left.html') return;

    // Determine target location for the comments section
    let commentsContainer = document.createElement('div');
    commentsContainer.id = "comments-section";
    commentsContainer.className = "comments-section-container";

    let articleBox = document.querySelector('.article-box') || document.querySelector('article');
    let mainCol = document.querySelector('main');
    
    if (articleBox) {
      articleBox.appendChild(commentsContainer);
    } else if (mainCol) {
      let cta = document.querySelector('.bottom-cta-banner-section');
      if (cta) {
        cta.parentNode.insertBefore(commentsContainer, cta.nextSibling);
      } else {
        mainCol.appendChild(commentsContainer);
      }
    } else {
      document.body.appendChild(commentsContainer);
    }

    // Load comments from LocalStorage or use defaults
    let storageKey = "comments_" + pageKey;
    let comments = localStorage.getItem(storageKey);
    if (comments) {
      comments = JSON.parse(comments);
    } else {
      comments = defaultComments[pageKey] || generalComments;
      localStorage.setItem(storageKey, JSON.stringify(comments));
    }

    // Render function
    function renderComments() {
      let totalCount = 0;
      comments.forEach(c => {
        totalCount += 1;
        if (c.replies) totalCount += c.replies.length;
      });

      commentsContainer.innerHTML = `
        <div class="comments-header">
          <h2 class="comments-title">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            自由讨论与意见提交
          </h2>
          <span class="comments-count-badge">${totalCount} 条评论</span>
        </div>
        
        <form class="comment-form" id="commentForm">
          <div class="comment-textarea-wrapper">
            <textarea class="comment-textarea" id="commentText" placeholder="分享您的使用体验或提交技术疑问，本站编辑与读者将实时为您解答..." required maxLength="500"></textarea>
          </div>
          <div class="comment-form-inputs">
            <input type="text" class="comment-input-field" id="commentAuthor" placeholder="您的昵称 (必填)" required maxLength="20" />
            <input type="email" class="comment-input-field" id="commentEmail" placeholder="您的邮箱 (可选，用于接收回复提醒)" maxLength="50" />
          </div>
          <div class="comment-submit-row">
            <span class="comment-note">遵守网络文明，评论支持匿名发表</span>
            <button type="submit" class="comment-submit-btn">提交评论</button>
          </div>
        </form>

        <div class="comments-list">
          ${comments.map((comment, index) => {
            const avatarColor = comment.isEditor ? '#ef4444' : getRandomAvatarColor();
            return `
              <div class="comment-item">
                <div class="comment-avatar" style="background-color: ${avatarColor}">
                  ${comment.avatar || (comment.name ? comment.name.substring(0,1).toUpperCase() : '匿')}
                </div>
                <div class="comment-content">
                  <div class="comment-meta">
                    <span class="comment-author-name">${comment.name}</span>
                    ${comment.isEditor ? `<span class="comment-editor-badge">官方编辑</span>` : ''}
                    <span class="comment-time">${comment.time}</span>
                  </div>
                  <p class="comment-body">${comment.content}</p>
                  <div class="comment-actions">
                    <button class="comment-action-btn like-btn" data-index="${index}">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/></svg>
                      赞 (${comment.likes || 0})
                    </button>
                    <button class="comment-action-btn reply-trigger" data-index="${index}">
                      回复
                    </button>
                  </div>
                  
                  ${comment.replies && comment.replies.length > 0 ? `
                    <div class="comment-replies">
                      ${comment.replies.map(reply => {
                        const replyAvatarColor = reply.isEditor ? '#ef4444' : getRandomAvatarColor();
                        return `
                          <div class="comment-reply-item">
                            <div class="comment-reply-avatar" style="background-color: ${replyAvatarColor}">
                              ${reply.avatar || (reply.name ? reply.name.substring(0,1).toUpperCase() : '匿')}
                            </div>
                            <div class="comment-reply-content">
                              <div class="comment-meta">
                                <span class="comment-author-name">${reply.name}</span>
                                ${reply.isEditor ? `<span class="comment-editor-badge">官方编辑</span>` : ''}
                                <span class="comment-time">${reply.time}</span>
                              </div>
                              <p class="comment-body">${reply.content}</p>
                            </div>
                          </div>
                        `;
                      }).join('')}
                    </div>
                  ` : ''}
                </div>
              </div>
            `;
          }).join('')}
        </div>
      `;

      // Form submission handler
      const form = document.getElementById('commentForm');
      form.addEventListener('submit', function(e) {
        e.preventDefault();
        const text = document.getElementById('commentText').value.trim();
        const author = document.getElementById('commentAuthor').value.trim();
        const email = document.getElementById('commentEmail').value.trim();

        if (!text || !author) return;

        const newComment = {
          name: author,
          avatar: author.substring(0,1).toUpperCase(),
          time: "刚刚",
          content: text,
          likes: 0,
          replies: []
        };

        comments.unshift(newComment);
        localStorage.setItem(storageKey, JSON.stringify(comments));
        
        document.getElementById('commentText').value = '';
        renderComments();
      });

      // Like button handler
      const likeButtons = commentsContainer.querySelectorAll('.like-btn');
      likeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
          const index = parseInt(this.getAttribute('data-index'));
          if (isNaN(index) || !comments[index]) return;
          
          if (this.classList.contains('liked')) {
            comments[index].likes = (comments[index].likes || 1) - 1;
            this.classList.remove('liked');
          } else {
            comments[index].likes = (comments[index].likes || 0) + 1;
            this.classList.add('liked');
          }
          localStorage.setItem(storageKey, JSON.stringify(comments));
          renderComments();
        });
      });

      // Reply handler
      const replyTriggers = commentsContainer.querySelectorAll('.reply-trigger');
      replyTriggers.forEach(trigger => {
        trigger.addEventListener('click', function() {
          const index = parseInt(this.getAttribute('data-index'));
          if (isNaN(index) || !comments[index]) return;
          
          const parent = this.closest('.comment-content');
          let existingForm = parent.querySelector('.reply-box-form');
          if (existingForm) {
            existingForm.remove();
            return;
          }

          const replyForm = document.createElement('div');
          replyForm.className = 'reply-box-form';
          replyForm.style.marginTop = '12px';
          replyForm.style.display = 'flex';
          replyForm.style.flexDirection = 'column';
          replyForm.style.gap = '8px';
          replyForm.innerHTML = `
            <textarea class="comment-textarea" id="replyText" placeholder="输入您的回复..." style="min-height: 60px; padding: 10px;" required></textarea>
            <div style="display:flex; gap:10px;">
              <input type="text" class="comment-input-field" id="replyAuthor" placeholder="您的昵称" style="padding: 6px 12px; flex: 1;" required />
              <button class="comment-submit-btn" id="submitReplyBtn" style="padding: 6px 16px; font-size: 0.85rem;">回复</button>
            </div>
          `;
          
          const repliesContainer = parent.querySelector('.comment-replies');
          if (repliesContainer) {
            parent.insertBefore(replyForm, repliesContainer);
          } else {
            parent.appendChild(replyForm);
          }

          const submitReplyBtn = replyForm.querySelector('#submitReplyBtn');
          submitReplyBtn.addEventListener('click', () => {
            const rText = replyForm.querySelector('#replyText').value.trim();
            const rAuthor = replyForm.querySelector('#replyAuthor').value.trim();

            if (!rText || !rAuthor) return;

            const newReply = {
              name: rAuthor,
              avatar: rAuthor.substring(0,1).toUpperCase(),
              time: "刚刚",
              content: rText
            };

            if (!comments[index].replies) {
              comments[index].replies = [];
            }
            comments[index].replies.push(newReply);
            localStorage.setItem(storageKey, JSON.stringify(comments));
            renderComments();
          });
        });
      });
    }

    renderComments();
  }

  initComments();
  // --- COMMENTS SYSTEM CODE END ---
});
