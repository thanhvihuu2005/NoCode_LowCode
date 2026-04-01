/**
 * TravelWise Upsell & Cross-sell Components
 * Revenue optimization UI components
 */

/**
 * Create hotel → tour cross-sell recommendation
 * @param {object} hotel - Hotel data
 * @param {object} tour - Recommended tour data
 * @param {number} discount - Discount percentage
 * @returns {string} HTML string
 */
function createHotelTourUpsell(hotel, tour, discount = 20) {
  const hotelPriceVND = usdToVND(hotel.pricePerNight);
  const tourPriceVND = usdToVND(tour.pricePerPerson);
  const totalOriginal = hotelPriceVND + tourPriceVND;
  const pricing = calculateDiscountVND(totalOriginal, discount, false);

  return `
    <div class="recommendation-card">
      <div class="recommendation-header">
        <span class="upsell-badge">🏨→🗺 Combo Deal</span>
        <span class="savings-badge">-${discount}%</span>
      </div>
      <div class="grid grid-cols-2 gap-3 mb-3">
        <img src="${hotel.img}" alt="${hotel.name}" class="w-full h-20 object-cover rounded-lg">
        <img src="${tour.img}" alt="${tour.title}" class="w-full h-20 object-cover rounded-lg">
      </div>
      <div class="recommendation-title">${hotel.name} + ${tour.title}</div>
      <div class="text-xs text-content-secondary mb-2">📍 ${hotel.location} • ⏱ ${tour.duration}</div>
      <div class="flex items-center justify-between mt-2 mb-3">
        <div>
          <div class="text-xs text-content-secondary line-through">${pricing.original}</div>
          <div class="recommendation-price">${pricing.discounted}</div>
        </div>
        <div class="text-right">
          <div class="text-xs text-accent-600 font-semibold">Tiết kiệm</div>
          <div class="text-accent-600 font-bold">${pricing.savingsCompact}</div>
        </div>
      </div>
      <button class="recommendation-cta" onclick="addComboToCart('${hotel.id}', '${tour.id}', ${discount})">
        🔥 Thêm combo ngay
      </button>
    </div>
  `;
}

/**
 * Create tour → hotel upgrade upsell
 * @param {object} currentHotel - Current hotel selection
 * @param {object} upgradeHotel - Upgrade hotel option
 * @param {number} discount - Discount percentage
 * @returns {string} HTML string
 */
function createHotelUpgradeUpsell(currentHotel, upgradeHotel, discount = 15) {
  const currentPriceVND = usdToVND(currentHotel.pricePerNight);
  const upgradePriceVND = usdToVND(upgradeHotel.pricePerNight);
  const priceDiff = upgradePriceVND - currentPriceVND;
  const discountedDiff = Math.round(priceDiff * (1 - discount / 100));

  return `
    <div class="recommendation-card">
      <div class="recommendation-header">
        <span class="upsell-badge">💎 Nâng cấp khách sạn</span>
        <span class="savings-badge">-${discount}%</span>
      </div>
      <img src="${upgradeHotel.img}" alt="${upgradeHotel.name}" class="w-full h-32 object-cover rounded-lg mb-3">
      <div class="recommendation-title">${upgradeHotel.name}</div>
      <div class="text-xs text-content-secondary mb-2">
        ⭐ ${upgradeHotel.rating} • ${upgradeHotel.feature}
      </div>
      <div class="flex items-center justify-between mt-2 mb-3">
        <div>
          <div class="text-xs text-content-secondary">Chỉ thêm:</div>
          <div class="recommendation-price">${formatVND(discountedDiff)}</div>
        </div>
        <div class="text-right">
          <div class="text-xs text-accent-600 font-semibold">Tiết kiệm</div>
          <div class="text-accent-600 font-bold">${formatVND(priceDiff - discountedDiff, { compact: true })}</div>
        </div>
      </div>
      <button class="recommendation-cta" onclick="upgradeHotel('${currentHotel.id}', '${upgradeHotel.id}', ${discount})">
        💎 Nâng cấp ngay
      </button>
    </div>
  `;
}

/**
 * Create service add-on upsell (airport transfer, insurance, etc.)
 * @param {object} service - Add-on service data
 * @returns {string} HTML string
 */
function createServiceAddonUpsell(service) {
  return `
    <div class="recommendation-card">
      <div class="recommendation-header">
        <span class="upsell-badge">➕ ${service.category}</span>
        <span class="badge badge-primary">${service.badge || 'Phổ biến'}</span>
      </div>
      <img src="${service.img}" alt="${service.name}" class="w-full h-32 object-cover rounded-lg mb-3">
      <div class="recommendation-title">${service.name}</div>
      <div class="text-xs text-content-secondary mb-2">${service.description}</div>
      <div class="flex items-center justify-between mt-2 mb-3">
        <div>
          <div class="recommendation-price">${formatVND(service.priceVND)}</div>
          <div class="text-xs text-content-secondary">${service.unit || 'mỗi người'}</div>
        </div>
        <div class="text-right">
          <div class="text-xs text-success-600">⭐ ${service.rating}</div>
          <div class="text-xs text-content-secondary">${service.reviewCount} đánh giá</div>
        </div>
      </div>
      <button class="recommendation-cta" onclick="addServiceAddon('${service.id}')">
        Thêm dịch vụ
      </button>
    </div>
  `;
}

/**
 * Create upsell insight card for admin dashboard
 * @param {object} data - Upsell performance data
 * @returns {string} HTML string
 */
function createUpsellInsightCard(data) {
  const {
    conversionRate = 32,
    revenueToday = 18400000,
    customersUpsold = 12,
    avgUpsellValue = 800000,
    trend = '+15%'
  } = data;

  return `
    <div class="upsell-card">
      <div class="flex items-center justify-between">
        <div class="flex-1">
          <h3 class="font-bold text-lg text-accent-700 flex items-center gap-2">
            🔥 Cơ hội Upsell & Cross-sell hôm nay
          </h3>
          <p class="text-sm text-accent-600 mt-1">
            Tỷ lệ chuyển đổi combo tăng ${trend} • ${customersUpsold} khách hàng đã thêm dịch vụ
          </p>
          <div class="grid grid-cols-3 gap-4 mt-4">
            <div class="text-center">
              <div class="text-xl font-bold text-accent-700">${conversionRate}%</div>
              <div class="text-xs text-accent-600">Tỷ lệ chuyển đổi</div>
            </div>
            <div class="text-center">
              <div class="text-xl font-bold text-accent-700">${formatVND(avgUpsellValue, { compact: true })}</div>
              <div class="text-xs text-accent-600">Giá trị TB/upsell</div>
            </div>
            <div class="text-center">
              <div class="text-xl font-bold text-accent-700">${customersUpsold}</div>
              <div class="text-xs text-accent-600">Khách hàng hôm nay</div>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-3 ml-6">
          <div class="text-right">
            <div class="text-2xl font-bold text-accent-700">${formatVND(revenueToday, { compact: true })}</div>
            <div class="text-xs text-accent-600">Doanh thu upsell</div>
          </div>
          <button class="btn btn-accent">Xem chi tiết</button>
        </div>
      </div>
    </div>
  `;
}

/**
 * Create limited time offer banner
 * @param {object} offer - Offer data
 * @returns {string} HTML string
 */
function createLimitedTimeOffer(offer) {
  const {
    title = "🔥 Ưu đãi có thời hạn",
    description = "Đặt combo tour + khách sạn tiết kiệm đến 25%",
    discount = 25,
    timeLeft = "23:45:12",
    ctaText = "Đặt ngay"
  } = offer;

  return `
    <div class="bg-gradient-to-r from-accent-500 to-accent-600 text-white rounded-2xl p-6 shadow-upsell relative overflow-hidden">
      <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16"></div>
      <div class="relative z-10">
        <div class="flex items-center justify-between mb-4">
          <div>
            <h3 class="font-bold text-xl mb-1">${title}</h3>
            <p class="text-accent-100">${description}</p>
          </div>
          <div class="text-right">
            <div class="text-3xl font-bold">-${discount}%</div>
            <div class="text-xs text-accent-100">Giảm giá</div>
          </div>
        </div>
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-4">
            <div class="text-center">
              <div class="text-lg font-bold">${timeLeft.split(':')[0]}</div>
              <div class="text-xs text-accent-100">Giờ</div>
            </div>
            <div class="text-center">
              <div class="text-lg font-bold">${timeLeft.split(':')[1]}</div>
              <div class="text-xs text-accent-100">Phút</div>
            </div>
            <div class="text-center">
              <div class="text-lg font-bold">${timeLeft.split(':')[2]}</div>
              <div class="text-xs text-accent-100">Giây</div>
            </div>
          </div>
          <button class="bg-white text-accent-600 font-bold py-2 px-6 rounded-lg hover:bg-accent-50 transition-colors">
            ${ctaText}
          </button>
        </div>
      </div>
    </div>
  `;
}

/**
 * Create upsell recommendation grid
 * @param {array} recommendations - Array of recommendation objects
 * @returns {string} HTML string
 */
function createUpsellGrid(recommendations) {
  const gridHTML = recommendations.map(rec => {
    switch (rec.type) {
      case 'hotel-tour-combo':
        return createHotelTourUpsell(rec.hotel, rec.tour, rec.discount);
      case 'hotel-upgrade':
        return createHotelUpgradeUpsell(rec.currentHotel, rec.upgradeHotel, rec.discount);
      case 'service-addon':
        return createServiceAddonUpsell(rec.service);
      default:
        return '';
    }
  }).join('');

  return `
    <div class="space-y-6">
      <div class="flex items-center justify-between">
        <h2 class="text-xl font-bold text-content-primary">🎯 Gợi ý tăng doanh thu</h2>
        <span class="text-sm text-accent-600 font-medium">
          Tỷ lệ chuyển đổi: 32% ↗
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        ${gridHTML}
      </div>
    </div>
  `;
}

// Event handlers for upsell actions
function addComboToCart(hotelId, tourId, discount) {
  console.log(`Adding combo: Hotel ${hotelId} + Tour ${tourId} with ${discount}% discount`);
  showToast(`🔥 Đã thêm combo deal vào giỏ hàng! Tiết kiệm ${discount}%`, 'success');
  // Add actual cart logic here
}

function upgradeHotel(currentId, upgradeId, discount) {
  console.log(`Upgrading hotel from ${currentId} to ${upgradeId} with ${discount}% discount`);
  showToast(`💎 Đã nâng cấp khách sạn! Tiết kiệm ${discount}%`, 'success');
  // Add actual upgrade logic here
}

function addServiceAddon(serviceId) {
  console.log(`Adding service addon: ${serviceId}`);
  showToast(`✅ Đã thêm dịch vụ vào đặt chỗ!`, 'success');
  // Add actual service logic here
}

// Export functions for use in other files
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    createHotelTourUpsell,
    createHotelUpgradeUpsell,
    createServiceAddonUpsell,
    createUpsellInsightCard,
    createLimitedTimeOffer,
    createUpsellGrid
  };
}

// Global functions for HTML usage
window.createHotelTourUpsell = createHotelTourUpsell;
window.createHotelUpgradeUpsell = createHotelUpgradeUpsell;
window.createServiceAddonUpsell = createServiceAddonUpsell;
window.createUpsellInsightCard = createUpsellInsightCard;
window.createLimitedTimeOffer = createLimitedTimeOffer;
window.createUpsellGrid = createUpsellGrid;
window.addComboToCart = addComboToCart;
window.upgradeHotel = upgradeHotel;
window.addServiceAddon = addServiceAddon;