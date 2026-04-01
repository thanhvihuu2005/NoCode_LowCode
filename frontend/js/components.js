/**
 * TravelWise — Shared Components (Navbar, Footer, Admin Sidebar)
 */

// ── Dữ liệu Mock ──────────────────────────────────────────────
const DATA = {
  hotels: [
    {
      id: 1,
      name: "An Home - Phòng đơn Vũng Tàu",
      location: "Vũng Tàu",
      fullLocation: "Vũng Tàu, Việt Nam",
      feature: "Gần biển",
      pricePerNight: 15,
      discount: 0,
      badge: "TOP RATED",
      rating: 9.1,
      reviewCount: "428",
      img: "https://cf.bstatic.com/xdata/images/hotel/max1024x768/438865324.jpg",
      description:
        "An Home cung cấp không gian nghỉ ngơi ấm cúng tại trung tâm thành phố biển Vũng Tàu, chỉ cách bãi sau vài phút đi bộ.",
    },
    {
      id: 2,
      name: "The Song Vũng Tàu Xinh",
      location: "Vũng Tàu",
      fullLocation: "Vũng Tàu, Việt Nam",
      feature: "View biển",
      pricePerNight: 18,
      discount: 20,
      badge: "BEST SELLER",
      rating: 9.1,
      reviewCount: "312",
      img: "https://cf.bstatic.com/xdata/images/hotel/max1280x900/414436894.jpg",
      description:
        "Căn hộ cao cấp tại The Sóng với đầy đủ tiện nghi và tầm nhìn hướng biển tuyệt đẹp, phù hợp cho cặp đôi và gia đình.",
    },
    {
      id: 3,
      name: "Căn hộ The Sóng - Mai Villa",
      location: "Vũng Tàu",
      fullLocation: "Vũng Tàu, Việt Nam",
      feature: "Sang trọng",
      pricePerNight: 22,
      discount: 0,
      badge: "LUXURY",
      rating: 8.8,
      reviewCount: "1.2k",
      img: "https://cf.bstatic.com/xdata/images/hotel/max1024x768/415510619.jpg",
      description:
        "Trải nghiệm không gian sống thượng lưu tại Mai Villa với thiết kế hiện đại và hồ bơi vô cực trên tầng thượng.",
    },
    {
      id: 4,
      name: "THE SÓNG - TRINH'S HOUSE",
      location: "Vũng Tàu",
      fullLocation: "Vũng Tàu, Việt Nam",
      feature: "Ấm cúng",
      pricePerNight: 19,
      discount: 0,
      badge: null,
      rating: 8.2,
      reviewCount: "56",
      img: "https://cf.bstatic.com/xdata/images/hotel/max1024x768/414436894.jpg",
      description:
        "Trinh House mang đến cảm giác thân thuộc như chính ngôi nhà của bạn với sự tiếp đón nồng hậu.",
    },
    {
      id: 5,
      name: "Dalat Palace Heritage Hotel",
      location: "Đà Lạt",
      fullLocation: "Đà Lạt, Lâm Đồng, Việt Nam",
      feature: "Di sản",
      pricePerNight: 100,
      discount: 0,
      badge: "LUXURY",
      rating: 9.5,
      reviewCount: "1.2k",
      img: "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=800",
      description:
        "Khách sạn di sản hàng đầu tại Đà Lạt với kiến trúc Pháp cổ điển và phong cách phục vụ hoàng gia.",
    },
    {
      id: 6,
      name: "Terracotta Hotel & Resort Dalat",
      location: "Đà Lạt",
      fullLocation: "Hồ Tuyền Lâm, Đà Lạt",
      feature: "Resort",
      pricePerNight: 80,
      discount: 0,
      badge: null,
      rating: 8.9,
      reviewCount: "3.4k",
      img: "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=800",
      description:
        "Khu nghỉ dưỡng nép mình bên hồ Tuyền Lâm mộng mơ, không gian tràn ngập sắc hoa và không khí trong lành.",
    },
  ],
  tours: [
    {
      id: 1,
      title: "Khám phá bờ biển Amalfi",
      location: "Ý",
      fullLocation: "Bờ biển Amalfi, Ý",
      duration: "8 NGÀY",
      includes: "Hotels, Meals, Guide",
      pricePerPerson: 1899,
      discount: 15,
      badge: "BEST SELLER",
      rating: 9.2,
      reviewCount: "1.284",
      img: "https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=1200",
      description:
        "Trải nghiệm vẻ đẹp ngoạn mục của phong cảnh thiên nhiên tại Ý. Chuyến đi được thiết kế riêng này sẽ đưa bạn qua những điểm tham quan mang tính biểu tượng.",
    },
    {
      id: 2,
      title: "Cuộc phiêu lưu dãy Alps Thụy Sĩ",
      location: "Thụy Sĩ",
      fullLocation: "Dãy Alps, Thụy Sĩ",
      duration: "6 NGÀY",
      includes: "Trains, Chalets, Skiing",
      pricePerPerson: 2450,
      discount: 0,
      badge: "FEATURED",
      rating: 9.8,
      reviewCount: "840",
      img: "https://images.unsplash.com/photo-1531310197839-ccf54634509e?q=80&w=1200",
      description:
        "Khám phá những đỉnh núi tuyết phủ trắng xóa và không khí trong lành của dãy Alps.",
    },
    {
      id: 3,
      title: "Hành trình di sản Kyoto",
      location: "Nhật Bản",
      fullLocation: "Kyoto, Nhật Bản",
      duration: "10 NGÀY",
      includes: "Ryokans, Tea Ceremony, Transport",
      pricePerPerson: 1550,
      discount: 0,
      badge: null,
      rating: 9.5,
      reviewCount: "2.1k",
      img: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=800",
      description:
        "Đắm mình vào không gian cổ kính của cố đô Kyoto. Tham quan các ngôi đền nghìn năm tuổi.",
    },
    {
      id: 4,
      title: "Sapa Misty Mountains",
      location: "Việt Nam",
      fullLocation: "Sapa, Lào Cai, Việt Nam",
      duration: "3 NGÀY",
      includes: "Trekking, Home Stay, Guide",
      pricePerPerson: 150,
      discount: 0,
      badge: "POPULAR",
      rating: 8.9,
      reviewCount: "1.5k",
      img: "https://images.unsplash.com/photo-1504457047772-27fad17af0ec?q=80&w=1200",
      description:
        "Chinh phục đỉnh Fansipan và khám phá vẻ đẹp hoang sơ của những bản làng trong sương mù Sapa.",
    },
    {
      id: 5,
      title: "Kỳ nghỉ lãng mạn tại Maldives",
      location: "Maldives",
      fullLocation: "Đảo san hô, Maldives",
      duration: "7 NGÀY",
      includes: "Water Villa, Flights",
      pricePerPerson: 3200,
      discount: 0,
      badge: "LUXURY",
      rating: 9.9,
      reviewCount: "450",
      img: "https://images.unsplash.com/photo-1514282401047-d79a71a590e8?q=80&w=1200",
      description:
        "Tận hưởng kỳ nghỉ sang trọng trên những hòn đảo thiên đường Maldives với biển xanh trong vắt.",
    },
  ],
  destinations: [
    {
      id: 1,
      name: "Vũng Tàu",
      img: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=400",
    },
    {
      id: 2,
      name: "Đà Lạt",
      img: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?q=80&w=400",
    },
    {
      id: 3,
      name: "Sapa",
      img: "https://images.unsplash.com/photo-1627894005416-541a7f367b65?q=80&w=400",
    },
    {
      id: 4,
      name: "Hội An",
      img: "https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=400",
    },
    {
      id: 5,
      name: "Phú Quốc",
      img: "https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400",
    },
    {
      id: 6,
      name: "Hà Nội",
      img: "https://images.unsplash.com/photo-1523592121529-f6dde35f079e?q=80&w=400",
    },
    {
      id: 7,
      name: "TP. Hồ Chí Minh",
      img: "https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=400",
    },
    {
      id: 8,
      name: "Đà Nẵng",
      img: "https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=400",
    },
  ],
  users: [
    {
      id: "USR-001",
      name: "Nguyễn Văn A",
      email: "vana@gmail.com",
      bookingCount: 5,
      createdAt: "12/01/2024",
      status: "active",
    },
    {
      id: "USR-002",
      name: "Trần Thị B",
      email: "thib@gmail.com",
      bookingCount: 2,
      createdAt: "15/02/2024",
      status: "active",
    },
    {
      id: "USR-003",
      name: "Lê Văn C",
      email: "vanc@gmail.com",
      bookingCount: 0,
      createdAt: "20/02/2024",
      status: "blocked",
    },
    {
      id: "USR-004",
      name: "Phạm Minh D",
      email: "minhd@gmail.com",
      bookingCount: 8,
      createdAt: "05/03/2024",
      status: "active",
    },
  ],
  bookings: [
    {
      id: "BK-1001",
      userId: "USR-001",
      userName: "Nguyễn Văn A",
      serviceId: 1,
      serviceName: "Khám phá bờ biển Amalfi",
      serviceType: "tour",
      date: "20/03/2024",
      price: 1899,
      status: "Pending",
    },
    {
      id: "BK-1002",
      userId: "USR-002",
      userName: "Trần Thị B",
      serviceId: 4,
      serviceName: "Sapa Misty Mountains",
      serviceType: "tour",
      date: "22/03/2024",
      price: 150,
      status: "Confirmed",
    },
    {
      id: "BK-1003",
      userId: "USR-001",
      userName: "Nguyễn Văn A",
      serviceId: 1,
      serviceName: "An Home - Phòng đơn Vũng Tàu",
      serviceType: "hotel",
      date: "25/03/2024",
      price: 85,
      status: "Completed",
    },
    {
      id: "BK-1004",
      userId: "USR-004",
      userName: "Phạm Minh D",
      serviceId: 2,
      serviceName: "Cuộc phiêu lưu dãy Alps",
      serviceType: "tour",
      date: "01/04/2024",
      price: 2450,
      status: "Cancelled",
    },
  ],
  reviews: [
    {
      id: "REV-001",
      userName: "Nguyễn Văn A",
      serviceName: "An Home - Phòng đơn Vũng Tàu",
      rating: 5,
      comment: "Dịch vụ tuyệt vời, phòng sạch sẽ!",
      date: "15/02/2024",
      status: "published",
    },
    {
      id: "REV-002",
      userName: "Trần Thị B",
      serviceName: "Khám phá bờ biển Amalfi",
      rating: 4,
      comment: "Chuyến đi rất thú vị nhưng thời gian hơi gấp.",
      date: "20/02/2024",
      status: "published",
    },
    {
      id: "REV-003",
      userName: "Lê Văn C",
      serviceName: "Sapa Misty Mountains",
      rating: 1,
      comment: "Quá tệ, tôi sẽ không quay lại!",
      date: "25/02/2024",
      status: "hidden",
    },
  ],
  promos: [
    {
      id: "PROMO-001",
      code: "WINTER2024",
      type: "Dịch vụ",
      value: "10%",
      valueNum: 10,
      isPercent: true,
      limit: 500,
      used: 123,
      expiry: "31/12/2024",
      status: "active",
    },
    {
      id: "PROMO-002",
      code: "WELCOMENEW",
      type: "Tất cả",
      value: "100.000₫",
      valueNum: 100000,
      isPercent: false,
      limit: 0,
      used: 87,
      expiry: "",
      status: "active",
    },
    {
      id: "PROMO-003",
      code: "SUMMERVIBE",
      type: "Tour",
      value: "15%",
      valueNum: 15,
      isPercent: true,
      limit: 200,
      used: 200,
      expiry: "30/08/2024",
      status: "expired",
    },
  ],
  rules: [
    {
      id: "RULE-001",
      trigger: "Sapa",
      suggestion: "Tour Trekking Fansipan",
      type: "cross-sell",
      isActive: true,
    },
    {
      id: "RULE-002",
      trigger: "Hội An",
      suggestion: "Vé show Ký Ức Hội An",
      type: "cross-sell",
      isActive: true,
    },
    {
      id: "RULE-003",
      trigger: "Luxury",
      suggestion: "Dịch vụ đưa đón VIP bằng Limousine",
      type: "upsell",
      isActive: false,
    },
  ],
  logs: [
    {
      id: "LOG-001",
      event: "Email xác nhận BK-1002",
      timestamp: "10/03/2024 14:30",
      status: "success",
    },
    {
      id: "LOG-002",
      event: "Gợi ý tour mới USR-004",
      timestamp: "10/03/2024 15:00",
      status: "success",
    },
    {
      id: "LOG-003",
      event: "Lỗi gửi email USR-003",
      timestamp: "10/03/2024 16:15",
      status: "failure",
    },
  ],
};

// ── Helpers ──────────────────────────────────────────────
function getUser() {
  return JSON.parse(localStorage.getItem("tw_user") || "null");
}
function getToken() {
  return localStorage.getItem("tw_token");
}
function removeAuth() {
  localStorage.removeItem("tw_token");
  localStorage.removeItem("tw_user");
}

// ── Price Formatters ─────────────────────────────────────────
function formatVND(amount) {
  if (isNaN(amount) || amount == null) return '0₫';
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(amount);
}

function fmtPrice(p) {
  return formatVND(p);
}
function fmtVND(usd) {
  return formatVND(usd * 23000);
}

function showToast(msg, type = "success") {
  let area = document.getElementById("toast-area");
  if (!area) {
    area = document.createElement("div");
    area.id = "toast-area";
    area.className = "fixed top-4 right-4 z-[9999] space-y-2";
    document.body.appendChild(area);
  }
  const bg =
    type === "success"
      ? "bg-emerald-500"
      : type === "error"
        ? "bg-red-500"
        : "bg-blue-500";
  const el = document.createElement("div");
  el.className = `px-5 py-3 rounded-xl text-white text-sm font-medium shadow-xl ${bg} translate-x-[120%] transition-all duration-300`;
  el.textContent = msg;
  area.appendChild(el);
  requestAnimationFrame(() => el.classList.remove("translate-x-[120%]"));
  setTimeout(() => {
    el.classList.add("translate-x-[120%]");
    setTimeout(() => el.remove(), 300);
  }, 3000);
}

function showLoading(el, show) {
  if (show) {
    el.disabled = true;
    el._o = el.innerHTML;
    el.innerHTML =
      '<svg class="animate-spin h-4 w-4 mx-auto" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/></svg>';
  } else {
    el.disabled = false;
    el.innerHTML = el._o;
  }
}
// ── Navbar Injection ──────────────────────────────────────
function injectNavbar(activePage = "") {
  const u = getUser();

  // Detect if we're in admin or client context
  const isAdmin = window.location.pathname.includes("/admin/");
  const clientPrefix = isAdmin ? "../client/" : "";
  const adminPrefix = isAdmin ? "" : "admin/";

  const nav = `
  <header class="sticky top-0 z-50 bg-white border-b border-gray-200 shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <div class="flex items-center gap-8">
          <a href="${clientPrefix}index.html" class="flex items-center gap-2">
            <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"/><path stroke-width="2" d="M2 12h20M12 2a15.3 15.3 0 010 20M12 2a15.3 15.3 0 000 20"/></svg>
            <span class="text-2xl font-extrabold tracking-tight text-slate-900">Travel<span class="text-blue-600">Wise</span></span>
          </a>
          <nav class="hidden lg:flex items-center gap-6">
            <a href="${clientPrefix}index.html"   class="text-[15px] font-medium ${activePage === "home" ? "text-blue-600" : "text-gray-700"} hover:text-blue-600 transition-colors">Trang chủ</a>
            <a href="${clientPrefix}tours.html"   class="text-[15px] font-medium ${activePage === "tours" ? "text-blue-600" : "text-gray-700"} hover:text-blue-600 transition-colors">Tours</a>
            <a href="${clientPrefix}hotels.html"  class="text-[15px] font-medium ${activePage === "hotels" ? "text-blue-600" : "text-gray-700"} hover:text-blue-600 transition-colors">Khách sạn</a>
            <a href="${clientPrefix}about.html"   class="text-[15px] font-medium ${activePage === "about" ? "text-blue-600" : "text-gray-700"} hover:text-blue-600 transition-colors">Giới thiệu</a>
            <a href="${clientPrefix}contact.html" class="text-[15px] font-medium ${activePage === "contact" ? "text-blue-600" : "text-gray-700"} hover:text-blue-600 transition-colors">Liên hệ</a>
          </nav>
        </div>
        <div class="flex items-center gap-4">
          ${
            u
              ? `
            ${u.role === "admin" ? `<a href="${adminPrefix}index.html" class="text-xs bg-orange-100 text-orange-600 font-semibold px-3 py-1.5 rounded-full">Admin ↗</a>` : ""}
            <a href="${clientPrefix}wishlist.html" class="text-gray-500 hover:text-blue-600 text-sm">❤️</a>
            <a href="${clientPrefix}notifications.html" class="text-gray-500 hover:text-blue-600 text-sm">🔔</a>
            <a href="${clientPrefix}profile.html" class="flex items-center gap-2 p-1.5 rounded-full hover:bg-slate-100 border border-transparent hover:border-slate-200 transition-all">
              <div class="w-9 h-9 bg-blue-600 rounded-full flex items-center justify-center text-white text-sm font-bold">${u.name.charAt(0).toUpperCase()}</div>
              <span class="hidden lg:block text-sm font-bold text-slate-900 pr-1 capitalize">${u.name.split(" ").pop()}</span>
            </a>
          `
              : `
            <a href="${clientPrefix}login.html"    class="text-[15px] font-semibold text-blue-600 hover:bg-blue-50 px-4 py-2 rounded transition-all">Đăng nhập</a>
            <a href="${clientPrefix}register.html" class="text-[15px] font-semibold text-blue-600 border border-blue-600 px-5 py-2 rounded-full hover:bg-blue-50 transition-all">Tạo tài khoản</a>
          `
          }
        </div>
      </div>
    </div>
  </header>`;
  const el = document.getElementById("tw-navbar");
  if (el) el.outerHTML = nav;
  else document.body.insertAdjacentHTML("afterbegin", nav);
}

// ── Footer Injection ──────────────────────────────────────
function injectFooter() {
  // Detect if we're in admin or client context
  const isAdmin = window.location.pathname.includes("/admin/");
  const clientPrefix = isAdmin ? "../client/" : "";

  const footer = `
  <footer class="bg-slate-900 text-slate-400 py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
        <div class="col-span-1">
          <div class="flex items-center gap-2 text-white mb-6">
            <svg class="w-8 h-8 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"/><path stroke-width="2" d="M2 12h20M12 2a15.3 15.3 0 010 20M12 2a15.3 15.3 0 000 20"/></svg>
            <span class="text-xl font-extrabold tracking-tight">TravelWise</span>
          </div>
          <p class="text-sm leading-relaxed mb-6">Nền tảng đặt tour và khách sạn tin cậy hàng đầu Việt Nam. Trải nghiệm hành trình tuyệt vời từ năm 2024.</p>
          <div class="flex gap-3">
            <a href="#" class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all text-sm">fb</a>
            <a href="#" class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all text-sm">yt</a>
            <a href="#" class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all text-sm">zl</a>
          </div>
        </div>
        <div>
          <h4 class="text-white font-bold mb-6">Dịch vụ</h4>
          <ul class="space-y-4 text-sm">
            <li><a href="${clientPrefix}hotels.html" class="hover:text-blue-400 transition-colors">Khách sạn</a></li>
            <li><a href="${clientPrefix}tours.html"  class="hover:text-blue-400 transition-colors">Tour du lịch</a></li>
            <li><a href="#" class="hover:text-blue-400 transition-colors">Vé máy bay</a></li>
          </ul>
        </div>
        <div>
          <h4 class="text-white font-bold mb-6">Công ty</h4>
          <ul class="space-y-4 text-sm">
            <li><a href="${clientPrefix}about.html"   class="hover:text-blue-400 transition-colors">Giới thiệu</a></li>
            <li><a href="${clientPrefix}contact.html" class="hover:text-blue-400 transition-colors">Liên hệ</a></li>
            <li><a href="#" class="hover:text-blue-400 transition-colors">Chính sách bảo mật</a></li>
          </ul>
        </div>
        <div>
          <h4 class="text-white font-bold mb-6">Hỗ trợ</h4>
          <ul class="space-y-4 text-sm">
            <li><a href="#" class="hover:text-blue-400 transition-colors">Trung tâm hỗ trợ</a></li>
            <li><a href="#" class="hover:text-blue-400 transition-colors">Chính sách hoàn tiền</a></li>
            <li><a href="#" class="hover:text-blue-400 transition-colors">An toàn du lịch</a></li>
            <li class="flex items-center gap-2 text-white font-bold pt-2">📞 1800 1234</li>
          </ul>
        </div>
      </div>

    </div>
  </footer>`;
  document.body.insertAdjacentHTML("beforeend", footer);
}

// ── Admin Sidebar Injection ───────────────────────────────
function injectAdminSidebar(activePage = "") {
  const links = [
    { href: "index.html", icon: "📊", label: "Tổng quan" },
    { href: "analytics.html", icon: "📈", label: "Báo cáo" },
    { sep: "Nội dung" },
    { href: "tours.html", icon: "🗺", label: "Tours" },
    { href: "hotels.html", icon: "🏨", label: "Khách sạn" },
    { href: "destinations.html", icon: "📍", label: "Điểm đến" },
    { sep: "Quản lý" },
    { href: "bookings.html", icon: "📋", label: "Đặt chỗ" },
    { href: "users.html", icon: "👥", label: "Người dùng" },
    { href: "reviews.html", icon: "⭐", label: "Đánh giá" },
    { href: "discounts.html", icon: "🏷", label: "Mã giảm giá" },
    { sep: "Hệ thống" },
    { href: "automation.html", icon: "⚡", label: "Tự động hóa" },
    { href: "recommendations.html", icon: "🤖", label: "Gợi ý AI" },
    { href: "settings.html", icon: "⚙️", label: "Cài đặt" },
  ];
  const navHtml = links
    .map((l) =>
      l.sep
        ? `<p class="text-xs uppercase tracking-widest text-slate-500 px-3 pt-5 pb-1 font-semibold">${l.sep}</p>`
        : `<a href="${l.href}" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm transition-all ${activePage === l.href ? "bg-blue-600 text-white font-semibold" : "text-slate-400 hover:bg-white/10 hover:text-white"}">${l.icon} ${l.label}</a>`,
    )
    .join("");
  const u = getUser();
  const sidebar = `
  <aside class="w-64 bg-slate-900 text-slate-400 flex flex-col fixed h-full z-30">
    <div class="p-6 border-b border-slate-800">
      <p class="text-white font-extrabold text-xl">Travel<span class="text-blue-400">Wise</span></p>
      <p class="text-xs mt-1 text-slate-500">Admin Dashboard</p>
    </div>
    <nav class="flex-1 p-4 space-y-0.5 text-sm overflow-y-auto">${navHtml}</nav>
    <div class="p-4 border-t border-slate-800 flex items-center gap-3">
      <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white text-xs font-bold flex-shrink-0">${(u?.name || "A").charAt(0).toUpperCase()}</div>
      <div class="flex-1 min-w-0"><p class="text-white text-sm font-medium truncate">${u?.name || "Admin"}</p><p class="text-xs text-slate-500 truncate">${u?.email || "admin@travelwise.vn"}</p></div>
      <button onclick="handleLogout()" title="Đăng xuất" class="text-slate-500 hover:text-red-400 transition">🚪</button>
    </div>
  </aside>`;
  const el = document.getElementById("tw-sidebar");
  if (el) el.outerHTML = sidebar;
  else document.body.insertAdjacentHTML("afterbegin", sidebar);
}

function handleLogout() {
  removeAuth();
  // Detect if we're in admin or client context
  const isAdmin = window.location.pathname.includes("/admin/");
  const loginPath = isAdmin ? "../client/login.html" : "login.html";
  window.location.href = loginPath;
}

// ── Status Badge ─────────────────────────────────────────
function bookingBadge(status) {
  const badges = {
    Pending: '<span class="badge badge-warning">⏳ Chờ duyệt</span>',
    Confirmed: '<span class="badge badge-primary">✅ Đã xác nhận</span>',
    Completed: '<span class="badge badge-success">🎉 Hoàn thành</span>',
    Cancelled: '<span class="badge badge-error">❌ Đã hủy</span>',
  };
  return (
    badges[status] ||
    `<span class="badge bg-secondary-100 text-content-secondary border border-default">${status}</span>`
  );
}
// ── Hotel Card ───────────────────────────────────────────
function hotelCard(h, linkPrefix = "") {
  // Auto-detect path if not provided
  if (!linkPrefix) {
    const isAdmin = window.location.pathname.includes("/admin/");
    linkPrefix = isAdmin ? "../client/" : "";
  }
  const finalPrice = Math.round(h.pricePerNight * (1 - h.discount / 100));
  return `
  <a href="${linkPrefix}hotel-detail.html?id=${h.id}" class="bg-white rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group block">
    <div class="relative overflow-hidden">
      <img src="${h.img}" alt="${h.name}" class="w-full h-48 object-cover group-hover:scale-105 transition duration-500"/>
      ${h.badge ? `<span class="absolute top-3 left-3 bg-blue-600 text-white text-xs font-bold px-2.5 py-1 rounded-full">${h.badge}</span>` : ""}
      <span class="absolute top-3 right-3 bg-white/90 text-slate-800 text-xs font-bold px-2 py-1 rounded-full">⭐ ${h.rating}</span>
      ${h.discount ? `<span class="absolute bottom-3 left-3 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-full">-${h.discount}%</span>` : ""}
    </div>
    <div class="p-4">
      <p class="text-xs text-gray-500 mb-1">📍 ${h.location}</p>
      <h3 class="font-bold text-slate-900 mb-1 leading-tight line-clamp-2 text-[15px]">${h.name}</h3>
      <p class="text-xs text-gray-400 mb-3">${h.feature}</p>
      <div class="flex items-end justify-between pt-3 border-t border-gray-100">
        <div>
          ${h.discount ? `<p class="text-xs text-gray-400 line-through">${formatVND(h.pricePerNight * 23000)}</p>` : ""}
          <p class="text-blue-600 font-extrabold text-lg">${formatVND(finalPrice * 23000)}<span class="text-xs text-gray-400 font-normal">/đêm</span></p>
        </div>
        <span class="bg-blue-600 text-white text-xs font-semibold px-3 py-1.5 rounded-full">Đặt ngay</span>
      </div>
    </div>
  </a>`;
}

// ── Tour Card ────────────────────────────────────────────
function tourCard(t, linkPrefix = "") {
  // Auto-detect path if not provided
  if (!linkPrefix) {
    const isAdmin = window.location.pathname.includes("/admin/");
    linkPrefix = isAdmin ? "../client/" : "";
  }
  const finalPrice = Math.round(t.pricePerPerson * (1 - t.discount / 100));
  return `
  <a href="${linkPrefix}tour-detail.html?id=${t.id}" class="bg-white rounded-2xl overflow-hidden border border-gray-200 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group block">
    <div class="relative overflow-hidden">
      <img src="${t.img}" alt="${t.title}" class="w-full h-48 object-cover group-hover:scale-105 transition duration-500"/>
      <span class="absolute top-3 right-3 bg-black/60 text-white text-xs font-bold px-2 py-1 rounded-lg">⭐ ${t.rating}</span>
      <span class="absolute bottom-3 right-3 bg-black/60 text-white text-xs px-2 py-1 rounded-lg">⏱ ${t.duration}</span>
    </div>
    <div class="p-4">
      <p class="text-xs text-slate-500 mb-1">📍 ${t.location}</p>
      <h3 class="font-bold text-slate-800 mb-1 leading-tight line-clamp-2">${t.title}</h3>
      <p class="text-xs text-slate-400 mb-3">${t.includes}</p>
      <div class="flex items-end justify-between">
        <div>
          ${t.discount ? `<p class="text-xs text-slate-400 line-through">${formatVND(t.pricePerPerson * 23000)}</p>` : ""}
          <p class="text-blue-600 font-extrabold text-lg">${formatVND(Math.round(finalPrice) * 23000)}<span class="text-xs text-slate-400 font-normal">/người</span></p>
        </div>
        <span class="bg-blue-50 text-blue-700 text-xs font-semibold px-3 py-1.5 rounded-full">Xem tour →</span>
      </div>
    </div>
  </a>`;
}

// ── Booking.com style TravelCard (shared) ────────────────
function getRatingLabel(s) {
  return s >= 9.5
    ? "Xuất sắc"
    : s >= 9
      ? "Tuyệt hảo"
      : s >= 8.5
        ? "Rất tốt"
        : s >= 8
          ? "Tốt"
          : "Hài lòng";
}

function fmtVND(usd) {
  return (usd * 23000).toLocaleString("vi-VN");
}

function travelCard(item, type, linkPrefix = "") {
  const isTour = type === "tour";
  const title = isTour ? item.title : item.name;
  const info = isTour ? item.duration : item.feature;
  const price = isTour ? item.pricePerPerson : item.pricePerNight;
  const discount = item.discount || 0;
  const unit = isTour ? "mỗi người" : "mỗi đêm";
  const href =
    (linkPrefix || "") +
    (isTour ? "tour-detail.html?id=" : "hotel-detail.html?id=") +
    item.id;
  const priceVND = fmtVND(Math.round(price * (1 - discount / 100)));
  const strikeVND = fmtVND(
    Math.round(price * (discount ? 1 / (1 - discount / 100) : 1.2)),
  );
  const r = Number(item.rating) || 9;

  return `<a href="${href}" class="flex snap-start w-full sm:w-[calc(50%-8px)] md:w-[calc(33.33%-11px)] lg:w-[calc(25%-12px)] flex-shrink-0 no-underline">
    <div class="bg-white rounded-lg overflow-hidden border border-slate-200 hover:shadow-md transition-shadow group h-full flex flex-col w-full">
      <div class="relative h-48 shrink-0 overflow-hidden">
        <img src="${item.img}" alt="${title}" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"/>
        <button onclick="event.preventDefault()" class="absolute top-2 right-2 w-8 h-8 rounded-full bg-white flex items-center justify-center text-slate-900 shadow-sm hover:text-red-500 transition-colors z-10">♡</button>
        ${discount ? `<span class="absolute top-2 left-2 bg-red-500 text-white text-xs font-bold px-2 py-0.5 rounded">-${discount}%</span>` : ""}
      </div>
      <div class="p-3 flex flex-col flex-grow">
        <div class="flex items-center gap-1 mb-1"><div class="bg-[#003580] text-white text-[10px] font-bold px-1 rounded flex items-center h-4">Genius</div></div>
        <h4 class="font-bold text-[15px] text-slate-900 leading-tight mb-1 line-clamp-2" style="min-height:40px">${title}</h4>
        <p class="text-[12px] text-slate-500 mb-2 truncate">${item.location || ""}  ${info || ""}</p>
        <div class="flex items-center gap-2 mb-3">
          <div class="bg-[#003580] text-white font-bold text-[12px] w-7 h-7 flex items-center justify-center rounded-tl-lg rounded-tr-lg rounded-br-lg">${r.toString().replace(".", ",")}</div>
          <div><span class="text-[12px] font-bold text-slate-900 block leading-none">${getRatingLabel(r)}</span><span class="text-[11px] text-slate-500">${item.reviewCount || "0"} đánh giá</span></div>
        </div>
        <div class="mt-auto pt-2 flex flex-col items-end">
          <span class="text-[11px] text-slate-500 mb-0.5">${unit}</span>
          <span class="text-[11px] text-red-600 line-through">VND ${strikeVND}</span>
          <span class="text-[16px] font-bold text-slate-900">VND ${priceVND}</span>
        </div>
      </div>
    </div>
  </a>`;
}
