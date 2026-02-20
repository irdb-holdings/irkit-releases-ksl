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
    onProductClicked = { imageModel, product ->
        Log.d("MyApp", "onProductClicked fired - imageTitle=${imageModel.title}, productTitle=${product.title}, productUrl=${product.linkToFollow}")
    },
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

## IRKitLens Parameters

IRKitLens has been simplified to just three parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `irEngine` | `IREngine` | **required** | Recognition engine instance |
| `onProductClicked` | `(ImageModel, ProductInCampaignDto) -> Unit` | `null` | Optional callback fired when the user taps a product in the results. Receives the parent `ImageModel` and the specific `ProductInCampaignDto` that was tapped. |
| `modifier` | `Modifier` | `Modifier` | Compose layout modifier |

Camera mode selection, gallery access, torch control, and all other UI options are handled internally by the component.

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
    modifier = Modifier.fillMaxSize()
)
```

### With Product Click Handling

```kotlin
IRKitLens(
    irEngine = irEngine,
    onProductClicked = { imageModel, product ->
        Log.d("MyApp", "onProductClicked fired - imageTitle=${imageModel.title}, productTitle=${product.title}, productUrl=${product.linkToFollow}")

        // Example: open the product page in a browser
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(product.linkToFollow))
        startActivity(intent)
    },
    modifier = Modifier.fillMaxSize()
)
```

---

## Cleanup

**Important:** `IRKit.initialize()` is **app-level** (called once in `Application.onCreate()`), but `IRKitUI.deInitialize()` is **activity-level** — call it when the user leaves the scanner activity. This flushes analytics and releases camera/UI resources for that screen. It does **not** undo the app-level `IRKit.initialize()`.

```kotlin
override fun onStop() {
    super.onStop()
    // Activity-level cleanup — matches the activity-level IRKitLens usage
    IRKitUI.deInitialize()
}
```
