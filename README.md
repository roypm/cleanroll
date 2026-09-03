# CleanRoll

Lightweight Flutter app to clean your photo gallery: pick an album, choose an order, swipe Keep / Delete, review, then confirm deletion.

See `docs/` and `AGENTS.md` for product scope.

## Branches

| Branch | Purpose |
|--------|---------|
| `develop` | Day-to-day work and experiments |
| `main` | Stable releases; GitHub Actions builds the release APK here |

Workflow:

1. Commit on `develop`
2. Open a pull request `develop` → `main`
3. CI runs `flutter analyze` + `flutter test`
4. After merge to `main`, CI bumps the patch version, builds the release APK, and publishes a [GitHub Release](https://github.com/roypm/cleanroll/releases)

## Download APK

Official builds: **[Releases](https://github.com/roypm/cleanroll/releases)**  
File name pattern: `CleanRoll-vX.Y.Z.apk`

## Run locally

```bash
export PATH="$PATH:/home/user/flutter/bin"
cd /home/user/github/cleanroll
flutter pub get
flutter run
```

Needs a connected Android device/emulator (or iOS on a Mac). Photo permissions are required.

## Test

```bash
flutter test
flutter analyze
```

## Build APK locally

```bash
export TMPDIR=/home/user/tmp
export GRADLE_USER_HOME=/home/user/.gradle
mkdir -p /home/user/tmp
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`
