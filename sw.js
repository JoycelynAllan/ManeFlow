// Service Worker for ManeFlow Offline Mode
const CACHE_NAME = 'maneflow-v1';
const OFFLINE_URLS = [
    '/',
    '/index.php',
    '/dashboard.php',
    '/profile.php',
    '/recommendations.php',
    '/routines.php',
    '/forecast.php',
    '/diagnosis.php',
    '/styles.php',
    '/education.php',
    '/css/style.css',
    '/js/main.js'
];

// Install event - cache essential files
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            // Try to add all URLs, but don't fail if some fail
            return Promise.allSettled(
                OFFLINE_URLS.map(url => 
                    cache.add(url).catch(err => {
                        console.log('Failed to cache:', url, err);
                        return null;
                    })
                )
            );
        })
    );
    self.skipWaiting();
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    return self.clients.claim();
});

// Fetch event - serve from cache when offline
self.addEventListener('fetch', (event) => {
    const url = new URL(event.request.url);
    
    // Never intercept API requests - let them go through normally
    if (url.pathname.startsWith('/api/') || url.pathname.includes('/api/')) {
        return;
    }
    
    // Only handle GET requests
    if (event.request.method !== 'GET') {
        return;
    }
    
    event.respondWith(
        caches.match(event.request).then((response) => {
            // Return cached version or fetch from network
            return response || fetch(event.request).then((response) => {
                // Don't cache API calls or non-successful responses
                if (!response || response.status !== 200 || response.type !== 'basic') {
                    return response;
                }
                
                // Cache static assets only
                if (url.pathname.endsWith('.css') || 
                    url.pathname.endsWith('.js') || 
                    url.pathname.endsWith('.png') || 
                    url.pathname.endsWith('.jpg') ||
                    url.pathname.endsWith('.svg')) {
                    const responseToCache = response.clone();
                    caches.open(CACHE_NAME).then((cache) => {
                        cache.put(event.request, responseToCache);
                    });
                }
                
                return response;
            }).catch(() => {
                // If offline and page request, return offline page
                if (event.request.headers.get('accept') && event.request.headers.get('accept').includes('text/html')) {
                    return caches.match('/index.php');
                }
            });
        })
    );
});

