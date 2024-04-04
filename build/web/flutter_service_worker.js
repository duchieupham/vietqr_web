'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "e5e961cc88c45665b8b6be7bd0ea317b",
"splash/img/light-2x.png": "cdbcc3808d6c990f6bed1e2f6d1afd5a",
"splash/img/dark-4x.png": "79f8a95a97fee8b85f1bf3d1d9c2ff30",
"splash/img/light-3x.png": "90f1faf8fe7af7fe0eaa0e9b0bae1d7e",
"splash/img/dark-3x.png": "90f1faf8fe7af7fe0eaa0e9b0bae1d7e",
"splash/img/light-4x.png": "79f8a95a97fee8b85f1bf3d1d9c2ff30",
"splash/img/dark-2x.png": "cdbcc3808d6c990f6bed1e2f6d1afd5a",
"splash/img/dark-1x.png": "c216d3cd17050399bae0e4b03f332e95",
"splash/img/light-1x.png": "c216d3cd17050399bae0e4b03f332e95",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "c94c38ff00a9d487c353a2d78989ea08",
"index.html": "fcaff049db1ad536503f42ebc0573ed6",
"/": "fcaff049db1ad536503f42ebc0573ed6",
"firebase-messaging-sw.js": "ac580569feefa4089ae00ab086b89ada",
"main.dart.js": "3d73a117ac748d512c2b687b5d483804",
"flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"icons/favicon-16x16.png": "0852cf0bc1ac3fe43eb50cd8b6d0accd",
"icons/favicon.ico": "f43709e9dd9a3265ef12c4f419e8de07",
"icons/apple-icon.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/apple-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/android-icon-192x192.png": "cc0edaf14ab7ca6c305dfd14a5874ec0",
"icons/apple-icon-precomposed.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/apple-icon-114x114.png": "a4d28a2f2c2bc0a9ec021e396779b3e9",
"icons/ms-icon-310x310.png": "6cbc4f3c6d61b64de313526842dbaf18",
"icons/ms-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/apple-icon-57x57.png": "0ea66baf676af178f7ef7d928084f03a",
"icons/apple-icon-152x152.png": "aa9744592d9401fba07a2c0a72b95348",
"icons/ms-icon-150x150.png": "77def3f60cb128fa2082d44c8f272424",
"icons/android-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/android-icon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/android-icon-36x36.png": "3299b1d3b31066dc52914c3d3b080b4f",
"icons/apple-icon-180x180.png": "0c0960cf175e2838edc7b2b21e833889",
"icons/favicon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/manifest.json": "e09ef311ac263278c68affec51eb0e49",
"icons/android-icon-48x48.png": "64fc77eed255c6c5848490fbb67ad407",
"icons/apple-icon-76x76.png": "cb5afd10e89e4a1ddb525096a9f1cd8d",
"icons/apple-icon-60x60.png": "7f711ca18d3a14cc44459b6da307e3e9",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/android-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/apple-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/apple-icon-120x120.png": "d179e52f32611fc6dcba7e117092d622",
"icons/favicon-32x32.png": "2e84764908dd520b0f248bd050de29ca",
"icons/ms-icon-70x70.png": "fb84334959dbceee6928f3682f17a88c",
"assets/AssetManifest.json": "f565f9898acbed21c62f4505b8890e6a",
"assets/NOTICES": "d3eda77486bede20428436fae82cf93b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/logo-small-official.png": "83cceb8107c59883494976ad9b2a3aa7",
"assets/assets/images/logo_vietgr_payment.png": "042fc3e87ce05e3fc36cc17c66ea288b",
"assets/assets/images/ic-navigate-next-blue.png": "b2924316e253612459fcbdb0427a7822",
"assets/assets/images/ic-napas247.png": "f6c557ed224514a70743401191d2325c",
"assets/assets/images/logo-splash.png": "389f5c6d38275edd3b51be8ee628c03b",
"assets/assets/images/bg_napas_qr.png": "32aab9008174212bd15f6cdc2ae5251f",
"assets/assets/images/logo-small-round.png": "ec9e25a353aab4cd5be1fd390f2cf6b9",
"assets/assets/images/ic-viet-qr.png": "befe0aaea723d18aa0afea2c2ef994a6",
"assets/assets/images/ic-viet-qr-small.png": "e575560fa5f26f960672c746e559d52f",
"toast.js": "40d00dd51847173ff28b4421e7511674",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
