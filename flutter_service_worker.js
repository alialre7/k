'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ca960a3970e814457440f0992a834698",
"assets/AssetManifest.bin.json": "c3ed0979e7a9634e46689fa955fdf443",
"assets/AssetManifest.json": "90138ab238e4926307137bb861553054",
"assets/assets/images/intro_bg.jpg": "1619ffaa9bcce12f2a22c00c48386417",
"assets/assets/images/language_bg.jpg": "73f1ec03cecf0b5913d7a5d8f514805c",
"assets/assets/images/quiz_bg.jpg": "dc3789ea01d48ee9fdec1850ef1e89c4",
"assets/assets/images/quiz_headers/1.jpg": "6229030e47005561fc4eedf934b75158",
"assets/assets/images/quiz_headers/1.webp": "be91398150f25b489e13e329fd27b2b6",
"assets/assets/images/quiz_headers/10.jpg": "201b8c34a72e714278b1025c2ce5e3c4",
"assets/assets/images/quiz_headers/11.jpg": "0b851fe9243d01ddb64e5527eb666008",
"assets/assets/images/quiz_headers/12.jpg": "b8e98e56787b81dbde47115fbf731f0f",
"assets/assets/images/quiz_headers/13.jpg": "72046e260ed77752dff81d1009e99713",
"assets/assets/images/quiz_headers/14.jpg": "621f82b9189f0c3589d5d7ca2018293d",
"assets/assets/images/quiz_headers/15.jpg": "b56b45607b8be6a26e78d3a2b12a4661",
"assets/assets/images/quiz_headers/16.jpg": "8e87e3c4a781c60411d18c087e085a8e",
"assets/assets/images/quiz_headers/17.jpg": "53df7ba6093af148fa4c974b840bb693",
"assets/assets/images/quiz_headers/18.jpg": "3b581065045cc513cdfd2b1c5526a142",
"assets/assets/images/quiz_headers/19.jpg": "fced2e812837073e76947b4f621a808d",
"assets/assets/images/quiz_headers/2.jpg": "19562eae2e38971dc35f83329c1e4a6f",
"assets/assets/images/quiz_headers/2.webp": "749b6e4fc1edcc2a6f3e5936886e66aa",
"assets/assets/images/quiz_headers/20.jpg": "8b74518b575d994924a38a0fcd60a612",
"assets/assets/images/quiz_headers/21.jpg": "25661b2486486de888f2adfa50242151",
"assets/assets/images/quiz_headers/22.jpg": "b3114a5dc92fc787972d40ee351e8c9a",
"assets/assets/images/quiz_headers/23.jpg": "3a339c5dc074100c2b2bc01a0d97813b",
"assets/assets/images/quiz_headers/24.jpg": "0bd85b99e4988865c97624a058647070",
"assets/assets/images/quiz_headers/25.jpg": "e40b1538a66f8fc6e68e5aa2f97f1d5f",
"assets/assets/images/quiz_headers/26.jpg": "9bb5b54bd10a1604dc83141585287859",
"assets/assets/images/quiz_headers/27.jpg": "fb6c0488a890815693c9e2f0335efd54",
"assets/assets/images/quiz_headers/28.jpg": "66c641fbc534b264a46c0ea7e62ada45",
"assets/assets/images/quiz_headers/29.jpg": "61971bd5029d99d558a77edfdf1eaae9",
"assets/assets/images/quiz_headers/3.jpg": "0ca0a1adc90a169c930c2d928d1a9f1b",
"assets/assets/images/quiz_headers/3.webp": "6eff0a64411198c27ec6f74f46605094",
"assets/assets/images/quiz_headers/30.jpg": "e57c76ff67efdda0d4a186af96ae059c",
"assets/assets/images/quiz_headers/31.jpg": "0e6524de61cd6b574e89f4076ef9020e",
"assets/assets/images/quiz_headers/32.jpg": "fee53678a185dc0bb642b5fcb8272c66",
"assets/assets/images/quiz_headers/33.jpg": "046ff8b90dcb67a95411a1cc556fc751",
"assets/assets/images/quiz_headers/34.jpg": "cfb1fcaa58f83a54014c739955c973dd",
"assets/assets/images/quiz_headers/35.jpg": "e6aac3e75146e2bc68922473320f7da6",
"assets/assets/images/quiz_headers/36.jpg": "3247d9a1809116eea0dd7f58568cb081",
"assets/assets/images/quiz_headers/37.jpg": "2a9025de89a6f6490548c52cf8eaaf70",
"assets/assets/images/quiz_headers/38.jpg": "1619ffaa9bcce12f2a22c00c48386417",
"assets/assets/images/quiz_headers/39.jpg": "c255a51f89a0b1c5abbf3af3ee77c00f",
"assets/assets/images/quiz_headers/4.jpg": "8e87e3c4a781c60411d18c087e085a8e",
"assets/assets/images/quiz_headers/40.jpg": "a4039b6dab176c364b756846ac7095cd",
"assets/assets/images/quiz_headers/41.jpg": "6b7ba92ca1d4476610e41e9ebc5aec05",
"assets/assets/images/quiz_headers/42.jpg": "f30ef4e4836e7e38b4bbc3f4c422f3b8",
"assets/assets/images/quiz_headers/43.jpg": "f27cf60628d90ee2e52714b5f57a0707",
"assets/assets/images/quiz_headers/44.jpg": "33b90e93598c78a044e723ac34c5b7a3",
"assets/assets/images/quiz_headers/45.jpg": "950d7a9f485efc787ebaa94c5cd39999",
"assets/assets/images/quiz_headers/46.jpg": "82029b7daa4a027ee8fd475063c02f3f",
"assets/assets/images/quiz_headers/47.jpg": "c7f308733fa63eb33401ff516c295d00",
"assets/assets/images/quiz_headers/48.jpg": "cc2a4a56b63ff74ac2e4afc2dd9f3f3a",
"assets/assets/images/quiz_headers/5.jpg": "f357bf989e8b62e3e19f1e1f83320dd7",
"assets/assets/images/quiz_headers/6.jpg": "f5e9c0650204ccc25de27ccef6b6450b",
"assets/assets/images/quiz_headers/7.jpg": "68dd044462bf140d8a9768d7e1c9c86f",
"assets/assets/images/quiz_headers/8.jpg": "0f47b44195235d9da247345ba774e6f3",
"assets/assets/images/quiz_headers/9.jpg": "a48e10fd7c96e1700ab97561b99fb905",
"assets/assets/lang/ar.json": "07f1dc89cb8cdfddb7107154fc92f10e",
"assets/assets/lang/en.json": "dd734818477ebbfc400855857c7a4573",
"assets/assets/sounds/average.wav": "8397272cb1bd4b8b3382a4e8268fe9ed",
"assets/assets/sounds/bad.wav": "5626df4ac3b7ea1eeda7312fef763e43",
"assets/assets/sounds/button_click.mp3": "d9ab495e39f2a701c713cc053293376c",
"assets/assets/sounds/cancel.mp3": "d5b5de720471df7399bcd72269b611cc",
"assets/assets/sounds/correct.mp3": "ba281d59b247e6248e8603ad61a768f0",
"assets/assets/sounds/excellent.wav": "0831d581d2789ace24690901067fd2f3",
"assets/assets/sounds/fail.wav": "b40887310567d33fcba215ff5ed88f98",
"assets/assets/sounds/good.wav": "5b88b3032fd68c3f7a8ce28b10324e9f",
"assets/assets/sounds/logout.mp3": "b62e36a13b1c74f1f0a70f6f0b0f90cf",
"assets/assets/sounds/timeout.mp3": "6ec12bd6c40f7f5a28be6118d1bf5802",
"assets/assets/sounds/wrong.mp3": "9a303d44808880f3fd4ebd1dfe9148b3",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "666851fe3621b5dff2f51afeff52867f",
"assets/NOTICES": "90abdd4e91d64a3026a87050d61f1b50",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "8a4bc96a5159336fbb190f32d1ba386e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9b70787cdf446dfe33f258427eb52790",
"/": "9b70787cdf446dfe33f258427eb52790",
"main.dart.js": "a7bc2dd289ba345675c921187658a316",
"manifest.json": "09ba21f138597152290c76edb4f865ba",
"version.json": "021de28a8ba569f868bbf0b215bde959"};
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
