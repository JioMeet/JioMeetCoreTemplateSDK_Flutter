import 'dart:async';
import 'dart:io';

import 'package:coresdk_plugin/Environment.dart';
import 'package:coresdk_plugin/coresdk_plugin.dart';
import 'package:coresdk_plugin/meeting_details.dart';
import 'package:coresdk_plugin/screenshare_config.dart';
import 'package:coresdk_plugin/set_coresdk_config.dart';
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
  static const eventChannel = EventChannel('coresdk_plugin_events');
  String _meetingStatus = 'Not started';

  @override
  void initState() {
    super.initState();
    coreSdkPluginCallbacks();
    _coresdkPlugin.setEnvironment(NetWorkEnvironment.prod);
    if (Platform.isIOS) {
      var screenShareConfig = ScreenshareConfig(
          appGroupName: "group.com.jio.jiomeet.nativesdk",
          screenShareExtensionBundleIdentifier:
          "com.jio.jiomeet.nativesdk.broadcast");
      _coresdkPlugin.setScreenShareConfig(screenShareConfig);
    }
  }

  Future<void> coreSdkPluginCallbacks() async {
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event == "meetingStarted") {
        setState(() {
          _meetingStatus = "Started";
        });
      }

      if (event == "meetingEnded") {
        setState(() {
          _meetingStatus = "Ended";
        });
      }

      if (event is Map) {
        String? eventType = event["event"];
        String? name = event["name"];
        String? userId = event["userId"];

        if (eventType == "remoteUserJoinedMeeting") {
          print("Remote user joined: $name $userId");
        }

        if (eventType == "remoteUserLeftMeeting") {
          print("Remote user left: $name $userId");
        }
      }

      if (event == "minimizeMeetingView") {
        print("On minimizeMeetingView");
      }
    });
    var config = SetCoreSdkConfig(
        enableFlipCamera: true,
        isMoreFeaturesEnabled: true,
        isShareEnabled: true,
        headphonesOrEarpieceOnly: true,
        enableAppMinimize: true);
    await _coresdkPlugin.setConfig(config);
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
                    var meetingDetails = MeetingDetails(
                        meetingId: "meetingId",
                        meetingPin: "meetingPin",
                        displayName: "display_name",
                        isInitialAudioOn: false,
                        isInitialVideoOn: false);
                    await _coresdkPlugin
                        .launchMeetingCoreTemplateUi(meetingDetails);
                  } on PlatformException {
                    _meetingStatus = "error while joining";
                  }
                },
                child: const Text('Join Meeting'),
              ),
              const SizedBox(height: 8),
              if (Platform.isAndroid && _meetingStatus == "Started")
                TextButton(
                  onPressed: () async {
                    try {
                      await _coresdkPlugin.exitPipMode();
                    } on PlatformException {
                      // ignore
                    }
                  },
                  child: const Text('Exit PIP'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
