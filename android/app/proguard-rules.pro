# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive adapters (generated TypeAdapters)
-keep class ** implements com.hive.flutter.TypeAdapter { *; }
-keepclassmembers class * extends com.hive.flutter.HiveObject {
    <fields>;
}
-keep class * extends TypeAdapter {
    <init>();
}
-keepclassmembers class * {
    @HiveType *;
    @HiveField *;
}

# RevenueCat
-keep class com.revenuecat.purchases.** { *; }
-dontwarn com.revenuecat.purchases.**

# Health Connect / health plugin
-keep class androidx.health.connect.** { *; }
-keep class androidx.health.platform.** { *; }
-dontwarn androidx.health.**

# Google Mobile Ads / UMP
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.ump.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.ump.**

# Supabase / OkHttp / Kotlin serialization
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn retrofit2.**
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Gson / JSON models used by edge responses
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Pedometer / sensors foreground task
-keep class com.pravera.flutter_foreground_task.** { *; }
-dontwarn com.pravera.flutter_foreground_task.**

# Flutter deferred components / Play Core (optional; not used in this app)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
