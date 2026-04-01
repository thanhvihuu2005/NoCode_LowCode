/**
 * TravelWise Comments System
 */

// Mock comments data
const COMMENTS_DATA = {
  hotel: {
    1: [
      {
        id: 'c1',
        userId: 'USR-001',
        userName: 'Nguyễn Văn A',
        userAvatar: '👨‍💼',
        rating: 5,
        comment: 'Khách sạn rất tuyệt vời! Phòng sạch sẽ, nhân viên thân thiện. Tôi sẽ quay lại lần sau.',
        date: '2024-03-15',
        likes: 12,
        helpful: true,
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400'
        ]
      },
      {
        id: 'c2',
        userId: 'USR-002',
        userName: 'Trần Thị B',
        userAvatar: '👩‍💻',
        rating: 4,
        comment: 'Vị trí thuận tiện, gần biển. Tuy nhiên giá hơi cao so với chất lượng.',
        date: '2024-03-10',
        likes: 8,
        helpful: false,
        images: []
      }
    ]
  },
  tour: {
    1: [
      {
        id: 't1',
        userId: 'USR-003',
        userName: 'Lê Văn C',
        userAvatar: '🧑‍🎨',
        rating: 5,
        comment: 'Tour tuyệt vời! Hướng dẫn viên nhiệt tình, lịch trình hợp lý. Cảnh đẹp không thể tả được.',
        date: '2024-03-12',
        likes: 15,
        helpful: true,
        images: [
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=400',
          'https://images.unsplash.com/photo-1531310197839-ccf54634509e?w=400',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400'
        ]
      }
    ]
  }
};

class CommentsSystem {
  constructor(type, itemId) {
    this.type = type; // 'hotel' or 'tour'
    this.itemId = itemId;
    this.comments = COMMENTS_DATA[type]?.[itemId] || [];
    this.currentUser = getUser();
  }

  render(containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;

    const commentsHTML = `
      <div class="bg-white rounded-2xl border border-slate-200 p-6">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-bold text-slate-800">
            💬 Đánh giá từ khách hàng (${this.comments.length})
          </h3>
          <div class="flex items-center gap-2">
            <span class="text-2xl">⭐</span>
            <span class="font-bold text-lg">${this.getAverageRating()}</span>
            <span class="text-slate-500 text-sm">(${this.comments.length} đánh giá)</span>
          </div>
        </div>

        <!-- Rating breakdown -->
        <div class="mb-6 p-4 bg-slate-50 rounded-xl">
          <div class="grid grid-cols-5 gap-2 text-xs">
            ${[5,4,3,2,1].map(star => {
              const count = this.comments.filter(c => c.rating === star).length;
              const percentage = this.comments.length ? (count / this.comments.length * 100) : 0;
              return `
                <div class="flex items-center gap-2">
                  <span class="w-8">${star}⭐</span>
                  <div class="flex-1 bg-slate-200 rounded-full h-2">
                    <div class="bg-yellow-400 h-2 rounded-full" style="width: ${percentage}%"></div>
                  </div>
                  <span class="w-8 text-slate-500">${count}</span>
                </div>
              `;
            }).join('')}
          </div>
        </div>

        <!-- Write review section -->
        ${this.currentUser ? this.renderWriteReview() : this.renderLoginPrompt()}

        <!-- Comments list -->
        <div class="space-y-4">
          ${this.comments.map(comment => this.renderComment(comment)).join('')}
        </div>

        ${this.comments.length === 0 ? `
          <div class="text-center py-12 text-slate-400">
            <div class="text-4xl mb-2">💭</div>
            <p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
          </div>
        ` : ''}
      </div>
    `;

    container.innerHTML = commentsHTML;
    this.bindEvents();
  }

  renderWriteReview() {
    return `
      <div class="mb-6 p-4 border border-slate-200 rounded-xl">
        <h4 class="font-semibold mb-3">✍️ Viết đánh giá của bạn</h4>
        <form id="review-form" class="space-y-3">
          <!-- Rating stars -->
          <div class="flex items-center gap-2">
            <span class="text-sm font-medium">Đánh giá:</span>
            <div class="flex gap-1" id="rating-stars">
              ${[1,2,3,4,5].map(star => `
                <button type="button" class="rating-star text-2xl text-slate-300 hover:text-yellow-400 transition-colors" data-rating="${star}">⭐</button>
              `).join('')}
            </div>
            <span id="rating-text" class="text-sm text-slate-500 ml-2"></span>
          </div>

          <!-- Comment text -->
          <textarea 
            id="review-text" 
            placeholder="Chia sẻ trải nghiệm của bạn..." 
            class="w-full border border-slate-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400 resize-none"
            rows="3"
          ></textarea>

          <!-- Image upload -->
          <div class="flex items-center gap-3">
            <label class="flex items-center gap-2 text-sm text-slate-600 cursor-pointer hover:text-blue-600">
              <input type="file" multiple accept="image/*" id="review-images" class="hidden">
              📷 Thêm ảnh
            </label>
            <div id="image-preview" class="flex gap-2"></div>
          </div>

          <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 py-2 rounded-lg text-sm transition-colors">
            📝 Gửi đánh giá
          </button>
        </form>
      </div>
    `;
  }

  renderLoginPrompt() {
    return `
      <div class="mb-6 p-4 border border-slate-200 rounded-xl text-center">
        <p class="text-slate-600 mb-3">Đăng nhập để viết đánh giá</p>
        <a href="login.html" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 py-2 rounded-lg text-sm transition-colors">
          🔑 Đăng nhập
        </a>
      </div>
    `;
  }

  renderComment(comment) {
    const timeAgo = this.getTimeAgo(comment.date);
    
    return `
      <div class="border border-slate-200 rounded-xl p-4">
        <div class="flex items-start gap-3">
          <!-- User avatar -->
          <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center text-lg flex-shrink-0">
            ${comment.userAvatar}
          </div>
          
          <div class="flex-1">
            <!-- User info and rating -->
            <div class="flex items-center justify-between mb-2">
              <div>
                <h5 class="font-semibold text-slate-800">${comment.userName}</h5>
                <div class="flex items-center gap-2 text-sm text-slate-500">
                  <div class="flex">
                    ${[1,2,3,4,5].map(star => `
                      <span class="${star <= comment.rating ? 'text-yellow-400' : 'text-slate-300'}">⭐</span>
                    `).join('')}
                  </div>
                  <span>•</span>
                  <span>${timeAgo}</span>
                </div>
              </div>
              ${comment.helpful ? '<span class="bg-green-100 text-green-700 text-xs px-2 py-1 rounded-full font-medium">✓ Hữu ích</span>' : ''}
            </div>

            <!-- Comment text -->
            <p class="text-slate-700 mb-3 leading-relaxed">${comment.comment}</p>

            <!-- Comment images -->
            ${comment.images && comment.images.length > 0 ? `
              <div class="flex gap-2 mb-3">
                ${comment.images.map((img, index) => `
                  <button 
                    onclick="openCommentImages('${comment.id}', ${index})"
                    class="w-20 h-20 rounded-lg overflow-hidden border border-slate-200 hover:border-blue-400 transition-colors"
                  >
                    <img src="${img}" alt="Review image" class="w-full h-full object-cover">
                  </button>
                `).join('')}
              </div>
            ` : ''}

            <!-- Comment actions -->
            <div class="flex items-center gap-4 text-sm">
              <button class="flex items-center gap-1 text-slate-500 hover:text-blue-600 transition-colors">
                👍 Hữu ích (${comment.likes})
              </button>
              <button class="text-slate-500 hover:text-blue-600 transition-colors">
                💬 Trả lời
              </button>
              <button class="text-slate-500 hover:text-red-600 transition-colors">
                🚩 Báo cáo
              </button>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  bindEvents() {
    // Rating stars
    const stars = document.querySelectorAll('.rating-star');
    const ratingText = document.getElementById('rating-text');
    let selectedRating = 0;

    stars.forEach(star => {
      star.addEventListener('click', () => {
        selectedRating = parseInt(star.dataset.rating);
        this.updateStarDisplay(stars, selectedRating);
        ratingText.textContent = this.getRatingText(selectedRating);
      });

      star.addEventListener('mouseenter', () => {
        const hoverRating = parseInt(star.dataset.rating);
        this.updateStarDisplay(stars, hoverRating);
        ratingText.textContent = this.getRatingText(hoverRating);
      });
    });

    document.getElementById('rating-stars')?.addEventListener('mouseleave', () => {
      this.updateStarDisplay(stars, selectedRating);
      ratingText.textContent = selectedRating ? this.getRatingText(selectedRating) : '';
    });

    // Review form
    const reviewForm = document.getElementById('review-form');
    reviewForm?.addEventListener('submit', (e) => {
      e.preventDefault();
      this.submitReview(selectedRating);
    });

    // Image upload
    const imageInput = document.getElementById('review-images');
    imageInput?.addEventListener('change', (e) => {
      this.handleImageUpload(e.target.files);
    });
  }

  updateStarDisplay(stars, rating) {
    stars.forEach((star, index) => {
      if (index < rating) {
        star.classList.remove('text-slate-300');
        star.classList.add('text-yellow-400');
      } else {
        star.classList.remove('text-yellow-400');
        star.classList.add('text-slate-300');
      }
    });
  }

  getRatingText(rating) {
    const texts = {
      1: 'Rất tệ',
      2: 'Tệ', 
      3: 'Bình thường',
      4: 'Tốt',
      5: 'Xuất sắc'
    };
    return texts[rating] || '';
  }

  submitReview(rating) {
    const reviewText = document.getElementById('review-text').value.trim();
    
    if (!rating) {
      showToast('Vui lòng chọn số sao đánh giá!', 'error');
      return;
    }
    
    if (!reviewText) {
      showToast('Vui lòng nhập nội dung đánh giá!', 'error');
      return;
    }

    // Add new comment
    const newComment = {
      id: 'new-' + Date.now(),
      userId: this.currentUser.id,
      userName: this.currentUser.name,
      userAvatar: this.currentUser.name.charAt(0).toUpperCase(),
      rating: rating,
      comment: reviewText,
      date: new Date().toISOString().split('T')[0],
      likes: 0,
      helpful: false,
      images: [] // In real app, handle image upload
    };

    this.comments.unshift(newComment);
    showToast('✅ Đánh giá của bạn đã được gửi!');
    
    // Re-render comments
    this.render('comments-section');
  }

  handleImageUpload(files) {
    const preview = document.getElementById('image-preview');
    preview.innerHTML = '';

    Array.from(files).slice(0, 5).forEach((file, index) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.createElement('div');
        img.className = 'relative w-16 h-16 rounded-lg overflow-hidden border border-slate-200';
        img.innerHTML = `
          <img src="${e.target.result}" class="w-full h-full object-cover">
          <button onclick="this.parentElement.remove()" class="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white rounded-full text-xs">×</button>
        `;
        preview.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  }

  getAverageRating() {
    if (this.comments.length === 0) return '0.0';
    const sum = this.comments.reduce((acc, comment) => acc + comment.rating, 0);
    return (sum / this.comments.length).toFixed(1);
  }

  getTimeAgo(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffTime = Math.abs(now - date);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 1) return 'Hôm qua';
    if (diffDays < 7) return `${diffDays} ngày trước`;
    if (diffDays < 30) return `${Math.floor(diffDays / 7)} tuần trước`;
    return `${Math.floor(diffDays / 30)} tháng trước`;
  }
}

// Helper function to open comment images in lightbox
function openCommentImages(commentId, startIndex) {
  const comment = Object.values(COMMENTS_DATA)
    .flatMap(type => Object.values(type))
    .flatMap(comments => comments)
    .find(c => c.id === commentId);
    
  if (comment && comment.images.length > 0) {
    const images = comment.images.map((img, index) => ({
      src: img,
      title: `Ảnh từ ${comment.userName}`,
      description: comment.comment.substring(0, 100) + '...'
    }));
    
    openLightbox(images, startIndex);
  }
}