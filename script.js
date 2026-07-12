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
    ]
  };

  function generateSeededComments(pageKey) {
    let seed = 0;
    for (let i = 0; i < pageKey.length; i++) {
      seed += pageKey.charCodeAt(i) * (i + 1);
    }

    function random() {
      let x = Math.sin(seed++) * 10000;
      return x - Math.floor(x);
    }

    function selectRandom(arr) {
      let index = Math.floor(random() * arr.length);
      return arr[index];
    }

    const names = ["科学探索者", "极客工坊", "追风少年", "学海无涯", "网络新手王", "游戏发烧友", "大白兔", "数字游民", "学术汪", "科技探路人", "行者无疆", "风口浪尖", "爱吃泡面的猫", "星河程序员", "云端旅行者"];
    const times = ["2 小时前", "5 小时前", "12 小时前", "1 天前", "2 天前", "3 天前", "4 天前"];

    // Detect airport name
    let airportName = "该机场";
    if (pageKey.includes("sujie")) airportName = "速界";
    else if (pageKey.includes("edgenova")) airportName = "EdgeNova";
    else if (pageKey.includes("guangnianti")) airportName = "光年梯";
    else if (pageKey.includes("huanyuyun")) airportName = "寰宇云";
    else if (pageKey.includes("jilianyun")) airportName = "极连云";
    else if (pageKey.includes("kexinyun")) airportName = "可信云";
    else if (pageKey.includes("shunyun")) airportName = "瞬云";
    else if (pageKey.includes("kuaili")) airportName = "快狸";

    const pools = {
      tutorial: [
        {
          name: "Clash粉丝",
          content: "请问下博主，这个配置在配置完规则之后，为什么部分国内网站也会走代理？是分流规则没选对吗？",
          replies: [{ name: "云轨编辑组", isEditor: true, content: "建议检查下客户端的代理模式，是否设置成了“全局模式(Global)”。日常使用推荐选择“规则模式(Rule)”，这样国内流量就会自动直连，不会消耗代理流量。" }]
        },
        {
          name: "苹果全家桶",
          content: "感谢博主，终于找到一篇把 Shadowrocket 配置讲得这么简单明了的教程了！之前折腾的好久都没成功，给站长点个赞！",
          replies: []
        },
        {
          name: "极客工坊",
          content: "Clash Verge 确实比旧版的好用很多，特别是支持新的内核，配置好 TUN 模式之后连一些不支持代理的客户端软件也能连上了，强推！",
          replies: []
        },
        {
          name: "学海无涯",
          content: "请问在安卓上用哪个客户端最稳定啊？目前在用 v2rayNG，感觉切换节点的时候有点卡顿。",
          replies: [{ name: "云轨编辑组", isEditor: true, content: "安卓平台目前首推 v2rayNG 作为基础版；如果需要更强的主题和分流策略组控制，可以尝试 Sing-box 或者 Clash Meta 系列。" }]
        }
      ],
      scam: [
        {
          name: "爱吃泡面的猫",
          content: "这个跑路雷达太及时了！最近正准备买个年付套餐，结果在这上面一查居然已经跑路或者失联了，差点交了学费，感谢博主！",
          replies: []
        },
        {
          name: "独行侠",
          content: "大家买机场千万别贪便宜买年付，特别是那些低价年付！很多机场都是收一波钱就跑路，月付才是王道！",
          replies: [{ name: "云轨编辑组", isEditor: true, content: "非常赞同！月付能最大程度降低用户的资金风险，即便跑路也只是损失一个月套餐钱。" }]
        },
        {
          name: "数字游民",
          content: "最近又有好几家老牌机场关站了，大家手里最好备一到两个按量计费的机场当做备用，防患于未然。",
          replies: []
        }
      ],
      review: [
        {
          name: "学术研究员",
          content: `这篇关于 ${airportName} 的评测很中肯。我用这家的套餐三个月了，晚高峰的 IPLC 专线确实很稳，看 4K 不卡。`,
          replies: []
        },
        {
          name: "游戏狂人",
          content: `请问 ${airportName} 现在的节点延迟一般是多少？玩海外服游戏丢包严重吗？`,
          replies: [{ name: "云轨编辑组", isEditor: true, content: "实测他家的专线节点平均延迟在 30-50ms 左右，丢包率基本为零，非常适合游戏联机和网页秒开。" }]
        },
        {
          name: "大流量用户",
          content: `用了一周，速度没得说，就是客户端订阅有时候更新失败，需要重新导入一下才行。`,
          replies: []
        }
      ],
      knowledge: [
        {
          name: "技术先锋",
          content: "这篇科普把 IPLC 和 IEPL 的物理链路区别讲得非常清楚。之前一直被各种机场商的宣传语唬住，现在终于明白原理了！",
          replies: []
        },
        {
          name: "行者无疆",
          content: "请问 BGP 中转入口和普通直连相比，优势主要体现在哪里？",
          replies: [{ name: "云轨编辑组", isEditor: true, content: "主要优势在于 BGP 入口可以自动根据用户网络（电信/联通/移动）分流，优化第一公里延迟，且中转网络的高带宽可以有效抵御高峰期丢包。" }]
        },
        {
          name: "科技探路人",
          content: "看完文章，终于知道为什么晚上八九点我的网络就变慢了。原来是公网国际出口拥堵，不得不服专线网络的稳定性。",
          replies: []
        }
      ]
    };

    // Determine category
    let cat = "knowledge";
    if (pageKey.includes("tutorial") || pageKey.includes("clash") || pageKey.includes("rocket") || pageKey.includes("v2rayn") || pageKey.includes("verge") || pageKey.includes("mac") || pageKey.includes("win") || pageKey.includes("ios") || pageKey.includes("and")) {
      cat = "tutorial";
    } else if (pageKey.includes("scam") || pageKey.includes("blacklist")) {
      cat = "scam";
    } else if (airportName !== "该机场") {
      cat = "review";
    }

    let pool = pools[cat];
    
    // Choose 2 distinct comments from the pool
    let selectedIndices = [];
    let attempts = 0;
    while (selectedIndices.length < Math.min(2, pool.length) && attempts < 10) {
      let idx = Math.floor(random() * pool.length);
      if (!selectedIndices.includes(idx)) {
        selectedIndices.push(idx);
      }
      attempts++;
    }

    let result = selectedIndices.map(idx => {
      let c = pool[idx];
      let name = c.name;
      if (random() > 0.5) {
        name = selectRandom(names);
      }
      let time = selectRandom(times);
      let likes = Math.floor(random() * 30) + 2;
      
      let replies = c.replies.map(r => {
        return {
          name: r.name,
          avatar: "编",
          isEditor: true,
          time: selectRandom(times),
          content: r.content
        };
      });

      return {
        name: name,
        avatar: name.substring(0, 1).toUpperCase(),
        time: time,
        content: c.content,
        likes: likes,
        replies: replies
      };
    });

    return result;
  }

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
      if (pageKey === 'index.html') {
        comments = defaultComments['index.html'];
      } else {
        comments = generateSeededComments(pageKey);
      }
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
