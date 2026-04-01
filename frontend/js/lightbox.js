/**
 * TravelWise Lightbox - Pure JavaScript Image Gallery
 */

class TravelWiseLightbox {
  constructor() {
    this.currentIndex = 0;
    this.images = [];
    this.isOpen = false;
    this.init();
  }

  init() {
    // Create lightbox HTML structure
    this.createLightboxHTML();
    this.bindEvents();
  }

  createLightboxHTML() {
    const lightboxHTML = `
      <div id="tw-lightbox" class="fixed inset-0 z-[9999] bg-black/90 backdrop-blur-sm opacity-0 invisible transition-all duration-300">
        <div class="absolute inset-0 flex items-center justify-center p-4">
          <!-- Close button -->
          <button id="lightbox-close" class="absolute top-4 right-4 z-10 w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center text-white text-xl transition-all">
            ✕
          </button>
          
          <!-- Previous button -->
          <button id="lightbox-prev" class="absolute left-4 top-1/2 -translate-y-1/2 z-10 w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center text-white text-xl transition-all">
            ‹
          </button>
          
          <!-- Next button -->
          <button id="lightbox-next" class="absolute right-4 top-1/2 -translate-y-1/2 z-10 w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center text-white text-xl transition-all">
            ›
          </button>
          
          <!-- Main image container -->
          <div class="relative max-w-6xl max-h-full w-full h-full flex items-center justify-center">
            <img id="lightbox-image" class="max-w-full max-h-full object-contain rounded-lg shadow-2xl" src="" alt="">
            
            <!-- Image info -->
            <div class="absolute bottom-4 left-4 right-4 bg-black/50 backdrop-blur-sm rounded-lg p-4 text-white">
              <h3 id="lightbox-title" class="font-bold text-lg mb-1"></h3>
              <p id="lightbox-description" class="text-sm text-gray-300"></p>
              <div class="flex items-center justify-between mt-2">
                <span id="lightbox-counter" class="text-xs text-gray-400"></span>
                <div class="flex gap-2">
                  <button id="lightbox-download" class="text-xs bg-white/20 hover:bg-white/30 px-3 py-1 rounded-full transition-all">
                    📥 Tải xuống
                  </button>
                  <button id="lightbox-share" class="text-xs bg-white/20 hover:bg-white/30 px-3 py-1 rounded-full transition-all">
                    📤 Chia sẻ
                  </button>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Thumbnail strip -->
          <div class="absolute bottom-4 left-1/2 -translate-x-1/2 max-w-4xl">
            <div id="lightbox-thumbnails" class="flex gap-2 overflow-x-auto scrollbar-hide p-2 bg-black/30 backdrop-blur-sm rounded-lg">
              <!-- Thumbnails will be inserted here -->
            </div>
          </div>
        </div>
      </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', lightboxHTML);
  }

  bindEvents() {
    const lightbox = document.getElementById('tw-lightbox');
    const closeBtn = document.getElementById('lightbox-close');
    const prevBtn = document.getElementById('lightbox-prev');
    const nextBtn = document.getElementById('lightbox-next');
    const downloadBtn = document.getElementById('lightbox-download');
    const shareBtn = document.getElementById('lightbox-share');

    // Close lightbox
    closeBtn.addEventListener('click', () => this.close());
    lightbox.addEventListener('click', (e) => {
      if (e.target === lightbox) this.close();
    });

    // Navigation
    prevBtn.addEventListener('click', () => this.prev());
    nextBtn.addEventListener('click', () => this.next());

    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
      if (!this.isOpen) return;
      
      switch(e.key) {
        case 'Escape':
          this.close();
          break;
        case 'ArrowLeft':
          this.prev();
          break;
        case 'ArrowRight':
          this.next();
          break;
      }
    });

    // Download image
    downloadBtn.addEventListener('click', () => this.downloadImage());
    
    // Share image
    shareBtn.addEventListener('click', () => this.shareImage());
  }

  open(images, startIndex = 0) {
    this.images = images;
    this.currentIndex = startIndex;
    this.isOpen = true;
    
    const lightbox = document.getElementById('tw-lightbox');
    lightbox.classList.remove('opacity-0', 'invisible');
    document.body.style.overflow = 'hidden';
    
    this.updateImage();
    this.createThumbnails();
  }

  close() {
    this.isOpen = false;
    const lightbox = document.getElementById('tw-lightbox');
    lightbox.classList.add('opacity-0', 'invisible');
    document.body.style.overflow = '';
  }

  prev() {
    if (this.images.length <= 1) return;
    this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length;
    this.updateImage();
  }

  next() {
    if (this.images.length <= 1) return;
    this.currentIndex = (this.currentIndex + 1) % this.images.length;
    this.updateImage();
  }

  updateImage() {
    const image = this.images[this.currentIndex];
    const lightboxImage = document.getElementById('lightbox-image');
    const lightboxTitle = document.getElementById('lightbox-title');
    const lightboxDescription = document.getElementById('lightbox-description');
    const lightboxCounter = document.getElementById('lightbox-counter');

    lightboxImage.src = image.src;
    lightboxImage.alt = image.alt || '';
    lightboxTitle.textContent = image.title || '';
    lightboxDescription.textContent = image.description || '';
    lightboxCounter.textContent = `${this.currentIndex + 1} / ${this.images.length}`;

    // Update active thumbnail
    this.updateActiveThumbnail();
  }

  createThumbnails() {
    const container = document.getElementById('lightbox-thumbnails');
    container.innerHTML = '';

    this.images.forEach((image, index) => {
      const thumb = document.createElement('button');
      thumb.className = `w-16 h-16 rounded-lg overflow-hidden border-2 transition-all ${
        index === this.currentIndex ? 'border-white' : 'border-transparent opacity-70 hover:opacity-100'
      }`;
      thumb.innerHTML = `<img src="${image.thumb || image.src}" alt="" class="w-full h-full object-cover">`;
      thumb.addEventListener('click', () => {
        this.currentIndex = index;
        this.updateImage();
      });
      container.appendChild(thumb);
    });
  }

  updateActiveThumbnail() {
    const thumbnails = document.querySelectorAll('#lightbox-thumbnails button');
    thumbnails.forEach((thumb, index) => {
      if (index === this.currentIndex) {
        thumb.className = thumb.className.replace('border-transparent opacity-70', 'border-white');
      } else {
        thumb.className = thumb.className.replace('border-white', 'border-transparent opacity-70');
      }
    });
  }

  downloadImage() {
    const image = this.images[this.currentIndex];
    const link = document.createElement('a');
    link.href = image.src;
    link.download = image.title || 'travelwise-image';
    link.click();
  }

  shareImage() {
    const image = this.images[this.currentIndex];
    if (navigator.share) {
      navigator.share({
        title: image.title || 'TravelWise Image',
        text: image.description || 'Ảnh từ TravelWise',
        url: image.src
      });
    } else {
      // Fallback: copy to clipboard
      navigator.clipboard.writeText(image.src).then(() => {
        showToast('📋 Đã copy link ảnh!');
      });
    }
  }
}

// Initialize lightbox
let travelWiseLightbox;
document.addEventListener('DOMContentLoaded', () => {
  travelWiseLightbox = new TravelWiseLightbox();
});

// Helper function to open lightbox
function openLightbox(images, startIndex = 0) {
  if (!travelWiseLightbox) {
    travelWiseLightbox = new TravelWiseLightbox();
  }
  travelWiseLightbox.open(images, startIndex);
}