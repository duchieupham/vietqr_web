'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "388a8464ee9141212ec00d2f39427835",
"assets/AssetManifest.bin.json": "2859e926b120fc583c8dd31aa9e8ba91",
"assets/AssetManifest.json": "3366b8b391fb2ea0a18075b7b10cf40e",
"assets/assets/images/bg-qr-vqr.png": "cb23b24bb590f7d84dcadf4bb70312b0",
"assets/assets/images/bg_napas_qr.png": "32aab9008174212bd15f6cdc2ae5251f",
"assets/assets/images/ic-copy-blue.png": "8d9c8fb78fdabaf3288fd70f55123c3f",
"assets/assets/images/ic-debit-noti.png": "b938cd7687f2505bcb108a87ec1b95ea",
"assets/assets/images/ic-napas247.png": "f6c557ed224514a70743401191d2325c",
"assets/assets/images/ic-navigate-next-blue.png": "b2924316e253612459fcbdb0427a7822",
"assets/assets/images/ic-noti-invoice.png": "23b7b1d3d3eed425499205fc0c0ebeba",
"assets/assets/images/ic-other-noti.png": "5927356029ad59e388200053e002d48c",
"assets/assets/images/ic-success-noti.png": "b61f6f1ae5073db02b5c24668089ce9c",
"assets/assets/images/ic-viet-qr-code.png": "ad4b764b5840265e82308b1a362d7348",
"assets/assets/images/ic-viet-qr-small.png": "e575560fa5f26f960672c746e559d52f",
"assets/assets/images/ic-viet-qr.png": "befe0aaea723d18aa0afea2c2ef994a6",
"assets/assets/images/logo-small-official.png": "83cceb8107c59883494976ad9b2a3aa7",
"assets/assets/images/logo-small-round.png": "ec9e25a353aab4cd5be1fd390f2cf6b9",
"assets/assets/images/logo-splash.png": "389f5c6d38275edd3b51be8ee628c03b",
"assets/assets/images/logo_vietgr_payment.png": "042fc3e87ce05e3fc36cc17c66ea288b",
"assets/FontManifest.json": "7920de41c58b42dbd3b2fdc96094529a",
"assets/fonts/MaterialIcons-Regular.otf": "3a814b2226543174ef1030889e9955b5",
"assets/NOTICES": "a8c30e76171f01044220af561a4632cf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"firebase-messaging-sw.js": "3dc90258ccb2066c9b25d6521841a613",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "0346d117a7e27386da044e2db222f4c8",
"icons/android-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/android-icon-192x192.png": "cc0edaf14ab7ca6c305dfd14a5874ec0",
"icons/android-icon-36x36.png": "3299b1d3b31066dc52914c3d3b080b4f",
"icons/android-icon-48x48.png": "64fc77eed255c6c5848490fbb67ad407",
"icons/android-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/android-icon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/apple-icon-114x114.png": "a4d28a2f2c2bc0a9ec021e396779b3e9",
"icons/apple-icon-120x120.png": "d179e52f32611fc6dcba7e117092d622",
"icons/apple-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/apple-icon-152x152.png": "aa9744592d9401fba07a2c0a72b95348",
"icons/apple-icon-180x180.png": "0c0960cf175e2838edc7b2b21e833889",
"icons/apple-icon-57x57.png": "0ea66baf676af178f7ef7d928084f03a",
"icons/apple-icon-60x60.png": "7f711ca18d3a14cc44459b6da307e3e9",
"icons/apple-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/apple-icon-76x76.png": "cb5afd10e89e4a1ddb525096a9f1cd8d",
"icons/apple-icon-precomposed.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/apple-icon.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/browserconfig.xml": "97775b1fd3b6e6c13fc719c2c7dd0ffe",
"icons/favicon-16x16.png": "0852cf0bc1ac3fe43eb50cd8b6d0accd",
"icons/favicon-32x32.png": "2e84764908dd520b0f248bd050de29ca",
"icons/favicon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/favicon.ico": "f43709e9dd9a3265ef12c4f419e8de07",
"icons/manifest.json": "64b4f6fe038dbbf8307803bab67fe2b6",
"icons/ms-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/ms-icon-150x150.png": "77def3f60cb128fa2082d44c8f272424",
"icons/ms-icon-310x310.png": "6cbc4f3c6d61b64de313526842dbaf18",
"icons/ms-icon-70x70.png": "fb84334959dbceee6928f3682f17a88c",
"index.html": "74d26138568e02380a14b86d6f16f28c",
"/": "74d26138568e02380a14b86d6f16f28c",
"main.dart.js": "09b34d1d7bccd92205059e0d2ec58fb5",
"splash/img/dark-1x.png": "940040774642d53de6f71453e737a203",
"splash/img/dark-2x.png": "78b32172d739fcec40fd4ff9601192ec",
"splash/img/dark-3x.png": "f48cc3e4652a217cc96cec92aa343386",
"splash/img/dark-4x.png": "ce752977aef4637f4e5c40deb4a774fb",
"splash/img/light-1x.png": "940040774642d53de6f71453e737a203",
"splash/img/light-2x.png": "78b32172d739fcec40fd4ff9601192ec",
"splash/img/light-3x.png": "f48cc3e4652a217cc96cec92aa343386",
"splash/img/light-4x.png": "ce752977aef4637f4e5c40deb4a774fb",
"splash/splash.js": "d6c41ac4d1fdd6c1bbe210f325a84ad4",
"splash/style.css": "0547575a914b641f91314bc1c5a0eeee",
"toast.js": "470e738516f3c70d5d77e92d0229b445",
"version.json": "e5e961cc88c45665b8b6be7bd0ea317b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
