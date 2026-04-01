/**
 * Authentication API Helper Functions
 * For use in test pages and standalone auth operations
 */

/**
 * Login user with email and password
 * @param {string} email 
 * @param {string} password 
 * @returns {Promise<Object>} API response
 */
async function loginUser(email, password) {
    try {
        const response = await fetch('http://127.0.0.1:8000/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.message || `HTTP ${response.status}`);
        }

        // Save token and user to localStorage if login successful
        if (data.success && data.data && data.data.token) {
            localStorage.setItem('tw_token', data.data.token);
            localStorage.setItem('tw_user', JSON.stringify(data.data.user));
            console.log('[AUTH] Login successful, token saved');
        }

        return data;
    } catch (error) {
        console.error('[AUTH] Login failed:', error);
        throw error;
    }
}

/**
 * Register new user
 * @param {Object} userData - User registration data
 * @returns {Promise<Object>} API response
 */
async function registerUser(userData) {
    try {
        const response = await fetch('http://127.0.0.1:8000/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(userData)
        });

        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.message || `HTTP ${response.status}`);
        }

        // Save token and user to localStorage if registration successful
        if (data.success && data.data && data.data.token) {
            localStorage.setItem('tw_token', data.data.token);
            localStorage.setItem('tw_user', JSON.stringify(data.data.user));
            console.log('[AUTH] Registration successful, token saved');
        }

        return data;
    } catch (error) {
        console.error('[AUTH] Registration failed:', error);
        throw error;
    }
}

/**
 * Test API endpoint with current token
 * @param {string} endpoint - API endpoint to test
 * @returns {Promise<Object>} API response
 */
async function testApiWithToken(endpoint) {
    const token = localStorage.getItem('tw_token');
    
    if (!token) {
        throw new Error('No token found in localStorage');
    }

    try {
        const response = await fetch(`http://127.0.0.1:8000/api${endpoint}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        });

        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(data.message || `HTTP ${response.status}`);
        }

        return data;
    } catch (error) {
        console.error('[AUTH] API test failed:', error);
        throw error;
    }
}

/**
 * Check if backend is running
 * @returns {Promise<Object>} Health check response
 */
async function checkBackendHealth() {
    try {
        const response = await fetch('http://127.0.0.1:8000/api/health');
        const data = await response.json();
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        return data;
    } catch (error) {
        console.error('[AUTH] Backend health check failed:', error);
        throw error;
    }
}