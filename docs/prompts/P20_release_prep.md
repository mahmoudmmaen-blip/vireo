Act as a Flutter Android release engineer for Vireo (branch ux-v2). Prepare the Android app for Google Play. Do NOT create a keystore and do NOT build a release yet.

1. Application ID: change from com.example.vireo to com.vireofit.app everywhere:
   - android/app/build.gradle.kts: namespace + applicationId
   - move MainActivity.kt to android/app/src/main/kotlin/com/vireofit/app/ and fix its package line; delete the old empty folders
   - any other reference (AndroidManifest, Health Connect / deep-link intent filters, google-services if present, RevenueCat/Supabase redirect schemes, docs/store files)
   - Supabase auth deep-link scheme (if any) → com.vireofit.app://login-callback; list it in docs/RELEASE.md so the owner adds it in Supabase Auth → URL configuration.
2. SDK levels: compileSdk and targetSdk = the current Google Play target API requirement (at least 35; use 36 if the installed Android SDK has it), minSdk stays 26. Fix any build issues this causes.
3. Version: pubspec version 1.0.0+1.
4. Release signing (reads a file the owner will create later):
   - build.gradle.kts: load android/key.properties if it exists (storeFile, storePassword, keyAlias, keyPassword) and use it for release; if missing, fall back to debug signing so the project still builds.
   - add android/key.properties and *.jks / *.keystore to .gitignore.
5. App name shown on the phone: "Vireo". App icon + adaptive icon from assets/images/vireo_logo.svg (flutter_launcher_icons; convert the SVG to a 1024px PNG first) and a simple splash (flutter_native_splash) using the brand dark background.
6. Write docs/RELEASE.md: exact PowerShell keytool command for the owner (upload-keystore.jks stored OUTSIDE the repo, e.g. N:\keys\vireo-upload.jks), the key.properties template, and the exact `flutter build appbundle --release` command with every dart-define the app reads (list them by name from AppConfig; values left as <PLACEHOLDER>).
7. flutter analyze → 0 errors; `flutter build apk --debug` must succeed (proves the rename works).
git add -A && git commit -m "chore(android): app id com.vireofit.app, SDK levels, signing config, icons, splash". Do not push.

Work autonomously. Do not ask me questions — pick the best option and note it in the final summary.
