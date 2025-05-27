# Flutter core sdk plugin
## Table of Contents -

1. [Introduction](#introduction)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
    - [Add Plugin](#add-plugin)
    - [Android](#android)
        - [Authentication](#authentication)
        - [Required Build Gradle Changes for Namespace and Kotlin Compatibility](#required-build-gradle-changes-for-namespace-and-kotlin-compatibility)
        - [Resolving Android Manifest Issues ](#resolving-android-manifest-issues)
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

3. **Screen Sharing and Whiteboard Sharing**: Empower collaboration by sharing your screen or using a virtual whiteboard during meetings or video conferences.

4. **Group Conversation**: Easily engage in text-based conversations with multiple participants in one chat group.

5. **Inspect Call Health**: Monitor the quality and performance of your audio and video calls to ensure a seamless communication experience.


## Prerequisites

Before you begin, ensure you have met the following requirements:

#### Add plugin:

You need to  add the necessary configurations to your   project's `pubspec.yaml` file:

```yaml
   coresdk_plugin:
      git:
         url: https://github.com/JioMeet/JioMeetCoreTemplateSDK_Flutter.git
         ref: 0.0.28
```

### Android:

#### Authentication

### Step 1: Generate a Personal Access Token for GitHub

1. Go to **Settings** > **Developer Settings** > **Personal Access Tokens** > **Tokens (classic)** > **Generate new token**.
2. Select the following scope:
    - `read:packages`
3. Generate the token and **copy it immediately**. You cannot view the token again once you leave the page. If lost, you will need to generate a new one.

### Step 2: Create the `credentials.properties` File

1. In the root directory of your project, create a file named `credentials.properties`.
2. Add the following content to the file, replacing placeholders with your actual GitHub credentials:

   ```properties
   username=your-github-username
   password=your-personal-access-token
   ```

#### Required Build Gradle Changes for Namespace and Kotlin Compatibility

In case you face namespace issues or need to ensure Kotlin JVM compatibility across the project, follow the steps below.

### Step 1: Open the Project-Level `build.gradle`
This file is usually located at the root of your Android project, alongside the `app/`, `gradle/` directories.

### Step 2: Add the Code for Namespace and Kotlin JVM Target
Add the following block of code to the **project-level** `build.gradle` file (not the `app/build.gradle` file):

   ```gradle
   allprojects {
        repositories {
            google()
            mavenCentral()
        }
        subprojects {
            afterEvaluate { project ->
                if (project.hasProperty('android')) {
                    project.android {
                        if (namespace == null) {
                            namespace project.group
                        }
                    }
                }
            }
        }
    }
    subprojects {
        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile) {
            kotlinOptions.jvmTarget = "11"
        }
    }

  
   ```

### Step 3: Add ProGuard Rules for Release Builds
To ensure proper code optimization and obfuscation while keeping necessary classes intact, add the following rules to your ProGuard configuration file (proguard-rules.pro):

```txt
-dontwarn kotlinx.android.parcel.Parcelize
-dontwarn kotlinx.parcelize.Parcelize

# Keep all classes with Gson annotations
-keep class * { @com.google.gson.annotations.SerializedName *; }

# Keep Gson InstanceCreator implementations
-keep class * implements com.google.gson.InstanceCreator { *; }

# Keep classes used by reflection
-keepattributes Signature
-keepattributes *Annotation*

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep the MeetingDetails object inside the Constants class
-keep class jio.coresdk.coresdk_plugin.Constants$MeetingDetails { *; }

-keep class jio.coresdk.coresdk_plugin.Constants { *; }
# Keep the MeetingDetails class and its fields
-keep class jio.coresdk.coresdk_plugin.MeetingDetails { *; }


# Keep all methods using Gson serialization/deserialization
-keep class com.google.gson.** { *; }

# Prevent obfuscation of Gson model classes
-keepclassmembers class jio.coresdk.coresdk_plugin.MeetingDetails {
    public <init>(...);
    public *;
}
``` 

#### Resolving Android Manifest Issues
If you encounter errors related to the `android:name` attribute in the `AndroidManifest.xml` (such as conflicts between libraries or SDKs), add the following line inside the `<application>` tag in your `app/src/main/AndroidManifest.xml`:

```xml
   <application
      android:name="${applicationName}"
      tools:replace="android:name">
      <!-- other configuration here -->
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

### Important

Note: Please add below post install script in podfile before installing pods

```swift
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

#### Screen Share Integration


#### Add Broadcast Upload Extension

You need to create a Broadcast Upload Extension to enable the screen sharing process. To do that,

open your example project, go to **Xcode -> File -> Target... ->**

![create_broadcast_upload_extension](https://storage.googleapis.com/cpass-sdk/assets/screenshots/iOS/screenshare_1.png)

Select **Broadcast Upload Extension** and click on **Next**

![select_broadcast_upload_extension](https://storage.googleapis.com/cpass-sdk/assets/screenshots/iOS/screenshare_2.png)

Fill the **Product name** and other info, uncheck **Include UI Extension**, and click **Finish**.

![broadcast_upload_extension_info](https://storage.googleapis.com/cpass-sdk/assets/screenshots/iOS/screenshare_3.png)

Activate the Extension

![activate_broadcast_upload_extension](https://storage.googleapis.com/cpass-sdk/assets/screenshots/iOS/screenshare_4.png)

Xcode automatically creates the Extension folder, which contains the **SampleHandler.swift** file.


**NOTE: Please set deployment target for Broadcast Upload Extension same as of your main app.**


#### Add JioMeet Screen Share SDK

Go to your Podfile. Add `JioMeetScreenShareSDK_iOS` pod for your newly created broadcast upload extension and run `pod install --repo-update --verbose` command to install the SDK.

```ruby
target 'ScreenShareExtension' do
    inherit! :search_paths
    pod 'JioMeetScreenShareSDK_iOS', '4.0.7'
end
```

Also pass below screen share configuration before joining the meeting to support iOS Screen Share

```ruby
   if (Platform.isIOS) {
      var screenShareConfig = ScreenshareConfig(appGroupName: "YOUR_APP_GROUP_NAME_IDENTIFIER", screenShareExtensionBundleIdentifier: "BROADCAST_UPLOAD_EXTENSION_IDENTIFIER");
      _coresdkPlugin.setScreenShareConfig(screenShareConfig);
   }
```
**NOTE: `ScreenShareExtension` is name of target you fill while creating `Broadcast Upload Extension`**


### Enable App Groups

You need to enable app groups for your main app and screenshare extension. Please follow guide from below link.
[https://developer.apple.com/documentation/xcode/configuring-app-groups](https://developer.apple.com/documentation/xcode/configuring-app-groups)

[https://www.appcoda.com/app-group-macos-ios-communication/](https://www.appcoda.com/app-group-macos-ios-communication/)


#### Edit `SampleHandler` file.

Go to your `SampleHandler.swift` file. Replace the whole file content with content below.

**NOTE: Please change `YOUR_APP_GROUP_NAME_IDENTIFIER` with app group you created in above step.**

```swift
import ReplayKit
import JioMeetScreenShareSDK

class SampleHandler: JMScreenShareHandler {

    override func getAppGroupsIdentifier() -> String {
        return "YOUR_APP_GROUP_NAME_IDENTIFIER"
    }
}
```

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
var meetingDetails = MeetingDetails(meetingId: "meeting_Id", meetingPin: "meeting_pin", displayName: "display_name", isInitialAudioOn: false, isInitialVideoOn: false, hostToken: "host_token");
await _coresdkPlugin.launchMeetingCoreTemplateUi(meetingDetails);
} on PlatformException {
_meetingStatus = "error while joining";
}
```

#### Leave Meeting: 
```dart   
_coresdkPlugin.leaveMeeting()
```

#### Callbacks from plugin:

1 - Register EventChannel
```dart
static const eventChannel = EventChannel('coresdk_plugin_events');
```

2
```dart
  @override
void initState() {
  super.initState();
  coreSdkPluginCallbacks();
}

Future<void> coreSdkPluginCallbacks() async {
 eventChannel.receiveBroadcastStream().listen((event) {
    if (event == "meetingStarted") {
        setState(() {
            _meetingStatus = "Started";
        });
    }
      
    if (event == "meetingEnded") {
        print("Meeting Ended");
    }

    if (event is Map) {
        String? eventType = event["event"];
        String? name = event["name"];
        String? userId = event["userId"];

        if (eventType == "remoteUserJoinedMeeting") {
          print( "Remote user joined: $name $userId");
        }

        if (eventType == "remoteUserLeftMeeting") {
          print( "Remote user left: $name $userId");
        }
    }
  });
}
```
#### config features, like we have to enable/disable the feature of switch camera, screen share, participant panel
we can find all feature flags in SetCoreSdkConfig class.
`````dart
   var config = SetCoreSdkConfig(enableFlipCamera: true);
await _coresdkPlugin.setConfig(config);
`````

### Example
```dart
import 'dart:async';

import 'package:coresdk_plugin/coresdk_plugin.dart';
import 'package:coresdk_plugin/meeting_details.dart';
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
    eventChannel.receiveBroadcastStream().listen((event) {
        if (event == "meetingStarted") {
            setState(() {
                _meetingStatus = "Started";
            });
        }
          
        if (event == "meetingEnded") {
            print("Meeting Ended");
        }

        if (event is Map) {
            String? eventType = event["event"];
            String? name = event["name"];
            String? userId = event["userId"];

            if (eventType == "remoteUserJoinedMeeting") {
                print( "Remote user joined: $name $userId");
            }

            if (eventType == "remoteUserLeftMeeting") {
                print( "Remote user left: $name $userId");
            }
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
                    // Pass host-token only when you want to join as a cohost.
                    var meetingDetails = MeetingDetails(
                        meetingId: "meeting_id",                  // Meeting ID for identifying the meeting
                        meetingPin: "meeting_pin",                // Meeting PIN for joining the meeting
                        displayName: "display_name",              // Display name should be minimum three characters and should not contain any special characters & spaces.
                        isInitialAudioOn: false,                  // Whether the initial audio should be on (default is false)
                        isInitialVideoOn: false,                  // Whether the initial video should be on (default is false)
                        hostToken: "hostToken"                    // Host token is required only if joining as a cohost
)
                    await _coresdkPlugin.launchMeetingCoreTemplateUi(meetingDetails);
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
