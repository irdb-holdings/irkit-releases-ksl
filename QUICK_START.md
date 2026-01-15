# Maven Deployment - Quick Start

## ✅ Multi-Repository Deployment Ready!

Version **25.6** of IRKit libraries can be deployed to multiple repositories.

## 🚀 One-Click Deployment Commands

### Deploy to Local Maven
```bash
./gradlew fullMavenDeploy
```

### Deploy to GitHub Packages
```bash
./gradlew deployToGitHub
```
**Note**: Requires GitHub credentials - see [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md)

### Deploy to ALL Repositories
```bash
./gradlew fullDeployToAll
```

## 📦 What Was Generated

```
IRKit-Client-Delivery/Maven/
├── README.md                           # Usage instructions
├── DEPLOYMENT_GUIDE.md                 # Complete deployment guide
└── com/irdb/
    ├── irkit-library/25.6/
    │   ├── irkit-library-25.6.aar     # Core library
    │   ├── irkit-library-25.6.pom     # Maven POM (55 dependencies)
    │   ├── irkit-library-25.6.module  # Gradle metadata
    │   └── irkit-library-25.6-sources.jar
    └── irkit-ui/25.6/
        ├── irkit-ui-25.6.aar          # UI library
        ├── irkit-ui-25.6.pom          # Maven POM (depends on irkit-library)
        ├── irkit-ui-25.6.module       # Gradle metadata
        └── irkit-ui-25.6-sources.jar
```

Plus checksums (MD5, SHA1, SHA256, SHA512) for all files.

## 🎯 Use in Your Project

### Local Maven Repository

Add to `build.gradle.kts`:

```kotlin
repositories {
    maven { url = uri("/path/to/IRKit-Client-Delivery/Maven") }
}

dependencies {
    implementation("com.irdb:irkit-library:25.6")
    implementation("com.irdb:irkit-ui:25.6")  // Includes irkit-library automatically
}
```

### Deploy to Remote Maven

```bash
# Navigate to Maven folder
cd IRKit-Client-Delivery/Maven

# Deploy using Maven CLI
mvn deploy:deploy-file \
  -Dfile=com/irdb/irkit-library/25.6/irkit-library-25.6.aar \
  -DpomFile=com/irdb/irkit-library/25.6/irkit-library-25.6.pom \
  -DrepositoryId=your-repo \
  -Durl=https://your-maven-server.com/repository/

mvn deploy:deploy-file \
  -Dfile=com/irdb/irkit-ui/25.6/irkit-ui-25.6.aar \
  -DpomFile=com/irdb/irkit-ui/25.6/irkit-ui-25.6.pom \
  -DrepositoryId=your-repo \
  -Durl=https://your-maven-server.com/repository/
```

## 📋 Key Features

✅ **Complete POM files** with all dependencies automatically included  
✅ **Standard Maven repository structure** compatible with Nexus, Artifactory, etc.  
✅ **Gradle metadata** for enhanced dependency resolution  
✅ **Source JARs** included  
✅ **Checksums** for integrity verification  
✅ **Version 25.6** set in all artifacts  

## 🔄 Rebuild/Redeploy

To rebuild and redeploy (e.g., after code changes):

```bash
./gradlew fullMavenDeploy
```

This will:
1. Clean the Maven folder
2. Rebuild both libraries
3. Regenerate all POM files
4. Update all artifacts

## 📚 Documentation

- **README.md** - Usage instructions for Maven artifacts
- **DEPLOYMENT_GUIDE.md** - Complete guide with all deployment options
- **This file** - Quick reference

## 🎉 Ready for Production

Your Maven artifacts are ready to:
- ✅ Use locally in development
- ✅ Upload to private Maven repository
- ✅ Distribute to clients
- ✅ Deploy to production

---

**Generated**: 2026-01-15  
**Version**: 25.6  
**Build Tool**: Gradle 8.13  
**Status**: ✅ READY
