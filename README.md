# Flutter core sdk plugin 


Developing the Flutter plugin to the wrapper of the native Core SDK for Flutter client projects.

- Develop Branch:  Dev
- Release Branch :  release/0.0.1
- Release/0.0.1 Agenda : In this version, we are launching the core sdk with templates UI

## Table of Contents - 

1. [Introduction](#introduction)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
   - [Hilt](#hilt-)
   - [Adding Dependency](#adding-dependency-)
4. [Setup](#setup)
5. [Start Your App](#start-your-app)

## Introduction

In this documentation, we'll guide you through the process of installation, enabling you to enhance your Flutter app with Flutter core sdk plugin swiftly and efficiently.Let's get started on your journey to creating seamless communication experiences with Flutter plugin!

---

## Features

In Flutter Plugin , you'll find a range of powerful features designed to enhance your application's communication and collaboration capabilities. These features include:

1. **Voice and Video Calling**:Enjoy high-quality, real-time audio and video calls with your contacts.

2. **Participant Panel**: Manage and monitor participants in real-time meetings or video calls for a seamless user experience.

3. **Virtual Background**: Customize the background of your video calls, adding a touch of professionalism or fun to your communication.

4. **Screen Sharing and Whiteboard Sharing**: Empower collaboration by sharing your screen or using a virtual whiteboard during meetings or video conferences.

5. **Group Conversation**: Easily engage in text-based conversations with multiple participants in one chat group.
6. **Inspect Call Health**: Monitor the quality and performance of your audio and video calls to ensure a seamless communication experience.


## Prerequisites

Before you begin, ensure you have met the following requirements:

#### Hilt:

To set up Hilt in your Android project, follow these steps:

1. First, add the hilt-android-gradle-plugin plugin to your project’s root build.gradle file:

   ```gradle
   plugins {
   id("com.google.dagger.hilt.android") version "2.44" apply false
   }
   ```

2. Add the Hilt dependencies to the app-level build.gradle file

   ````gradle
   plugins {
     kotlin("kapt")
     id("com.google.dagger.hilt.android")
   }

   android {
       ...
       compileOptions {
           sourceCompatibility = JavaVersion.VERSION_11
           targetCompatibility = JavaVersion.VERSION_11
       }
   }

   dependencies {
           implementation "androidx.hilt:hilt-navigation-compose:1.0.0"
           implementation "com.google.dagger:hilt-android:2.44"
           kapt "com.google.dagger:hilt-android-compiler:2.44"
   } ```
   ````

## Adding Dependency:

 You need to  add the necessary configurations to your project's pubspec.yaml file:

```

  // Enable use of flutter plugin
 dependencies:
coresdk_flutter: ^0.0.1

```

---

## Setup

##### Register on JioMeet Platform:

You need to first register on Jiomeet platform.[Click here to sign up](https://platform.jiomeet.com/login/signUp)

##### Get your application keys:

Create a new app. Please follow the steps provided in the [Documentation guide](https://dev.jiomeet.com/docs/quick-start/introduction) to create apps before you proceed.

###### Get you Jiomeet meeting id and pin

Use the [create meeting api](https://dev.jiomeet.com/docs/JioMeet%20Platform%20Server%20APIs/create-a-dynamic-meeting) to get your room id and password

## Configure JioMeet Template UI inside your app

i. In Gradle Scripts/build.gradle (Module: <projectname>) add the Template UI dependency. The dependencies section should look like the following:

```gradle
dependencies {
    ...
    implementation "com.jiomeet.platform:jiomeetcoretemplatesdk:<version>"
    ...
}
```

Find the [Latest version](https://github.com/JioMeet/JioMeetCoreTemplateSDK_ANDROID/releases) of the UI Kit and replace <version> with the one you want to use. For example: 2.1.8.

### Add permissions for network and device access.

In /app/Manifests/AndroidManifest.xml, add the following permissions after </application>:

```gradle
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<!-- The SDK requires Bluetooth permissions in case users are using Bluetooth devices. -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<!-- For Android 12 and above devices, the following permission is also required. -->
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```



### Initiliazing Hilt in Application Class

1. Create a Custom Application Class: If your users don't already have a custom Application class in their Android project, they should create one. This class will be used to initialize Hilt.

```kotlin
import android.app.Application;
import dagger.hilt.android.HiltAndroidApp;

@HiltAndroidApp
class MyApplication : Application {
    // ...
}
```

2. Modify AndroidManifest.xml: In the AndroidManifest.xml file of their app, users should specify the custom Application class they created as the application name. This tells Android to use their custom Application class when the app starts.

```xml
<application
    android:name=".MyApplication" <!-- Specify the name of your custom Application class -->
    android:icon="@mipmap/ic_launcher"
    android:label="@string/app_name"
    android:theme="@style/AppTheme">
    <!-- ... -->
</application>
```

### Start your App

Here CoresdkPlugin is a main dart class to act as bridge between Core sdk and FLutter client project. With _coresdkPlugin instance we can call the core SDK methods.

``` 
final _jioCoreSdkPlugin = JioCoreSdkPlugin();
``` 

To Launch the Core SDK and Join the Meeting :
```   
try {
       await _jioCoreSdkPlugin.launchMeetingCoreTemplateUi("8517922072","u7uB3", "Meet");
    } on PlatformException {
          _error = 'Failed to Join the Metting';
   }
```

To get Meeting end callbacks from plugin, please add below code:
```   
1 - Register methodchannel
static const platform = MethodChannel('coresdk_plugin');

2 - Future<void> coreSdkPluginCallbacks() async {
        platform.setMethodCallHandler((call) async {
            if (call.method == "meetingEnded") {
                setState(() {
                    _meetingStatus = "Ended";
                });
            }
        });
    }
```



## Sample app

Visit our [Flutter core sdk plugin app](https://github.com/JioMeet/coresdk_plugin) repo to run the ample app.

---

## Troubleshooting

- Facing any issues while integrating or installing the JioMeet Template UI Kit please connect with us via real time support present in jiomeet.support@jio.com or https://jiomeetpro.jio.com/contact-us

---



