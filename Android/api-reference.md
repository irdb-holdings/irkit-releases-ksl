# IRKitLens API Reference

## Quick Start

```kotlin
// 1. Initialize (once, in Application.onCreate)
IRKit.Companion.initialize(context)

// 2. Create engine + launch lens (in your scanner Activity)
val irEngine = IREngine(context).apply {
    setConfiguration(IRKit.getInstance().getConfiguration())
}

IRKitLens(
    irEngine = irEngine,
    initialCameraMode = CameraMode.LIVE,
    modifier = Modifier.fillMaxSize()
)

// 3. Cleanup (when leaving the scanner)
IRKitUI.deInitialize()
```

---

## IRKit Initialization

### `IRKit.Companion.initialize(context)`

Call once at app startup. Handles all backend configuration, API keys, and analytics internally.

```java
// Java
IRKit.Companion.initialize(this);

// Kotlin
IRKit.initialize(this)
```

**Throws:** `IRKitMissingPermissionsException` if required permissions are not granted. The exception contains `missingPermissions: List<String>` listing which permissions are missing. This is non-fatal - you can catch it, request permissions, and retry.

### `IRKit.getInstance()`

Returns the initialized singleton. Throws `IllegalStateException` if called before `initialize()`.

---

## IREngine

The recognition engine. Create one per scanner screen.

```kotlin
val irEngine = IREngine(context).apply {
    setConfiguration(IRKit.getInstance().getConfiguration())
}
```

Pass this to `IRKitLens`. The engine handles all image processing and server communication internally.

---

## Camera Modes

| Mode | Behavior | UI Elements |
|------|----------|-------------|
| `CameraMode.LIVE` | Continuous recognition (~3 fps). Results appear as notification cards that can be expanded. | Mode selector at top. No bottom bar. |
| `CameraMode.SNAPSHOT` | Manual capture. User taps shutter button, then results appear in a full-screen dialog. | Mode selector at top. Bottom bar with shutter, gallery, and torch buttons. |

Set the initial mode via `initialCameraMode`. Users can switch between modes using the on-screen toggle.

---

## IRKitLens Parameters

### Core

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `irEngine` | `IREngine` | **required** | Recognition engine instance |
| `initialCameraMode` | `CameraMode` | `LIVE` | Starting camera mode |
| `modifier` | `Modifier` | `Modifier` | Compose layout modifier |
| `showGalleryButton` | `Boolean` | `true` | Show the gallery/photo picker button |
| `topContentPadding` | `Dp` | `4.dp` | Top padding for mode selector. Use `52.dp` when edge-to-edge to clear the status bar. |

### Display Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `useFitScaleType` | `Boolean` | `false` | `true` = FIT (letterbox), `false` = FILL (crop to fill) |
| `enableModeSelector` | `Boolean` | `true` | Show the LIVE/SNAPSHOT toggle |
| `showApplicationModeSelector` | `Boolean` | `true` | Show the application mode selector UI |
| `showAddButton` | `Boolean` | `true` | Show the + button (only relevant if creation is enabled) |

### Event Callbacks

All callbacks are optional. Implement only the ones you need.

| Parameter | Signature | When It Fires |
|-----------|-----------|---------------|
| `onImageRecognized` | `(ImageModel) -> Unit` | Camera successfully matches an image |
| `onImageNotRecognized` | `(Bitmap) -> Unit` | Capture fails to find a match |
| `onProductClicked` | `(ImageModel, ProductInCampaignDto) -> Unit` | User taps a product in the results |
| `onImageTapForFullDetails` | `(ImageModel) -> Unit` | User taps image for full details (LIVE expanded view) |
| `onImageCaptured` | `(Bitmap) -> Unit` | Raw bitmap captured (before recognition) |
| `onSelectImage` | `() -> Unit` | Gallery button pressed. If `null`, the built-in picker opens automatically. |
| `onTorchToggle` | `(Boolean) -> Unit` | Flashlight toggled. Receives new state (`true` = on). |

### Callback Behavior by Mode

| Callback | LIVE | SNAPSHOT |
|----------|------|----------|
| `onImageRecognized` | Fires on each match | Fires when capture matches |
| `onImageNotRecognized` | Not fired | Fires when capture fails to match |
| `onProductClicked` | Fires on product tap in notification card | Fires on product tap in detail dialog |
| `onImageTapForFullDetails` | Fires on image tap in expanded notification | Not used |

---

## Data Structures

### ImageModel

Returned in `onImageRecognized` and `onProductClicked` callbacks. The most common subtype is `ImageModel.FullImage`.

**Key fields:**

| Field | Type | Description |
|-------|------|-------------|
| `imageId` | `String` | Unique identifier |
| `title` | `String` | Content title |
| `description` | `String` | Content description |
| `displayImageUrl` | `String` | URL of the display image |
| `campaignId` | `Int` | Campaign/collection ID |
| `campaignName` | `String?` | Campaign/collection name |
| `products` | `List<ProductInCampaignDto>` | Products linked to this image |

**Helper methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `getLinks()` | `MetaContent.Link?` | Associated link URL and behavior |
| `getCardType()` | `String` | Card type: "ArtCard", "Contact", "ProductCard", "General" |
| `getArtistName()` | `String` | Artist name from metadata |
| `getImageTitle()` | `String` | Title from metadata |

### ProductInCampaignDto

Returned in the `onProductClicked` callback. Represents a single product linked to a recognized image.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String?` | Product identifier |
| `imageUrl` | `String` | Product image URL |
| `title` | `String` | Product name |
| `linkToFollow` | `String` | URL to open when selected |

---

## Examples

### Minimal Scanner

```kotlin
IRKitLens(
    irEngine = irEngine,
    initialCameraMode = CameraMode.LIVE,
    modifier = Modifier.fillMaxSize()
)
```

### With Product Click Handling

```kotlin
IRKitLens(
    irEngine = irEngine,
    initialCameraMode = CameraMode.LIVE,
    showGalleryButton = true,
    topContentPadding = 52.dp,
    modifier = Modifier.fillMaxSize(),
    onProductClicked = { imageModel, product ->
        // Open the product page
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(product.linkToFollow))
        startActivity(intent)
    }
)
```

### With Full Event Logging

```kotlin
IRKitLens(
    irEngine = irEngine,
    initialCameraMode = CameraMode.LIVE,
    showGalleryButton = true,
    topContentPadding = 52.dp,
    modifier = Modifier.fillMaxSize(),
    onImageRecognized = { imageModel ->
        Log.d("Scanner", "Matched: ${imageModel.title}")
        Log.d("Scanner", "Products: ${imageModel.products.size}")
    },
    onImageNotRecognized = { bitmap ->
        Log.d("Scanner", "No match (${bitmap.width}x${bitmap.height})")
    },
    onProductClicked = { imageModel, product ->
        Log.d("Scanner", "Product: ${product.title} -> ${product.linkToFollow}")
    }
)
```

---

## Cleanup

Call `IRKitUI.deInitialize()` when the user leaves the scanner screen. This flushes analytics and releases resources.

```kotlin
override fun onStop() {
    super.onStop()
    IRKitUI.deInitialize()
}
```
