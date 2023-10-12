import 'dart:async';

import 'package:coresdk_plugin/Environment.dart';
import 'package:coresdk_plugin/coresdk_plugin.dart';
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
  static const platform = MethodChannel('coresdk_plugin');
  String _meetingStatus = 'Not started';

  @override
  void initState() {
    super.initState();
    coreSdkPluginCallbacks();
    _coresdkPlugin.setEnvironment(NetWorkEnvironment.rc);
  }

  Future<void> coreSdkPluginCallbacks() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == "meetingEnded") {
        setState(() {
          _meetingStatus = "Ended";
        });
      }
    });
    var config = SetCoreSdkConfig(enableFlipCamera: true);
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
                  await _coresdkPlugin.launchMeetingCoreTemplateUi("meeting_id", "meeting_password", "meeting_name", false, false);
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
