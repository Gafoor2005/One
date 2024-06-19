'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".well-known/assetlinks.json": "cb51514e5df22fc6558bd539cc06e399",
"assets/AssetManifest.bin": "4d2bf11a265e59c135d120bf57b1a010",
"assets/AssetManifest.bin.json": "8044ad39ad6176a460e85373d6600f6f",
"assets/AssetManifest.json": "936bd96032d516190b0a8c9a5acf85f3",
"assets/assets/defalutUser.jpg": "02b2ba87b5d46df60b26665fad3f41f5",
"assets/assets/devloopers.png": "bb26fe52db56ca8a8f4e297aec0a8377",
"assets/assets/google.png": "a343e13eee5ddcac9eb154cea0bcf575",
"assets/assets/icons/chat.svg": "aa1567bea946ff655df445e810f673a1",
"assets/assets/icons/chat_filled.svg": "5e4bfca095c70612706dca02be2e4ee5",
"assets/assets/icons/devloopers.svg": "1f99b88b3e6b69e34b87376bb971862d",
"assets/assets/icons/error_circle.svg": "9513de2ade17b3d35ab1d7ef0c720080",
"assets/assets/icons/home.svg": "121264abeade3c741f5dbc594742bf22",
"assets/assets/icons/home_filled.svg": "080d19d916be4e0ac94f51c78bbe0dc8",
"assets/assets/icons/library.svg": "2756eddd30c0c0733bb93d72719e1a96",
"assets/assets/icons/library_filled.svg": "0b5d84455289c3ecf5eeec1e298d8423",
"assets/assets/icons/microsoft.svg": "72bf1e819ab2b22a29c6715e865d5cd0",
"assets/assets/icons/micro_map.svg": "76acbfee166fecad8b2be56b2f0811c8",
"assets/assets/icons/micro_team.svg": "5333fc4e11ad55b1bd36289ad24c4a7b",
"assets/assets/icons/person.svg": "90d6b6c2252c6e5dbdce7cd06ecc2cd7",
"assets/assets/icons/person_filled.svg": "4d3bc1b43228d6ddac1569590c3b57db",
"assets/assets/icons/privacy-policy.svg": "6f28a47cd0710b375d2c7e5d0af67fb0",
"assets/assets/icons/window_new.svg": "eaa78d60fd7cda77ee09a4638ddede84",
"assets/assets/logo.jpg": "2064bcf45eecaa519298bf8f3fe37be0",
"assets/assets/microsoft.svg": "df48df66ff0c725c2ba6bc3847c7a6f0",
"assets/assets/privacy_policy.txt": "f005c6d9fa9b17bffdf2c314a286c285",
"assets/assets/user-solid.svg": "6e89efd3b1cc8bd9ddd8fa74f0a57f90",
"assets/assets/userIcon.png": "8b5e2d424fbb902a3ee9dd86d60c66bd",
"assets/assets/userIconDark.png": "d803ae74413931be0e310d0857627cf8",
"assets/FontManifest.json": "b2e00bd2b639726d61d07d63bedc41cb",
"assets/fonts/AlegreyaSans-ExtraBold.ttf": "cd14167c1e191dcea91a872a39747f8a",
"assets/fonts/BlackHanSans-Regular.ttf": "cfb4e44fb6ad8254b8b9fba20ade1fca",
"assets/fonts/FlowCircular-Regular.ttf": "f6a845d2946a67833cdff996ec76a360",
"assets/fonts/Inter-VariableFont_slnt,wght.ttf": "32204736a4290ec41200abe91e5190d1",
"assets/fonts/MaterialIcons-Regular.otf": "17a41c48aea207c6f4dbcf7056f492e5",
"assets/fonts/NotoSans-Black.ttf": "4ae705e1503cdbbd516dc6b636829dfc",
"assets/fonts/NotoSans-Bold.ttf": "24d5e8ab973d38b3a7e30bd632bca199",
"assets/fonts/NotoSans-ExtraBold.ttf": "e28fd1ec0d14930fbfd9ab37e6c589f5",
"assets/fonts/NotoSans-Medium.ttf": "3bd7db14b9378adf7827b23af6f67501",
"assets/NOTICES": "7da60b6313ce68f1fe36318b97f27921",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "5fdd2f73a08ca4388e568ef0469ed3a9",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "431b5521733840e785c033808c438326",
"assets/pubspec.yaml": "68afde62f5ab349f0cc7599492637b49",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "f65a9ddcbae5136a673c8e79e30be74d",
"/": "f65a9ddcbae5136a673c8e79e30be74d",
"main.dart.js": "1dd88e7a445b4f13edba3ca3ceb79fa8",
"manifest.json": "97af3a43ccb2787b6977738527fe0c4b",
"version.json": "34b34c1d691c821ccac90538851646d5"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
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
