# IRKit Library Integration Guide

This guide walks you through integrating the IRKit libraries (irkit-library, irkit-ui, and irkit-analytics) into your Android application.

## Prerequisites

- Android Studio Arctic Fox (2020.3.1) or newer
- Minimum SDK: 33 (Android 13)
- Target SDK: 35
- Java 17 or Kotlin 2.2+
- Existing Android application (Java or Kotlin, XML or Compose)

---

## Contents

**[Step 1: Add the IRKit Maven Repository](#step-1-add-the-irkit-maven-repository)**
Add the IRKit Maven repository URL to your project's `settings.gradle.kts`. Gradle will download the libraries automatically - no AAR files to copy.

**[Step 2: Configure Gradle](#step-2-configure-gradle)**
Update your version catalog, project-level gradle, and app-level gradle to include the IRKit dependencies and enable Compose.

**[Step 3: Configure AndroidManifest.xml](#step-3-configure-androidmanifestxml)**
Add the required permissions for camera, location, storage, and network access. IRKit needs these to scan products and report analytics.

**[Step 4: Initialize IRKit in Application Class](#step-4-initialize-irkit-in-application-class)**
Create or modify your Application class to call `IRKit.initialize()` at startup. This single call handles all backend configuration, API keys, and analytics setup internally.

**[Step 5: Request Required Permissions](#step-5-request-required-permissions)**
Request camera, location, and gallery permissions at runtime before opening the scanner. All permissions must be granted or the camera will not start.

**[Step 6: Launch IRKitLens](#step-6-launch-irkitlens)**
Create a self-contained Kotlin activity that hosts the IRKitLens camera scanner, register it in your manifest, and launch it with a standard Intent from anywhere in your app.

**[Step 7: Handle Product Events (Optional)](#step-7-handle-product-events-optional)**
Use optional callbacks on IRKitLens to receive product recognition and click events in your app.

**[Step 8: Test Your Integration](#step-8-test-your-integration)**
Build, run, grant permissions, and point your camera at a product to verify everything is working end-to-end.

---

## Step 1: Add the IRKit Maven Repository

The IRKit libraries are hosted on a Maven repository. Add it to your `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()

        // IRKit Maven repository
        maven {
            url = uri("https://irdb-holdings.github.io/irkit-releases-ksl")
        }
    }
}
```

That's it - Gradle will download the libraries and all their transitive dependencies automatically. No AAR files to copy.

---

## Step 2: Configure Gradle

### 2.1 Update `libs.versions.toml`

**Warning: Kotlin BOM Version**

The Kotlin BOM version is critical for compatibility. Using mismatched versions will cause compilation errors and runtime crashes.

In your project's `gradle/libs.versions.toml`, add or update these versions:

```toml
[versions]
kotlin = "2.2.21"                    # Must be 2.2.21 or newer
composeBom = "2025.01.00"            # Compose BOM version
agp = "8.13.2"                       # Android Gradle Plugin
coreKtx = "1.16.0"
lifecycleRuntimeKtx = "2.9.0"
activityCompose = "1.10.1"

[libraries]
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version.ref = "coreKtx" }
androidx-lifecycle-runtime-ktx = { group = "androidx.lifecycle", name = "lifecycle-runtime-ktx", version.ref = "lifecycleRuntimeKtx" }
androidx-activity-compose = { group = "androidx.activity", name = "activity-compose", version.ref = "activityCompose" }
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "composeBom" }
androidx-ui = { group = "androidx.compose.ui", name = "ui" }
androidx-ui-graphics = { group = "androidx.compose.ui", name = "ui-graphics" }
androidx-material3 = { group = "androidx.compose.material3", name = "material3" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
jetbrains-kotlin-android = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
compose-compiler = { id = "org.jetbrains.kotlin.plugin.compose", version.ref = "kotlin" }
```

### 2.2 Update `build.gradle.kts` (Project Level)

In your project-level `build.gradle.kts`:

```kotlin
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
    alias(libs.plugins.compose.compiler) apply false
}
```

### 2.3 Update `build.gradle.kts` (App Module)

In your `app/build.gradle.kts`, add the following:

```kotlin
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.jetbrains.kotlin.android)
    alias(libs.plugins.compose.compiler)
}

android {
    namespace = "com.yourcompany.yourapp"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.yourcompany.yourapp"
        minSdk = 33
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        buildConfig = true
        compose = true       // Enable Compose
        viewBinding = true   // Optional: for XML layouts
    }
}

dependencies {
    // ========== IRKit Libraries (from Maven) ==========
    // All transitive dependencies (CameraX, Coil, OkHttp, Gson, Firebase,
    // coroutines, Guava, etc.) are resolved automatically via Maven.
    implementation("com.irdb:irkit-library:2026.1.022020261207")
    implementation("com.irdb:irkit-ui:2026.1.022020261207")
    implementation("com.irdb:irkit-analytics:2026.1.022020261207")  // Used internally - no configuration needed

    // ========== Core Android Dependencies ==========
    implementation("androidx.core:core-ktx:1.16.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // ========== Compose Dependencies (REQUIRED for IRKitLens) ==========
    implementation(platform(libs.androidx.compose.bom))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.9.0")
}
```

**Note:** You do NOT need to manually declare CameraX, Coil, OkHttp, Gson, Firebase, coroutines, Guava, Volley, paging, or security-crypto dependencies. These are all pulled automatically as transitive dependencies from the IRKit Maven artifacts.

### 2.4 Sync Gradle

Click **"Sync Now"** in Android Studio to download all dependencies.

---

## Step 3: Configure AndroidManifest.xml

Add required permissions to your `AndroidManifest.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Camera permissions (REQUIRED) -->
    <uses-feature
        android:name="android.hardware.camera"
        android:required="true" />
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Storage/Gallery permissions (REQUIRED) -->
    <uses-permission
        android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <!-- Network permissions (REQUIRED) -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <!-- Location permissions (REQUIRED for analytics) -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <!-- Analytics permissions -->
    <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:name=".YourApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/Theme.YourApp">

        <!-- Your activities here -->

    </application>
</manifest>
```

---

## Step 4: Initialize IRKit in Application Class

Create or modify your Application class to initialize IRKit when your app starts.

**Create/Modify `YourApplication.java`:**

```java
package com.yourcompany.yourapp;

import android.app.Application;
import android.util.Log;
import com.irdb.irkit.IRKit;
import com.irdb.irkit.IRKitMissingPermissionsException;

public class YourApplication extends Application {

    private static final String TAG = "YourApplication";

    @Override
    public void onCreate() {
        super.onCreate();

        try {
            // Initialize IRKit library - that's it!
            // All configuration is handled internally by the library
            IRKit.Companion.initialize(this);

            Log.d(TAG, "IRKit initialized successfully");
        } catch (IRKitMissingPermissionsException e) {
            Log.w(TAG, "IRKit initialization deferred - missing permissions: "
                + e.getMissingPermissions());
            // This is OK - IRKit will initialize after permissions are granted
        } catch (Exception e) {
            Log.e(TAG, "IRKit initialization failed", e);
        }
    }
}
```

**Note:** All backend URLs, API keys, and configuration are handled internally by the IRKit libraries. You don't need to provide any configuration - just call `IRKit.initialize()`!

**Register your Application class in `AndroidManifest.xml`:**

```xml
<application
    android:name=".YourApplication"
    ...>
```

---

## Step 5: Request Required Permissions

**CRITICAL:** Your app MUST request and verify that all required permissions are granted BEFORE attempting to open IRKitLens. If permissions are not granted, the camera will fail.

**Required permissions:**
- Camera
- Gallery/Media Images
- Fine Location
- Coarse Location

### 5.1 Add Permission Request Code to Your MainActivity

```java
package com.yourcompany.yourapp;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static final int PERMISSION_REQUEST_CODE = 100;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Request all required permissions at startup
        requestAllPermissions();
    }

    private void requestAllPermissions() {
        List<String> permissionsToRequest = new ArrayList<>();

        // Camera permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            permissionsToRequest.add(Manifest.permission.CAMERA);
        }

        // Location permissions
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            permissionsToRequest.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            permissionsToRequest.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        }

        // Storage/Media permissions (Android 13+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_IMAGES)
                    != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(Manifest.permission.READ_MEDIA_IMAGES);
            }
        } else {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(Manifest.permission.READ_EXTERNAL_STORAGE);
            }
        }

        // Request permissions if needed
        if (!permissionsToRequest.isEmpty()) {
            String[] permissions = permissionsToRequest.toArray(new String[0]);
            ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                          @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == PERMISSION_REQUEST_CODE) {
            boolean allGranted = true;
            for (int result : grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    allGranted = false;
                    break;
                }
            }

            if (allGranted) {
                Toast.makeText(this, "All permissions granted!", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(this, "Some permissions were denied. Camera features may not work.",
                    Toast.LENGTH_LONG).show();
            }
        }
    }
}
```

---

## Step 6: Launch IRKitLens

Once permissions are granted and IRKit is initialized, you can launch the camera scanner.

**Note:** `IRKitLens` is a Jetpack Compose component. The activity below is a self-contained Kotlin file - you can copy it into your project as-is. The rest of your app can remain Java/XML. Compose and traditional Android views coexist without issues.

### 6.1 Create the Camera Activity

Create a new Kotlin file `IRKitCameraActivity.kt` in your source directory (e.g., `app/src/main/java/com/yourcompany/yourapp/`):

```kotlin
package com.yourcompany.yourapp

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.core.view.WindowCompat
import com.irdb.irkit.IREngine
import com.irdb.irkit.IRKit
import com.irdb.irkitui.IRKitLens
import com.irdb.irkitui.IRKitUI

class IRKitCameraActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable fullscreen edge-to-edge display
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            val context = LocalContext.current

            // Create the image-recognition engine
            val irEngine = remember(context) {
                IREngine(context).apply {
                    setConfiguration(IRKit.getInstance().getConfiguration())
                }
            }

            MaterialTheme {
                Box(modifier = Modifier.fillMaxSize()) {
                    IRKitLens(
                        irEngine = irEngine,
                        onProductClicked = { imageModel, product ->
                            Log.d(
                                "MyApp",
                                "onProductClicked fired - imageTitle=${imageModel.title}, productTitle=${product.title}, productUrl=${product.linkToFollow}"
                            )
                        },
                        modifier = Modifier.fillMaxSize()
                    )
                }
            }
        }
    }

    override fun onStop() {
        super.onStop()
        // Activity-level cleanup: flushes analytics and releases camera/UI resources.
        // This does NOT undo the app-level IRKit.initialize() from your Application class.
        IRKitUI.deInitialize()
    }
}
```

### 6.2 Register the Activity in AndroidManifest.xml

Add the following inside your `<application>` tag in `AndroidManifest.xml`:

```xml
<activity
    android:name=".IRKitCameraActivity"
    android:exported="false"
    android:screenOrientation="portrait"
    android:configChanges="orientation|screenSize" />
```

### 6.3 Launch the Activity from Your Code

From your MainActivity (or anywhere in your app), open the camera with a standard Intent:

```java
import android.content.Intent;

// Example: launch from a button click
Button openCameraButton = findViewById(R.id.button_open_camera);
openCameraButton.setOnClickListener(v -> {
    Intent intent = new Intent(MainActivity.this, IRKitCameraActivity.class);
    startActivity(intent);
});
```

---

## Step 7: Handle Product Events (Optional)

IRKitLens provides an optional `onProductClicked` callback so your app can react when the user taps a product.

### 7.1 Available Callback

#### `onProductClicked: (ImageModel, ProductInCampaignDto) -> Unit`

Called when the user taps on a product in the result view. Receives both the parent `ImageModel` and the specific `ProductInCampaignDto` that was tapped.

**`ImageModel` key fields:**

| Field | Type | Description |
|-------|------|-------------|
| `imageId` | `String` | Unique identifier for the recognized image |
| `title` | `String` | Title of the recognized content |
| `description` | `String` | Description of the recognized content |
| `displayImageUrl` | `String` | URL of the display image |
| `campaignId` | `Int` | Associated campaign ID |
| `campaignName` | `String?` | Associated campaign name |
| `products` | `List<ProductInCampaignDto>` | List of products linked to this image |

**`ProductInCampaignDto` structure:**

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String?` | Product identifier |
| `imageUrl` | `String` | URL of the product image |
| `title` | `String` | Product title/name |
| `linkToFollow` | `String` | URL to open when the product is selected |

### 7.2 Example: Handling Product Clicks

Update your `IRKitCameraActivity.kt` to include the callback:

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

## Step 8: Test Your Integration

1. **Build and run your app**
2. **Grant all permissions when prompted**
3. **Tap the button to open IRKitLens**
4. **Point your camera at products** - IRKit will recognize and display information

---

## Troubleshooting

### Issue: "IRKit configuration not set"
**Solution:** Make sure you called `IRKit.initialize(this)` in your Application's `onCreate()` method. The library handles all configuration internally.

### Issue: Camera doesn't open or crashes
**Solution:** Check that all permissions (Camera, Location, Gallery) are granted. Check logcat for `IRKitMissingPermissionsException`.

### Issue: Kotlin version conflicts
**Solution:** Ensure your `libs.versions.toml` has `kotlin = "2.2.21"` and all Kotlin dependencies use the same version. Run `./gradlew dependencies` to check for version conflicts.

### Issue: Compose version conflicts
**Solution:** Use `androidx.compose.bom:2025.01.00` (or the version specified in Step 2). Do not mix Compose versions.

### Issue: Dependency resolution failures
**Solution:** Verify that the IRKit Maven repository URL is correctly added to `settings.gradle.kts` (not `build.gradle.kts`). The URL must be `https://irdb-holdings.github.io/irkit-releases-ksl` without a trailing slash.

---

## Summary

You've successfully integrated IRKit into your Android app! The integration requires:

1. Add IRKit Maven repository to `settings.gradle.kts`
2. Add three `implementation` lines to `build.gradle.kts` - transitive dependencies are handled automatically
3. Add permissions to `AndroidManifest.xml`
4. Initialize IRKit in `Application.onCreate()` - **that's it, no configuration needed!**
5. Request runtime permissions
6. Launch `IRKitLens` in an Activity
7. (Optional) Handle product events via callbacks

**Zero Configuration:** All backend URLs, API keys, and analytics settings are handled internally by the IRKit libraries. Just call `IRKit.initialize()` and you're done!

**Need help?** Contact your IRKit support representative with your logcat output and build configuration.
