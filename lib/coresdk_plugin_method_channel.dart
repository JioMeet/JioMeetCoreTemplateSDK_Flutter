import 'package:coresdk_plugin/meeting_details.dart';
import 'package:coresdk_plugin/screenshare_config.dart';
import 'package:coresdk_plugin/set_coresdk_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'coresdk_plugin_platform_interface.dart';
import 'meeting_details.dart';
import 'dart:convert';

/// An implementation of [CoreSdkPluginPlatform] that uses method channels.
class MethodChannelCoreSdkPlugin extends CoreSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('coresdk_plugin');

  @override
  Future<String?> launchMeetingCoreTemplateUi(
      MeetingDetails meeting_details) async {
    final Map<String, dynamic> meeting_details_json = <String, dynamic>{
      'meeting_details': jsonEncode(meeting_details.toJson()),
    };

    return await methodChannel.invokeMethod<String>(
        'launchMeetingCoreTemplateUi', meeting_details_json);
  }

  @override
  Future<String?> leaveMeeting() async {
    return await methodChannel.invokeMethod<String>('leaveMeeting');
  }

  @override
  Future<String?> setEnvironment(String environment) async {
    final Map<String, dynamic> configParams = <String, dynamic>{
      'environmentName': environment
    };
    return await methodChannel.invokeMethod<String>(
        'setEnvironment', configParams);
  }

  @override
  Future<String?> setAuthParams(String token, String userId) async {
    final Map<String, dynamic> configParams = <String, dynamic>{
      'jwtToken': token,
      'userId': userId
    };
    return await methodChannel.invokeMethod<String>(
        'setAuthParams', configParams);
  }

  @override
  Future<String?> setConfig(SetCoreSdkConfig config) async {
    final Map<String, dynamic> configParams = <String, dynamic>{
      'config': config.toJson(),
    };
    return await methodChannel.invokeMethod<String>(
        'setCoreSdkConfig', configParams);
  }

  @override
  Future<String?> setScreenShareConfig(ScreenshareConfig config) async {
    final Map<String, dynamic> configParams = <String, dynamic>{
      'screenShareConfig': config.toJson(),
    };
    return await methodChannel.invokeMethod<String>(
        'setScreenShareConfig', configParams);
  }

  @override
  Future<void> onMaximizeMeetingView() async {
    try {
      await methodChannel.invokeMethod('onMaximizeMeetingView');
    } on PlatformException catch (e) {
      print("Failed to invoke callback: '${e.message}'.");
    }
  }
}
