plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.isl_translator_app"
    compileSdk = 35 // Use 34 until SDK 36 is officially stable

    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.isl_translator_app"
        applicationId = "com.example.isl_translator_app"
    // minSdk = project.property("flutter.minSdkVersion").toString().toInt()
    // targetSdk = project.property("flutter.targetSdkVersion").toString().toInt()
    // versionCode = project.property("flutter.versionCode").toString().toInt()
    // versionName = project.property("flutter.versionName").toString()
        minSdk = flutter.minSdkVersion // Flutter's minimum supported SDK
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
