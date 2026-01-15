# IRKit Libraries - Maven Deployment
Version: 25.6
Generated: 2026-01-15T13:27:21.983448

## Maven Artifacts

This folder contains the IRKit Android libraries packaged for Maven deployment.

### 1. IRKit Library (Core)
- **Artifact**: `com.irdb:irkit-library:25.6`
- **Files**: 
  - `com/irdb/irkit-library/25.6/irkit-library-25.6.aar`
  - `com/irdb/irkit-library/25.6/irkit-library-25.6.pom`
  - `com/irdb/irkit-library/25.6/irkit-library-25.6.module`

### 2. IRKit UI Library
- **Artifact**: `com.irdb:irkit-ui:25.6`
- **Files**:
  - `com/irdb/irkit-ui/25.6/irkit-ui-25.6.aar`
  - `com/irdb/irkit-ui/25.6/irkit-ui-25.6.pom`
  - `com/irdb/irkit-ui/25.6/irkit-ui-25.6.module`

## Usage in Client Projects

### Option 1: GitHub Packages (Recommended for Teams)

Add to your project's `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/YOUR-ORG/irkit-android")
            credentials {
                username = providers.gradleProperty("gpr.user").orNull 
                    ?: System.getenv("GITHUB_ACTOR")
                password = providers.gradleProperty("gpr.token").orNull 
                    ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
```

Add to your module's `build.gradle.kts`:
```kotlin
dependencies {
    implementation("com.irdb:irkit-library:25.6")
    implementation("com.irdb:irkit-ui:25.6")
}
```

**Setup Required**: See [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md) for credential configuration.

### Option 2: Local Maven Repository

Add to your project's `build.gradle` or `build.gradle.kts`:

```kotlin
repositories {
    maven {
        url = uri("/path/to/IRKit-Client-Delivery/Maven")
    }
}

dependencies {
    implementation("com.irdb:irkit-library:25.6")
    implementation("com.irdb:irkit-ui:25.6")
}
```

### Option 3: Deploy to Remote Maven Repository

Upload the contents of this folder to your Maven repository server.

#### Using Maven:
```bash
mvn deploy:deploy-file \
  -Dfile=com/irdb/irkit-library/25.6/irkit-library-25.6.aar \
  -DpomFile=com/irdb/irkit-library/25.6/irkit-library-25.6.pom \
  -DrepositoryId=your-repo-id \
  -Durl=https://your-maven-repo.com/repository/
```

#### Using Gradle:
The libraries can be published directly to a remote Maven repository by configuring
the `publishing` block in the library's build.gradle.kts file.

## Dependency Information

### IRKit Library Dependencies
The POM file includes all transitive dependencies:
- AndroidX Core, Lifecycle, Compose
- CameraX
- Firebase (Analytics, Storage, Auth, Config)
- Networking (OkHttp, Volley)
- Image Processing (Coil, AndroidSVG)
- Coroutines, Paging, Security, Location Services

### IRKit UI Library Dependencies
- Depends on `com.irdb:irkit-library:25.6`
- Additional UI dependencies: Compose, Coil, CameraX, Guava

## Notes
- All POM files are automatically generated with complete dependency information
- The `.module` files provide Gradle metadata for enhanced dependency resolution
- Both libraries require minSdk 33 and are compiled with Java 17