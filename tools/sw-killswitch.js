// Kill-switch: ранние версии демки регистрировали PWA service worker,
// который навечно кэшировал старую сборку. Этот воркер занимает его URL,
// вычищает кэши, разрегистрируется и перезагружает открытые вкладки.
self.addEventListener('install', function () {
  self.skipWaiting();
});
self.addEventListener('activate', function (event) {
  event.waitUntil((async function () {
    var keys = await caches.keys();
    await Promise.all(keys.map(function (k) { return caches.delete(k); }));
    await self.registration.unregister();
    var clients = await self.clients.matchAll({ type: 'window' });
    clients.forEach(function (c) { c.navigate(c.url); });
  })());
});
