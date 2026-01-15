# IRKit Libraries Maven Deployment Guide
Version: 25.6

## 🚀 Quick Start - One-Click Deployment

### Deploy to Local Maven (Fastest)
```bash
./gradlew fullMavenDeploy
```

### Deploy to GitHub Packages
```bash
./gradlew deployToGitHub
```
**First time?** See [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md) for setup instructions.

### Deploy to ALL Repositories (Recommended for Releases)
```bash
./gradlew fullDeployToAll
```

## 📋 Deployment Options Summary

| Command | Target | Use Case |
|---------|--------|----------|
| `fullMavenDeploy` | Local Maven | Testing, Direct AAR distribution |
| `deployToGitHub` | GitHub Packages | CI/CD, Team distribution |
| `fullDeployToAll` | Both Local + GitHub | Production releases |

## 🎯 What Gets Deployed

### Local Maven Deployment
Location: `IRKit-Client-Delivery/Maven/`

This single command will:
1. ✅ Clean the Maven folder
2. ✅ Build both `irkit-library` and `IRKit-UI` release versions
3. ✅ Generate POM files with all dependencies
4. ✅ Generate Gradle module metadata
5. ✅ Create checksums (MD5, SHA1, SHA256, SHA512)
6. ✅ Package everything in Maven-standard directory structure

### GitHub Packages Deployment
Location: `https://maven.pkg.github.com/YOUR-ORG/irkit-android`

Requires:
- GitHub Personal Access Token (see [setup guide](GITHUB_PACKAGES_SETUP.md))
- Credentials in `local.properties`

## 📦 Generated Artifacts

### IRKit Library (Core)
- **Maven Coordinates**: `com.irdb:irkit-library:25.6`
- **Location**: `com/irdb/irkit-library/25.6/`
- **Files**:
  - `irkit-library-25.6.aar` - Main library archive
  - `irkit-library-25.6.pom` - Maven POM with all dependencies
  - `irkit-library-25.6.module` - Gradle metadata
  - `irkit-library-25.6-sources.jar` - Source code
  - Checksums for all files (MD5, SHA1, SHA256, SHA512)

**Key Dependencies** (automatically included in POM):
- AndroidX: Core, Lifecycle, Compose BOM
- CameraX (version 1.4.0-rc01)
- Firebase BOM (33.0.0): Analytics, Storage, Auth, Config
- Networking: OkHttp, Volley
- Image Processing: Coil, AndroidSVG
- Coroutines, Paging 3, Security, Location Services

### IRKit UI Library
- **Maven Coordinates**: `com.irdb:irkit-ui:25.6`
- **Location**: `com/irdb/irkit-ui/25.6/`
- **Files**:
  - `irkit-ui-25.6.aar` - Main library archive
  - `irkit-ui-25.6.pom` - Maven POM with all dependencies
  - `irkit-ui-25.6.module` - Gradle metadata
  - `irkit-ui-25.6-sources.jar` - Source code
  - Checksums for all files

**Key Dependencies** (automatically included in POM):
- `com.irdb:irkit-library:25.6` (automatically resolved)
- AndroidX: Core, Lifecycle, Activity Compose, Compose BOM
- Compose UI & Material3
- Coil, CameraX, Guava

## 🎯 Usage in Client Projects

### Local Maven Repository (Fastest for Testing)

```kotlin
// In your project's build.gradle.kts or settings.gradle.kts
repositories {
    maven {
        url = uri("/absolute/path/to/IRKit-Client-Delivery/Maven")
    }
    // Or use relative path from your project
    maven {
        url = uri("../irkit-android-develop 2025.5/IRKit-Client-Delivery/Maven")
    }
}

dependencies {
    implementation("com.irdb:irkit-library:25.6")
    implementation("com.irdb:irkit-ui:25.6")
}
```

### Deploy to Remote Maven Repository

#### Option 1: Using Maven CLI

```bash
cd IRKit-Client-Delivery/Maven

# Deploy irkit-library
mvn deploy:deploy-file \
  -Dfile=com/irdb/irkit-library/25.6/irkit-library-25.6.aar \
  -DpomFile=com/irdb/irkit-library/25.6/irkit-library-25.6.pom \
  -DrepositoryId=your-maven-repo \
  -Durl=https://your-maven-server.com/repository/releases/

# Deploy irkit-ui
mvn deploy:deploy-file \
  -Dfile=com/irdb/irkit-ui/25.6/irkit-ui-25.6.aar \
  -DpomFile=com/irdb/irkit-ui/25.6/irkit-ui-25.6.pom \
  -DrepositoryId=your-maven-repo \
  -Durl=https://your-maven-server.com/repository/releases/
```

#### Option 2: Using Gradle Publish (Direct to Remote)

Edit the `repositories` block in `irkit-library/build.gradle.kts` and `IRKit-UI/build.gradle.kts`:

```kotlin
publishing {
    repositories {
        maven {
            name = "RemoteMaven"
            url = uri("https://your-maven-server.com/repository/releases/")
            credentials {
                username = project.findProperty("mavenUser") as String? ?: System.getenv("MAVEN_USER")
                password = project.findProperty("mavenPassword") as String? ?: System.getenv("MAVEN_PASSWORD")
            }
        }
    }
}
```

Then run:
```bash
./gradlew :irkit-library:publishReleasePublicationToRemoteMavenRepository
./gradlew :IRKit-UI:publishReleasePublicationToRemoteMavenRepository
```

#### Option 3: Upload Entire Folder to Nexus/Artifactory

Simply upload the entire `com/` directory to your Maven repository server using:
- Nexus UI upload
- Artifactory UI upload  
- rsync/scp to repository filesystem

## 📋 Available Gradle Tasks

### Maven Deployment Tasks
- `./gradlew fullMavenDeploy` - ⭐ **ONE-CLICK**: Clean, build, and deploy everything
- `./gradlew deployToMaven` - Build and publish to Maven folder
- `./gradlew cleanMavenDeployment` - Clean the Maven folder

### Individual Library Tasks
- `./gradlew :irkit-library:publishReleasePublicationToIRKitMavenRepository`
- `./gradlew :IRKit-UI:publishReleasePublicationToIRKitMavenRepository`

### Legacy AAR-Only Deployment (Old Method)
- `./gradlew deployLibraries` - Copy only AAR files to IRKit-Client-Delivery/
- `./gradlew redeployLibraries` - Clean and deploy AAR files only

## 🔍 Verifying the Deployment

Check that all files were generated:

```bash
cd IRKit-Client-Delivery/Maven

# List irkit-library artifacts
ls -la com/irdb/irkit-library/25.6/

# List irkit-ui artifacts  
ls -la com/irdb/irkit-ui/25.6/

# Verify POM contains dependencies
cat com/irdb/irkit-library/25.6/irkit-library-25.6.pom
```

## 📝 Version Management

To change the version number (current: 25.6):

1. Update `irkit-library/build.gradle.kts`:
   ```kotlin
   buildConfigField("String", "LIBRARY_VERSION", "\"NEW_VERSION\"")
   version = "NEW_VERSION"  // in publishing block
   ```

2. Update `IRKit-UI/build.gradle.kts`:
   ```kotlin
   buildConfigField("String", "LIBRARY_VERSION", "\"NEW_VERSION\"")
   version = "NEW_VERSION"  // in publishing block
   ```

3. Run deployment:
   ```bash
   ./gradlew fullMavenDeploy
   ```

## ✅ What's Included in POM Files

Both POM files are automatically generated with:
- ✅ Complete dependency tree (all transitive dependencies)
- ✅ Proper Maven coordinates
- ✅ License information
- ✅ Developer information
- ✅ BOM (Bill of Materials) management for Compose and Firebase
- ✅ Correct dependency scopes (compile, runtime)

## 🔒 Requirements

- **Min SDK**: 33 (Android 13)
- **Java Version**: 17
- **Gradle**: 8.13
- **Kotlin**: 2.0.0
- **Compose Compiler**: 1.5.10

## 📞 Support

For issues or questions about deployment:
- Email: support@irkit.com
- Team: IRKit Development Team

---

**Last Updated**: 2026-01-15
**Maven Structure**: Standard Maven Repository Layout
**Ready for**: Nexus, Artifactory, or any Maven-compatible repository
