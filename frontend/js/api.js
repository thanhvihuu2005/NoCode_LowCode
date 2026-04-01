/**
 * TravelWise API Client
 * Kết nối đến Laravel Backend: http://localhost:8000
 */

const API_BASE = 'http://127.0.0.1:8000/api';

// ── Helpers ────────────────────────────────────────────────
function getToken() { return localStorage.getItem('tw_token'); }
function setToken(t) { localStorage.setItem('tw_token', t); }
function removeToken() { localStorage.removeItem('tw_token'); }
function getUser() { return JSON.parse(localStorage.getItem('tw_user') || 'null'); }
function setUser(u) { localStorage.setItem('tw_user', JSON.stringify(u)); }
function authHeaders() { return { 'Authorization': 'Bearer ' + getToken(), 'Accept': 'application/json' }; }

/**
 * Lấy mảng từ JSON API: { data: [...] } hoặc pagination { data: { data: [...] } }
 */
function extractApiList(json) {
  if (!json || typeof json !== 'object') return [];
  const d = json.data;
  if (Array.isArray(d)) return d;
  if (d && typeof d === 'object' && Array.isArray(d.data)) return d.data;
  return [];
}

/** Kết quả Promise.allSettled → mảng (khi fulfilled và JSON hợp lệ) */
function listFromSettled(settled) {
  if (!settled || settled.status !== 'fulfilled' || !settled.value) return [];
  return extractApiList(settled.value);
}

async function request(method, endpoint, data = null, auth = false) {
  const headers = { 'Content-Type': 'application/json', 'Accept': 'application/json' };
  const token = getToken();
  
  if (auth || token) {
    headers['Authorization'] = 'Bearer ' + token;
    console.log('[API] Using token:', token ? token.substring(0, 20) + '...' : 'NO TOKEN');
  }

  const opts = { method, headers };
  if (data) opts.body = JSON.stringify(data);

  console.log(`[API] ${method} ${API_BASE + endpoint}`, { headers, auth });
  
  try {
    const res = await fetch(API_BASE + endpoint, opts);
    const text = await res.text();
    let json = {};
    try {
      json = text ? JSON.parse(text) : {};
    } catch (e) {
      console.error('[API] Phản hồi không phải JSON:', endpoint, text?.slice(0, 200));
      throw { message: 'Invalid response', status: res.status };
    }
    console.log(`[API] Response from ${endpoint}:`, json);
    
    if (!res.ok) {
      if (res.status === 401) {
        console.error('[API] 401 Unauthorized - Token invalid or expired');
      }
      throw Object.assign({ status: res.status }, json && typeof json === 'object' ? json : { message: String(json) });
    }
    return json;
  } catch (error) {
    console.error('[API] Request failed:', error);
    throw error;
  }
}

// ── Auth ────────────────────────────────────────────────────
const Auth = {
  async login(email, password) {
    const res = await request('POST', '/auth/login', { email, password });
    if (res.success && res.data) {
      setToken(res.data.token); setUser(res.data.user);
    }
    return res;
  },
  async register(payload) {
    const res = await request('POST', '/auth/register', payload);
    if (res.success && res.data) {
      setToken(res.data.token); setUser(res.data.user);
    }
    return res;
  },
  async logout() {
    await request('POST', '/auth/logout', null, true);
    removeToken(); localStorage.removeItem('tw_user');
  },
  async me() { return request('GET', '/auth/me', null, true); },
  isLoggedIn() { return !!getToken(); },
  isAdmin() { const u = getUser(); return u && u.role === 'admin'; },
};

// ── Destinations ─────────────────────────────────────────────
const Destinations = {
  list:         (params = {}) => request('GET', '/admin/destinations?' + new URLSearchParams(params), null, true),
  get:          (id)          => request('GET', `/admin/destinations/${id}`, null, true),
  create:       (data)        => request('POST', '/admin/destinations', data, true),
  update:       (id, data)    => request('PUT', `/admin/destinations/${id}`, data, true),
  remove:       (id)          => request('DELETE', `/admin/destinations/${id}`, null, true),
  toggleStatus: (id)          => request('PATCH', `/admin/destinations/${id}/toggle-status`, null, true),
  publicList:   ()            => request('GET', '/admin/destinations', null, true),
};

// ── Tours ────────────────────────────────────────────────────
const Tours = {
  list:    (params={}) => request('GET', '/tours?' + new URLSearchParams(params)),
  get:     (id)        => request('GET', `/tours/${id}`),
  featured:()          => request('GET', '/tours/featured'),
  // Admin
  adminList:   (p={}) => request('GET', '/admin/tours?' + new URLSearchParams(p), null, true),
  adminCreate: (d)    => request('POST', '/admin/tours', d, true),
  adminUpdate: (id,d) => request('PUT', `/admin/tours/${id}`, d, true),
  adminDelete: (id)   => request('DELETE', `/admin/tours/${id}`, null, true),
};

// ── Hotels ───────────────────────────────────────────────────
const Hotels = {
  list:    (params={}) => request('GET', '/hotels?' + new URLSearchParams(params)),
  get:     (id)        => request('GET', `/hotels/${id}`),
  featured:()          => request('GET', '/hotels/featured'),
  // Admin
  adminList:   (p={}) => request('GET', '/admin/hotels?' + new URLSearchParams(p), null, true),
  adminCreate: (d)    => request('POST', '/admin/hotels', d, true),
  adminUpdate: (id,d) => request('PUT', `/admin/hotels/${id}`, d, true),
  adminDelete: (id)   => request('DELETE', `/admin/hotels/${id}`, null, true),
};

// ── Bookings ─────────────────────────────────────────────────
const Bookings = {
  myList: ()     => request('GET', '/client/bookings', null, true),
  get:    (id)   => request('GET', `/client/bookings/${id}`, null, true),
  create: (data) => request('POST', '/client/bookings', data, true),
  cancel: (id)   => request('PUT', `/client/bookings/${id}/cancel`, null, true),
  // Admin
  adminList:        (p={}) => request('GET', '/admin/bookings?' + new URLSearchParams(p), null, true),
  adminUpdateStatus:(id,s) => request('PUT', `/admin/bookings/${id}/status`, {status:s}, true),
};

// ── Admin: Promo Codes ──────────────────────────────────────────────
const Promos = {
  list:   (p={}) => request('GET', '/admin/promo-codes?' + new URLSearchParams(p), null, true),
  create: (d)    => request('POST', '/admin/promo-codes', d, true),
  update: (id,d) => request('PUT', `/admin/promo-codes/${id}`, d, true),
  remove: (id)   => request('DELETE', `/admin/promo-codes/${id}`, null, true),
};

// ── Admin: Recommendations ───────────────────────────────────────────
const Recommendations = {
  list:   (p={}) => request('GET', '/admin/recommendations?' + new URLSearchParams(p), null, true),
  create: (d)    => request('POST', '/admin/recommendations', d, true),
  update: (id,d) => request('PUT', `/admin/recommendations/${id}`, d, true),
  toggle: (id)   => request('PATCH', `/admin/recommendations/${id}/toggle`, null, true),
  remove: (id)   => request('DELETE', `/admin/recommendations/${id}`, null, true),
};

// ── Admin: Users ───────────────────────────────────────────────────
const Users = {
  list: (p={})         => request('GET', '/admin/users?' + new URLSearchParams(p), null, true),
  toggleStatus: (id)    => request('PATCH', `/admin/users/${id}/toggle-status`, null, true),
};

// ── Admin: Reviews ─────────────────────────────────────────────────
const Reviews = {
  list: (p={})           => request('GET', '/admin/reviews?' + new URLSearchParams(p), null, true),
  toggleStatus: (id)     => request('PATCH', `/admin/reviews/${id}/toggle-status`, null, true),
  remove: (id)           => request('DELETE', `/admin/reviews/${id}`, null, true),
};

// ── UI Helpers ───────────────────────────────────────────────
function toast(msg, type = 'success') {
  let area = document.getElementById('toast-area');
  if (!area) {
    area = document.createElement('div');
    area.id = 'toast-area';
    area.className = 'fixed top-4 right-4 z-[9999] space-y-2';
    document.body.appendChild(area);
  }
  const bg = type === 'success' ? 'bg-emerald-500' : type === 'error' ? 'bg-red-500' : 'bg-blue-500';
  const el = document.createElement('div');
  el.className = `px-5 py-3 rounded-xl text-white text-sm font-medium shadow-xl ${bg} translate-x-[120%] transition-all duration-300`;
  el.textContent = msg;
  area.appendChild(el);
  requestAnimationFrame(() => el.classList.remove('translate-x-[120%]'));
  setTimeout(() => { el.classList.add('translate-x-[120%]'); setTimeout(() => el.remove(), 300); }, 3000);
}

// Alias for pages that use showToast
function showToast(msg, type = 'success') { toast(msg, type); }

function showLoading(el, show = true) {
  if (show) {
    el.disabled = true;
    el._orig = el.innerHTML;
    el.innerHTML = `<svg class="animate-spin h-4 w-4 mx-auto" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/></svg>`;
  } else {
    el.disabled = false;
    el.innerHTML = el._orig;
  }
}

function formatPrice(p, perUnit = '') {
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p) + (perUnit ? `/${perUnit}` : '');
}

function starBadge(rating) {
  return `<span class="inline-flex items-center gap-1 bg-emerald-500 text-white text-xs font-bold px-2 py-0.5 rounded">⭐ ${rating}</span>`;
}

// ── Route Guard ──────────────────────────────────────────────
function requireAuth() {
  if (!Auth.isLoggedIn()) { 
    // Detect context and redirect appropriately
    const isAdmin = window.location.pathname.includes('/admin/');
    const loginPath = isAdmin ? '../client/login.html' : 'login.html';
    window.location.href = loginPath; 
    return false; 
  }
  return true;
}
function requireAdmin() {
  if (!Auth.isLoggedIn() || !Auth.isAdmin()) { 
    // Detect context and redirect appropriately
    const isAdmin = window.location.pathname.includes('/admin/');
    const loginPath = isAdmin ? '../client/login.html' : 'login.html';
    window.location.href = loginPath; 
    return false; 
  }
  return true;
}
