# GitHub Packages Setup Guide

This guide explains how to configure and use GitHub Packages for Maven deployment of IRKit libraries.

## 📋 Table of Contents

1. [Initial Setup](#initial-setup)
2. [Publishing to GitHub Packages](#publishing-to-github-packages)
3. [Consuming from GitHub Packages](#consuming-from-github-packages)
4. [Automated Publishing with GitHub Actions](#automated-publishing-with-github-actions)
5. [Troubleshooting](#troubleshooting)

## 🚀 Initial Setup

### Step 1: Update Repository URLs

Before deploying, update the placeholder URLs in your build files:

**Files to update:**
- `irkit-library/build.gradle.kts`
- `IRKit-UI/build.gradle.kts`

Replace `YOUR-ORG/irkit-android` with your actual GitHub organization/username and repository:

```kotlin
url = uri("https://maven.pkg.github.com/YOUR-GITHUB-USERNAME/your-repo-name")
```

Example:
```kotlin
url = uri("https://maven.pkg.github.com/irkit/irkit-android")
```

### Step 2: Create GitHub Personal Access Token (PAT)

1. Go to GitHub.com → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Configure the token:
   - **Note**: "IRKit Maven Publishing"
   - **Expiration**: Choose appropriate duration (90 days, 1 year, or no expiration)
   - **Scopes**: Select these permissions:
     - ✅ `write:packages` - Upload packages
     - ✅ `read:packages` - Download packages
     - ✅ `repo` - Required if repository is private
4. Click **Generate token**
5. **⚠️ IMPORTANT**: Copy the token immediately (you won't see it again!)

### Step 3: Configure Local Credentials

Add your GitHub credentials to `local.properties` (this file is gitignored):

```properties
# Existing settings...
sdk.dir=/Users/...
enableCharlesProxy=false

# GitHub Packages credentials (ADD THESE)
gpr.user=your-github-username
gpr.token=ghp_YourPersonalAccessTokenHere
```

**Security Notes:**
- ✅ `local.properties` is already in `.gitignore` - never commit it!
- ✅ Use different tokens for different machines/purposes
- ✅ Rotate tokens periodically for security
- ❌ Never hardcode tokens in build files
- ❌ Never commit tokens to git

## 📦 Publishing to GitHub Packages

### Quick Deploy Options

```bash
# Option 1: Deploy to GitHub Packages only
./gradlew deployToGitHub

# Option 2: Deploy to local Maven only
./gradlew fullMavenDeploy

# Option 3: Deploy to BOTH (recommended for releases)
./gradlew fullDeployToAll
```

### Individual Library Publishing

```bash
# Publish irkit-library to GitHub only
./gradlew :irkit-library:publishReleasePublicationToGitHubPackagesRepository

# Publish IRKit-UI to GitHub only
./gradlew :IRKit-UI:publishReleasePublicationToGitHubPackagesRepository

# Publish both to all configured repositories
./gradlew :irkit-library:publish
./gradlew :IRKit-UI:publish
```

### Verifying the Deployment

After publishing, verify at:
```
https://github.com/YOUR-ORG/your-repo/packages
```

You should see:
- `com.irdb.irkit-library` package
- `com.irdb.irkit-ui` package

## 📥 Consuming from GitHub Packages

### For Library Users

Users of your library need to:

#### 1. Create their own GitHub PAT
- Same process as above
- Minimum scope: `read:packages`

#### 2. Add credentials to their `local.properties`
```properties
gpr.user=their-github-username
gpr.token=their-personal-access-token
```

#### 3. Configure repository in their project

**In `settings.gradle.kts`:**
```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // Add GitHub Packages repository
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

**Or in project `build.gradle.kts` (older Gradle):**
```kotlin
repositories {
    google()
    mavenCentral()
    
    maven {
        url = uri("https://maven.pkg.github.com/YOUR-ORG/irkit-android")
        credentials {
            username = project.findProperty("gpr.user") as String? 
                ?: System.getenv("GITHUB_ACTOR")
            password = project.findProperty("gpr.token") as String? 
                ?: System.getenv("GITHUB_TOKEN")
        }
    }
}
```

#### 4. Add dependencies
```kotlin
dependencies {
    implementation("com.irdb:irkit-library:25.6")
    implementation("com.irdb:irkit-ui:25.6")
}
```

## 🤖 Automated Publishing with GitHub Actions

### The workflow is already configured!

Location: `.github/workflows/publish-maven.yml`

### Manual Trigger

1. Go to your GitHub repository
2. Navigate to **Actions** tab
3. Select **Publish Maven Packages** workflow
4. Click **Run workflow**
5. Choose options:
   - **Version**: Enter version (e.g., 25.6)
   - **Target**: Select deployment target
     - `github-only` - Publish to GitHub Packages
     - `local-only` - Generate local Maven artifacts
     - `all` - Both GitHub and local
6. Click **Run workflow**

### Automatic Trigger on Release

The workflow automatically runs when you:
1. Create a new release on GitHub
2. Publishes automatically to GitHub Packages

### Setting Up Automatic Releases

```bash
# Create and push a tag
git tag -a v25.6 -m "Release version 25.6"
git push origin v25.6

# Then create a release from that tag on GitHub
```

## 🔧 Troubleshooting

### Error: "Failed to publish to GitHub Packages"

**Cause**: Invalid or missing credentials

**Solution**:
1. Verify `gpr.user` and `gpr.token` in `local.properties`
2. Check token has `write:packages` permission
3. Ensure token hasn't expired
4. Verify repository URL matches your GitHub repo

### Error: "401 Unauthorized"

**Cause**: Invalid token or insufficient permissions

**Solution**:
1. Regenerate GitHub Personal Access Token
2. Ensure `write:packages` scope is selected
3. If repo is private, add `repo` scope
4. Update token in `local.properties`

### Error: "Resource already exists"

**Cause**: Package version already published (GitHub doesn't allow overwriting)

**Solutions**:
1. **Increment version**: Change version in both `build.gradle.kts` files
2. **Delete version** (if needed): Go to GitHub → Packages → Versions → Delete
3. **Use different version**: Append suffix like `25.6-rc1`, `25.6-beta`

### Error: "Cannot resolve dependency"

**Cause**: Consumer can't download from GitHub Packages

**Solution** (for library users):
1. Verify they have valid `gpr.user` and `gpr.token` in their `local.properties`
2. Token needs `read:packages` permission
3. Check repository URL is correct
4. Verify package visibility (public vs private)

### Error: "Repository not found"

**Cause**: Incorrect repository URL

**Solution**:
1. Update URL in `build.gradle.kts` files
2. Format: `https://maven.pkg.github.com/USERNAME/REPO`
3. Must match your actual GitHub repository

### Gradle sync issues

**If Gradle can't find tasks:**
```bash
./gradlew tasks --group="irkit deployment"
```

**If tasks aren't showing up:**
1. Sync Gradle files
2. Restart IDE
3. Invalidate caches (IntelliJ/Android Studio)

## 📊 Comparison: GitHub Packages vs Local Maven

| Feature | GitHub Packages | Local Maven |
|---------|----------------|-------------|
| **Setup Complexity** | Medium (requires PAT) | Easy (just path) |
| **Authentication** | Required (even for public) | Not required |
| **Distribution** | Automatic via GitHub | Manual (share files) |
| **CI/CD** | Built-in with Actions | Manual upload |
| **Version Control** | Cannot overwrite | Can replace files |
| **Storage** | 500MB free, then paid | Unlimited (local) |
| **Best For** | Team collaboration, CI/CD | Testing, direct distribution |

## 🎯 Best Practices

### For Development
```bash
# Test locally first
./gradlew fullMavenDeploy

# Verify artifacts in IRKit-Client-Delivery/Maven/
ls -la IRKit-Client-Delivery/Maven/com/irdb/*/25.6/

# Then publish to GitHub
./gradlew deployToGitHub
```

### For Releases
```bash
# Clean and deploy everything
./gradlew fullDeployToAll
```

### Version Management
- Use semantic versioning: `MAJOR.MINOR.PATCH`
- Current version: `25.6`
- Update in both `irkit-library/build.gradle.kts` and `IRKit-UI/build.gradle.kts`
- Tag releases in Git: `git tag v25.6`

### Security
- ✅ Rotate tokens every 90 days
- ✅ Use separate tokens for CI/CD vs local development
- ✅ Revoke tokens when no longer needed
- ✅ Never commit tokens to version control
- ✅ Use organization secrets for team projects

## 📚 Additional Resources

- [GitHub Packages Documentation](https://docs.github.com/en/packages)
- [Gradle Publishing Plugin](https://docs.gradle.org/current/userguide/publishing_maven.html)
- [Creating GitHub PATs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## 🆘 Support

If you encounter issues:
1. Check this troubleshooting guide
2. Verify credentials and permissions
3. Check GitHub Actions logs (if using automation)
4. Contact: support@irkit.com

---

**Last Updated**: 2026-01-15  
**Version**: 25.6  
**Status**: ✅ Ready for GitHub Packages deployment
