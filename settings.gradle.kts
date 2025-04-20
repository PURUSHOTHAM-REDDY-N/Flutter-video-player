pluginManagement {
    val flutterSdkPath = rootDir.resolve("flutter")
    includeBuild(flutterSdkPath.resolve("packages/flutter_tools/gradle"))
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("com.android.application") version "7.3.0" apply false
    id("org.jetbrains.kotlin.android") version "1.7.10" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

include(":app")
