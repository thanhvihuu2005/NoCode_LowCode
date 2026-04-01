<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://127.0.0.1:5500',
        'http://localhost:5500',
        'http://127.0.0.1:5501',
        'http://localhost:5501',
        'http://127.0.0.1:3000',
        'http://localhost:3000',
        'http://127.0.0.1:8080',
        'http://localhost:8080',
        // Thêm origin của Live Server VS Code
        'http://127.0.0.1:5500',
        'null', // file:// protocol
    ],
    'allowed_origins_patterns' => [
        '#^http://127\.0\.0\.1:\d+$#',
        '#^http://localhost:\d+$#',
    ],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 86400,
    'supports_credentials' => true,
];
