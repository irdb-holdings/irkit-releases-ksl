# Gradle Tasks Reference - IRKit Maven Deployment

Complete reference for all Maven deployment tasks available in the IRKit project.

## 📋 Quick Reference

| Task | Description | Use Case |
|------|-------------|----------|
| `fullMavenDeploy` ⭐ | Deploy to local Maven | Testing, direct AAR distribution |
| `deployToGitHub` 📦 | Deploy to GitHub Packages | CI/CD, team collaboration |
| `fullDeployToAll` ⭐⭐ | Deploy to ALL repositories | Production releases |
| `deployToAll` | Deploy without cleaning | Quick updates |
| `deployToMaven` | Deploy to local (no clean) | Incremental builds |
| `cleanMavenDeployment` | Clean local Maven folder | Fresh start |
| `cleanAllDeployments` | Clean all deployment locations | Complete reset |

## 🎯 Main Deployment Tasks

### `fullMavenDeploy`
**Full command**: `./gradlew fullMavenDeploy`

**What it does:**
- Cleans `IRKit-Client-Delivery/Maven/` folder
- Builds both libraries (irkit-library + IRKit-UI)
- Generates AAR files
- Generates POM files with all dependencies
- Generates Gradle metadata (.module files)
- Generates sources JARs
- Creates checksums (MD5, SHA1, SHA256, SHA512)
- Creates README.md in Maven folder

**Output location:** `IRKit-Client-Delivery/Maven/`

**When to use:**
- Testing locally
- Preparing AAR files for direct distribution
- Development and debugging
- When you don't need GitHub Packages

**Example:**
```bash
./gradlew fullMavenDeploy
# Artifacts ready in IRKit-Client-Delivery/Maven/
```

---

### `deployToGitHub`
**Full command**: `./gradlew deployToGitHub`

**What it does:**
- Builds both libraries
- Publishes to GitHub Packages Maven repository
- Makes artifacts available at: `https://maven.pkg.github.com/YOUR-ORG/irkit-android`

**Requirements:**
- GitHub Personal Access Token configured
- Credentials in `local.properties`:
  ```properties
  gpr.user=your-github-username
  gpr.token=ghp_yourtoken
  ```
- Repository URL updated in build files

**When to use:**
- Publishing for team consumption
- CI/CD deployments
- Making libraries available via GitHub
- Automated distribution

**Example:**
```bash
./gradlew deployToGitHub
# Check: https://github.com/YOUR-ORG/irkit-android/packages
```

**Setup guide:** See [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md)

---

### `fullDeployToAll` ⭐ RECOMMENDED FOR RELEASES
**Full command**: `./gradlew fullDeployToAll`

**What it does:**
- Cleans all local deployment locations
- Builds both libraries
- Publishes to local Maven (`IRKit-Client-Delivery/Maven/`)
- Publishes to GitHub Packages
- Creates comprehensive deployment summary

**When to use:**
- Production releases
- Version bumps
- Major updates
- When you want maximum distribution coverage

**Example:**
```bash
./gradlew fullDeployToAll
# Artifacts available:
# - Locally: IRKit-Client-Delivery/Maven/
# - GitHub: https://github.com/YOUR-ORG/irkit-android/packages
```

---

### `deployToAll`
**Full command**: `./gradlew deployToAll`

**What it does:**
- Builds both libraries
- Publishes to ALL configured repositories (no cleaning)
- Faster than `fullDeployToAll`

**When to use:**
- Quick incremental updates
- When you don't need to clean first
- Faster iterations during testing

**Example:**
```bash
./gradlew deployToAll
```

---

### `deployToMaven`
**Full command**: `./gradlew deployToMaven`

**What it does:**
- Builds both libraries
- Publishes to local Maven only (no cleaning)
- Generates README.md

**When to use:**
- Incremental local builds
- Quick iterations without full clean

**Example:**
```bash
./gradlew deployToMaven
```

---

## 🧹 Cleanup Tasks

### `cleanMavenDeployment`
**Full command**: `./gradlew cleanMavenDeployment`

**What it does:**
- Deletes `IRKit-Client-Delivery/Maven/` folder

**When to use:**
- Before fresh deployment
- Cleaning up old artifacts

**Example:**
```bash
./gradlew cleanMavenDeployment
```

---

### `cleanAllDeployments`
**Full command**: `./gradlew cleanAllDeployments`

**What it does:**
- Cleans local Maven deployment
- (Note: Cannot delete GitHub Packages versions)

**When to use:**
- Complete local cleanup
- Before major version changes

**Example:**
```bash
./gradlew cleanAllDeployments
```

---

## 📦 Individual Library Tasks

### IRKit Library Tasks

```bash
# Publish to local Maven only
./gradlew :irkit-library:publishReleasePublicationToIRKitMavenRepository

# Publish to GitHub Packages only
./gradlew :irkit-library:publishReleasePublicationToGitHubPackagesRepository

# Publish to ALL configured repositories
./gradlew :irkit-library:publish
```

### IRKit UI Library Tasks

```bash
# Publish to local Maven only
./gradlew :IRKit-UI:publishReleasePublicationToIRKitMavenRepository

# Publish to GitHub Packages only
./gradlew :IRKit-UI:publishReleasePublicationToGitHubPackagesRepository

# Publish to ALL configured repositories
./gradlew :IRKit-UI:publish
```

---

## 🔄 Workflow Examples

### Development Workflow
```bash
# Make code changes...

# Test locally
./gradlew fullMavenDeploy

# Verify artifacts
ls -la IRKit-Client-Delivery/Maven/com/irdb/*/25.6/

# If good, deploy to GitHub
./gradlew deployToGitHub
```

### Release Workflow
```bash
# Update version in build files to 25.7
# irkit-library/build.gradle.kts: version = "25.7"
# IRKit-UI/build.gradle.kts: version = "25.7"

# Clean and deploy everywhere
./gradlew fullDeployToAll

# Tag the release
git tag v25.7
git push origin v25.7

# Create GitHub release (triggers automatic publishing)
```

### Quick Iteration Workflow
```bash
# Make changes...

# Quick build without cleaning
./gradlew deployToMaven

# Test locally
```

### CI/CD Workflow (GitHub Actions)
```yaml
# Automatic via .github/workflows/publish-maven.yml
# Triggers on:
# - New release creation
# - Manual workflow dispatch
```

---

## 🎛️ Task Groups

All deployment tasks are in the **"irkit deployment"** group.

View all deployment tasks:
```bash
./gradlew tasks --group="irkit deployment"
```

Expected output:
```
IRKit deployment tasks
----------------------
cleanAllDeployments - 🧹 Clean all deployment locations
cleanDeployment - Clean IRKit libraries from client delivery folder
cleanMavenDeployment - Clean Maven deployment folder
deployLibraries - Build and copy IRKit libraries to client delivery folder
deployToAll - 🚀 Publish IRKit libraries to ALL repositories
deployToGitHub - 📦 Publish IRKit libraries to GitHub Packages
deployToMaven - Maven deployment with POM files
fullDeployToAll - ⭐⭐ ONE-CLICK: Clean, build, and publish to ALL
fullMavenDeploy - ⭐ ONE-CLICK MAVEN DEPLOY
redeployLibraries - Clean, build, and deploy IRKit libraries
```

---

## 🚨 Common Issues & Solutions

### "Task not found"
**Problem:** Gradle can't find the task

**Solution:**
```bash
# Refresh Gradle
./gradlew --refresh-dependencies

# List all tasks
./gradlew tasks --all

# Invalidate caches in IDE
```

### "Authentication required"
**Problem:** Publishing to GitHub Packages fails

**Solution:**
1. Check `local.properties` has `gpr.user` and `gpr.token`
2. Verify token has `write:packages` permission
3. See [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md)

### "Version already exists"
**Problem:** Can't overwrite existing version in GitHub Packages

**Solution:**
1. Increment version number in build files
2. Or delete version from GitHub Packages UI
3. Or use version suffix (e.g., 25.6-rc1)

### Build fails
**Problem:** Compilation errors

**Solution:**
```bash
# Clean everything first
./gradlew clean

# Then rebuild
./gradlew fullMavenDeploy
```

---

## 📊 Task Comparison Matrix

| Feature | fullMavenDeploy | deployToGitHub | fullDeployToAll |
|---------|----------------|----------------|-----------------|
| **Cleans first** | ✅ | ❌ | ✅ |
| **Local Maven** | ✅ | ❌ | ✅ |
| **GitHub Packages** | ❌ | ✅ | ✅ |
| **Requires GitHub auth** | ❌ | ✅ | ✅ |
| **Speed** | Fast | Medium | Slower |
| **Best for** | Local dev | GitHub only | Releases |

---

## 🎯 Recommended Usage

| Scenario | Recommended Task |
|----------|------------------|
| **Local testing** | `fullMavenDeploy` |
| **GitHub-only release** | `deployToGitHub` |
| **Production release** | `fullDeployToAll` |
| **Quick iteration** | `deployToMaven` |
| **CI/CD** | Automatic via GitHub Actions |
| **Manual GitHub push** | `deployToGitHub` |
| **Clean start** | `cleanAllDeployments` then `fullDeployToAll` |

---

## 📚 Related Documentation

- [QUICK_START.md](QUICK_START.md) - Quick reference guide
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Complete deployment guide
- [GITHUB_PACKAGES_SETUP.md](GITHUB_PACKAGES_SETUP.md) - GitHub Packages setup
- [README.md](README.md) - Usage instructions for consumers

---

**Version:** 25.6  
**Last Updated:** 2026-01-15  
**Status:** ✅ All tasks tested and working
