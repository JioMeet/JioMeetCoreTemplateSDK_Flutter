# Flutter core sdk plugin
## Table of Contents -

1. [Introduction](#introduction)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
   - [Android](#android)
      - [Add Plugin](#add-plugin)
      - [Hilt](#hilt)
   - [iOS](#ios)
      - [Require Configurations](#require-configurations)
      - [Info.plist Changes](#infoplist-changes)
      - [Enable Background Mode](#enable-background-mode)
4. [Setup](#setup)
5. [Usage](#usage)
6. [Example](#Example)

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

### Android:
#### Add plugin:

You need to  add the necessary configurations to your   project's `pubspec.yaml` file:

```yaml
  coresdk_plugin:
    git:
      url: https://github.com/JioMeet/JioMeetCoreTemplateSDK_Flutter.git
      ref: 0.0.7
```

#### Hilt:

To set up Hilt in your flutter project, follow these steps:

1. First, add the hilt-android-gradle-plugin plugin to your project’s root build.gradle file (**android/build.gradle**)

   ```gradle
   plugins {
   id("com.google.dagger.hilt.android") version "2.44" apply false
   }
   ```

2. Add the Hilt dependencies to the app-level build.gradle(**android/app/build.gradle**)

   ```gradle
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
   }
   ````

3. Create a Custom Application Class: If your users don't already have a custom Application class in their Android project, they should create one. This class will be used to initialize Hilt.

```kotlin
import android.app.Application;
import dagger.hilt.android.HiltAndroidApp;

@HiltAndroidApp
class MyApplication : Application {
    // ...
}
```

4. Modify AndroidManifest.xml: In the AndroidManifest.xml file of their app, users should specify the custom Application class they created as the application name. This tells Android to use their custom Application class when the app starts.

```xml
<application
    android:name=".MyApplication" <!-- Specify the name of your custom Application class -->
    android:icon="@mipmap/ic_launcher"
    android:label="@string/app_name"
    android:theme="@style/AppTheme">
    <!-- ... -->
</application>
```
---
### iOS
### Require Configurations

Before getting started with this example app, please ensure you have the following software installed on your machine:

- Xcode 14.2 or later.
- Swift 5.0 or later.
- An iOS device or emulator running iOS 13.0 or later.

### Info.plist Changes

Please add below permissions keys to your `Info.plist` file with proper description.

```swift
<key>NSCameraUsageDescription</key>
<string>Allow access to camera for meetings</string>
<key>NSMicrophoneUsageDescription</key>
<string>Allow access to mic for meetings</string>
```

### Enable Background Mode

Please enable `Background Modes` in your project `Signing & Capibilities` tab. After enabling please check box with option `Audio, Airplay, and Pictures in Pictures`. If you don't enables this setting, your mic will be muted when your app goes to background.

---
## Setup

#### Register on JioMeet Platform:

You need to first register on Jiomeet platform.[Click here to sign up](https://platform.jiomeet.com/login/signUp)

##### Get your application keys:

Create a new app. Please follow the steps provided in the [Documentation guide](https://dev.jiomeet.com/docs/quick-start/introduction) to create apps before you proceed.

###### Get you Jiomeet meeting id and pin

Use the [create meeting api](https://dev.jiomeet.com/docs/JioMeet%20Platform%20Server%20APIs/create-a-dynamic-meeting) to get your room id and password

### Usage

Here CoresdkPlugin is a main dart class to act as bridge between core tamplet sdk and FLutter client project. With _coresdkPlugin instance we can call the core tamplet SDK methods.

```dart  
final _jioCoreSdkPlugin = JioCoreSdkPlugin();
``` 

#### Join Meeting :
```dart   
try {
await _coresdkPlugin.launchMeetingCoreTemplateUi("meeting_id", "meeting_password", "meeting_title","pass bool value of isInitialAudioOn", "pass bool value of isInitialVideoOn");
} on PlatformException {
_meetingStatus = "error while joining";
}
```

#### Callbacks from plugin:

1 - Register methodchannel
```dart
static const platform = MethodChannel('coresdk_plugin');
```

2
```dart
  @override
  void initState() {
    super.initState();
    coreSdkPluginCallbacks();
  }

  Future<void> coreSdkPluginCallbacks() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "meetingEnded") {
        setState(() {
          _meetingStatus = "Ended";
        });
      }
    });
  }
```

### Example
```dart
import 'dart:async';

import 'package:coresdk_plugin/coresdk_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
   runApp(const MyApp());
}

class MyApp extends StatefulWidget {
   const MyApp({super.key});

   @override
   State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   final _coresdkPlugin = JioCoreSdkPlugin();
   static const platform = MethodChannel('coresdk_plugin');
   String _meetingStatus = 'Not started';

   @override
   void initState() {
      super.initState();
      coreSdkPluginCallbacks();
   }

   Future<void> coreSdkPluginCallbacks() async {
      platform.setMethodCallHandler((call) async {
         if (call.method == "meetingEnded") {
            setState(() {
               _meetingStatus = "Ended";
            });
         }
      });
   }

   @override
   Widget build(BuildContext context) {
      return MaterialApp(
         home: Scaffold(
            appBar: AppBar(
               title: const Text('Plugin example app'),
            ),
            body: Center(
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text('meeting Status:  $_meetingStatus\n'),
                     TextButton(
                        onPressed: () async {
                           try {
                              await _coresdkPlugin.launchMeetingCoreTemplateUi(
                                      "meeting_id", "meeting_password", "meeting_title");
                           } on PlatformException {
                              _meetingStatus = "error while joining";
                           }
                        },
                        child: const Text('Join Meeting'),
                     ),
                  ],
               ),
            ),
         ),
      );
   }
}
```

---

## Troubleshooting

- Facing any issues while integrating or installing the JioMeet Template UI Kit please connect with us via real time support present in jiomeet.support@jio.com or https://jiomeetpro.jio.com/contact-us

---