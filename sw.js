/* AromaLab — Service Worker da casca PWA
 * Faz cache APENAS dos arquivos da casca (mesma origem).
 * Nunca intercepta o conteúdo do app (script.google.com/exec, outra origem).
 */
const CACHE = 'aromalab-casca-v3';
const ASSETS = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icon.svg',
  './icon-192.png',
  './icon-512.png'
];

self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open(CACHE).then(function (c) { return c.addAll(ASSETS); })
      .then(function () { return self.skipWaiting(); })
  );
});

self.addEventListener('activate', function (e) {
  e.waitUntil(
    caches.keys().then(function (chaves) {
      return Promise.all(chaves.filter(function (k) { return k !== CACHE; })
        .map(function (k) { return caches.delete(k); }));
    }).then(function () { return self.clients.claim(); })
  );
});

self.addEventListener('fetch', function (e) {
  const url = new URL(e.request.url);
  // só mexe nos arquivos da própria origem; chamadas à API (outra origem) passam direto
  if (url.origin === self.location.origin) {
    e.respondWith(
      caches.match(e.request).then(function (resp) { return resp || fetch(e.request); })
    );
  }
});
