# AI Prompt: Build IRKit Test Application

Copy and paste this entire prompt into your AI assistant to generate a complete working Android application that integrates the IRKit libraries.

---

## PROMPT START

I need you to create a complete Android application in Java with XML layouts that integrates the IRKit libraries from a Maven repository.

### Project Requirements

**Basic Configuration:**
- Package name: `com.irkit.testapp`
- App name: "IRKit Test App"
- Minimum SDK: 33 (Android 13)
- Target SDK: 35
- Compile SDK: 35
- Java version: 17
- Kotlin version: 2.2.21 (required for library compatibility)
- Compose BOM: 2025.01.00

**Project Structure:**
Create a standard Android app with:
- MainActivity (Java with XML layout)
- IRKitLensActivity (Kotlin with Compose UI)
- TestApplication (Java) - custom Application class for zero-config IRKit initialization

---

### Step-by-Step Implementation

#### 1. Create `gradle/libs.versions.toml`

```toml
[versions]
kotlin = "2.2.21"
composeBom = "2025.01.00"
agp = "8.13.2"
coreKtx = "1.16.0"
lifecycleRuntimeKtx = "2.9.0"
activityCompose = "1.10.1"

[libraries]
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version.ref = "coreKtx" }
androidx-lifecycle-runtime-ktx = { group = "androidx.lifecycle", name = "lifecycle-runtime-ktx", version.ref = "lifecycleRuntimeKtx" }
androidx-activity-compose = { group = "androidx.activity", name = "activity-compose", version.ref = "activityCompose" }
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "composeBom" }
androidx-ui = { group = "androidx.compose.ui", name = "ui" }
androidx-material3 = { group = "androidx.compose.material3", name = "material3" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
jetbrains-kotlin-android = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
compose-compiler = { id = "org.jetbrains.kotlin.plugin.compose", version.ref = "kotlin" }
```

#### 2. Create `build.gradle.kts` (Project Level)

```kotlin
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
    alias(libs.plugins.compose.compiler) apply false
}
```

#### 3. Create `settings.gradle.kts`

```kotlin
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

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

rootProject.name = "IRKit Test App"
include(":app")
```

#### 4. Create `build.gradle.kts` (App Module)

```kotlin
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.jetbrains.kotlin.android)
    alias(libs.plugins.compose.compiler)
}

android {
    namespace = "com.irkit.testapp"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.irkit.testapp"
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
        compose = true
        viewBinding = true
    }
}

dependencies {
    // ========== IRKit Libraries (from Maven) ==========
    // All transitive dependencies (CameraX, Coil, OkHttp, Gson, etc.)
    // are resolved automatically via Maven.
    implementation("com.irdb:irkit-library:2026.1")
    implementation("com.irdb:irkit-ui:2026.1")
    implementation("com.irdb:irkit-analytics:2026.1")  // Used internally - no configuration needed

    // ========== Core Android ==========
    implementation("androidx.core:core-ktx:1.16.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // ========== Compose (REQUIRED for IRKitLens) ==========
    implementation(platform(libs.androidx.compose.bom))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.foundation:foundation")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.lifecycle:lifecycle-runtime-compose:2.9.0")
}
```

**Note:** CameraX, Coil, OkHttp, Gson, Firebase, coroutines, and all other IRKit dependencies are pulled automatically via Maven. You only need to declare the three IRKit libraries and your own app's dependencies (Compose, AppCompat, etc.).

#### 5. Create `AndroidManifest.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Camera permissions -->
    <uses-feature
        android:name="android.hardware.camera"
        android:required="true" />
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Storage/Gallery permissions -->
    <uses-permission
        android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <!-- Network permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <!-- Location permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <!-- Analytics permissions -->
    <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:name=".TestApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="IRKit Test App"
        android:theme="@style/Theme.MaterialComponents.DayNight.DarkActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name=".IRKitLensActivity"
            android:exported="false"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.MaterialComponents.DayNight.NoActionBar" />
    </application>
</manifest>
```

#### 6. Create `TestApplication.java`

```java
package com.irkit.testapp;

import android.app.Application;
import android.util.Log;
import com.irdb.irkit.IRKit;
import com.irdb.irkit.IRKitMissingPermissionsException;

public class TestApplication extends Application {

    private static final String TAG = "TestApplication";
    public static String pendingPermissionMessage;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "TestApplication onCreate");

        try {
            // Initialize IRKit - that's it! No configuration needed.
            // All backend URLs, API keys, and analytics are handled internally.
            IRKit.Companion.initialize(this);
            pendingPermissionMessage = null;
            Log.d(TAG, "IRKit initialized successfully");
        } catch (IRKitMissingPermissionsException e) {
            pendingPermissionMessage = "Missing permissions: " + e.getMissingPermissions();
            Log.w(TAG, pendingPermissionMessage);
        } catch (Exception e) {
            Log.e(TAG, "IRKit initialization failed", e);
        }
    }

    public static void retryIRKitInit(android.content.Context context) {
        try {
            IRKit.Companion.initialize(context.getApplicationContext());
            pendingPermissionMessage = null;
        } catch (Exception e) {
            Log.e(TAG, "IRKit retry failed", e);
        }
    }
}
```

#### 7. Create `MainActivity.java`

```java
package com.irkit.testapp;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static final int PERMISSION_REQUEST_CODE = 100;
    private TextView statusTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        statusTextView = findViewById(R.id.status_text);
        FloatingActionButton fab = findViewById(R.id.fab_camera);

        // FAB click listener - open IRKitLens
        fab.setOnClickListener(v -> {
            if (TestApplication.pendingPermissionMessage != null) {
                Toast.makeText(this, TestApplication.pendingPermissionMessage,
                    Toast.LENGTH_LONG).show();
                return;
            }

            if (!allPermissionsGranted()) {
                Toast.makeText(this, "Please grant all permissions first",
                    Toast.LENGTH_LONG).show();
                requestAllPermissions();
                return;
            }

            // Launch IRKitLens activity
            Intent intent = new Intent(MainActivity.this, IRKitLensActivity.class);
            startActivity(intent);
        });

        // Request permissions on startup
        requestAllPermissions();
        updateStatus();
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateStatus();
    }

    private void updateStatus() {
        StringBuilder status = new StringBuilder();
        status.append("IRKit Test App\n\n");

        if (TestApplication.pendingPermissionMessage != null) {
            status.append("Warning: ").append(TestApplication.pendingPermissionMessage).append("\n\n");
        } else {
            status.append("IRKit Initialized\n\n");
        }

        status.append("Permissions:\n");
        status.append("Camera: ").append(getPermissionStatus(Manifest.permission.CAMERA)).append("\n");
        status.append("Location: ").append(getLocationPermissionStatus()).append("\n");

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            status.append("Gallery: ").append(
                getPermissionStatus(Manifest.permission.READ_MEDIA_IMAGES)
            ).append("\n");
        } else {
            status.append("Storage: ").append(
                getPermissionStatus(Manifest.permission.READ_EXTERNAL_STORAGE)
            ).append("\n");
        }

        status.append("\nTap the camera button to scan!");

        statusTextView.setText(status.toString());
    }

    private String getPermissionStatus(String permission) {
        return isPermissionGranted(permission) ? "Granted" : "Denied";
    }

    private String getLocationPermissionStatus() {
        boolean fine = isPermissionGranted(Manifest.permission.ACCESS_FINE_LOCATION);
        boolean coarse = isPermissionGranted(Manifest.permission.ACCESS_COARSE_LOCATION);
        return (fine && coarse) ? "Granted" : "Denied";
    }

    private boolean isPermissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(this, permission)
                == PackageManager.PERMISSION_GRANTED;
    }

    private boolean allPermissionsGranted() {
        if (!isPermissionGranted(Manifest.permission.CAMERA)) return false;
        if (!isPermissionGranted(Manifest.permission.ACCESS_FINE_LOCATION)) return false;
        if (!isPermissionGranted(Manifest.permission.ACCESS_COARSE_LOCATION)) return false;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return isPermissionGranted(Manifest.permission.READ_MEDIA_IMAGES);
        } else {
            return isPermissionGranted(Manifest.permission.READ_EXTERNAL_STORAGE);
        }
    }

    private void requestAllPermissions() {
        List<String> permissionsToRequest = new ArrayList<>();

        if (!isPermissionGranted(Manifest.permission.CAMERA)) {
            permissionsToRequest.add(Manifest.permission.CAMERA);
        }
        if (!isPermissionGranted(Manifest.permission.ACCESS_FINE_LOCATION)) {
            permissionsToRequest.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }
        if (!isPermissionGranted(Manifest.permission.ACCESS_COARSE_LOCATION)) {
            permissionsToRequest.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (!isPermissionGranted(Manifest.permission.READ_MEDIA_IMAGES)) {
                permissionsToRequest.add(Manifest.permission.READ_MEDIA_IMAGES);
            }
        } else {
            if (!isPermissionGranted(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                permissionsToRequest.add(Manifest.permission.READ_EXTERNAL_STORAGE);
            }
        }

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
                TestApplication.retryIRKitInit(this);
            } else {
                Toast.makeText(this, "Some permissions denied", Toast.LENGTH_LONG).show();
            }

            updateStatus();
        }
    }
}
```

#### 8. Create `res/layout/activity_main.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.coordinatorlayout.widget.CoordinatorLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical"
        android:padding="24dp"
        android:gravity="center">

        <TextView
            android:id="@+id/status_text"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:textSize="16sp"
            android:textColor="@android:color/black"
            android:text="Loading..."
            android:gravity="center" />

    </LinearLayout>

    <com.google.android.material.floatingactionbutton.FloatingActionButton
        android:id="@+id/fab_camera"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="bottom|end"
        android:layout_margin="24dp"
        android:contentDescription="Open Camera"
        app:srcCompat="@android:drawable/ic_menu_camera"
        app:tint="@android:color/white" />

</androidx.coordinatorlayout.widget.CoordinatorLayout>
```

#### 9. Create `IRKitLensActivity.kt`

```kotlin
package com.irkit.testapp

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.core.view.WindowCompat
import com.irdb.irkit.IREngine
import com.irdb.irkit.IRKit
import com.irdb.irkitui.CameraMode
import com.irdb.irkitui.IRKitLens
import com.irdb.irkitui.IRKitUI

class IRKitLensActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable fullscreen edge-to-edge
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            val context = LocalContext.current

            // Create IREngine instance
            val irEngine = remember(context) {
                IREngine(context).apply {
                    setConfiguration(IRKit.getInstance().getConfiguration())
                }
            }

            MaterialTheme {
                Box(modifier = Modifier.fillMaxSize()) {
                    // IRKitLens - fullscreen camera with product event callbacks
                    IRKitLens(
                        irEngine = irEngine,
                        initialCameraMode = CameraMode.LIVE,
                        showGalleryButton = true,
                        topContentPadding = 52.dp,
                        modifier = Modifier.fillMaxSize(),

                        // --- Product Event Callbacks ---
                        onImageRecognized = { imageModel ->
                            // Called when camera recognizes an image
                            Log.d("IRKitTest", "Recognized: ${imageModel.title}")
                            Log.d("IRKitTest", "Products: ${imageModel.products.size}")
                        },
                        onImageNotRecognized = { bitmap ->
                            // Called when camera fails to recognize an image
                            Log.d("IRKitTest", "Not recognized: ${bitmap.width}x${bitmap.height}")
                        },
                        onProductClicked = { imageModel, product ->
                            // Called when user taps a product in the results
                            Log.d("IRKitTest", "Product clicked: ${product.title}")
                            Log.d("IRKitTest", "Product URL: ${product.linkToFollow}")
                            Log.d("IRKitTest", "Product image: ${product.imageUrl}")

                            // Example: open the product URL in a browser
                            // val intent = Intent(Intent.ACTION_VIEW, Uri.parse(product.linkToFollow))
                            // startActivity(intent)
                        }
                    )

                    // Close button (top-left)
                    FloatingActionButton(
                        onClick = { finish() },
                        modifier = Modifier
                            .align(Alignment.TopStart)
                            .statusBarsPadding()
                            .padding(start = 16.dp, top = 16.dp)
                            .size(56.dp),
                        containerColor = Color.Black.copy(alpha = 0.6f)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Close,
                            contentDescription = "Close",
                            tint = Color.White
                        )
                    }
                }
            }
        }
    }

    override fun onStop() {
        super.onStop()
        IRKitUI.deInitialize()
    }
}
```

---

### Additional Requirements

1. **Create standard Android resources:**
   - `res/mipmap/ic_launcher.png` (default launcher icon)
   - `res/values/strings.xml` with app name
   - `res/values/colors.xml` (optional)
   - `res/values/themes.xml` (use Material3 theme)

2. **Gradle wrapper:** Include standard Gradle wrapper files for Gradle 8.x

---

### Product Event Callbacks

IRKitLens provides three optional callbacks to receive product and recognition events. All callbacks are optional - implement only the ones you need.

#### `onImageRecognized: (ImageModel) -> Unit`
Called when the camera successfully recognizes an image. Receives an `ImageModel` containing:

| Field | Type | Description |
|-------|------|-------------|
| `imageId` | `String` | Unique identifier for the recognized image |
| `title` | `String` | Title of the recognized content |
| `description` | `String` | Description of the recognized content |
| `displayImageUrl` | `String` | URL of the display image |
| `campaignId` | `Int` | Associated campaign ID |
| `campaignName` | `String?` | Associated campaign name |
| `products` | `List<ProductInCampaignDto>` | List of products linked to this image |

#### `onImageNotRecognized: (Bitmap) -> Unit`
Called when the camera captures an image but fails to find a match. Receives the `Bitmap` that was not recognized.

#### `onProductClicked: (ImageModel, ProductInCampaignDto) -> Unit`
Called when the user taps on a product in the result view. Receives the `ImageModel` and the specific `ProductInCampaignDto` that was tapped.

**`ProductInCampaignDto` structure:**

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String?` | Product identifier |
| `imageUrl` | `String` | URL of the product image |
| `title` | `String` | Product title/name |
| `linkToFollow` | `String` | URL to open when the product is selected |

#### Example: Handling Product Clicks

```kotlin
onProductClicked = { imageModel, product ->
    Log.d("MyApp", "Product: ${product.title}")
    Log.d("MyApp", "URL: ${product.linkToFollow}")

    // Open the product page in a browser
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(product.linkToFollow))
    startActivity(intent)
}
```

---

### Expected Behavior

When the app is built and run:

1. App launches and requests Camera, Location, and Gallery permissions
2. Status screen shows whether permissions are granted and IRKit is initialized
3. Floating Action Button (camera icon) is visible in bottom-right corner
4. Tapping FAB opens IRKitLensActivity with fullscreen camera
5. User can scan products using LIVE or SNAPSHOT mode
6. Gallery button allows selecting images from device
7. `onImageRecognized` fires when a product image is matched
8. `onProductClicked` fires when the user taps a product in the results
9. Close button (top-left) returns to MainActivity
10. No crashes, all permissions handled gracefully

---

### Notes

- The app uses **Kotlin for IRKitLensActivity** because IRKitLens is a Compose component
- MainActivity is in **Java with XML** as requested
- All **permissions are requested at runtime** before attempting to use the camera
- The app gracefully handles cases where permissions are denied
- **Zero configuration required** - all backend URLs, API keys, and analytics are handled internally by the IRKit libraries
- **Dependencies are managed via Maven** - no AAR files to copy manually; Gradle pulls everything automatically

---

## PROMPT END

**Instructions for use:**
Copy everything between "PROMPT START" and "PROMPT END" and paste it into an AI coding assistant (like Claude, ChatGPT, or Cursor) to generate the complete project.
