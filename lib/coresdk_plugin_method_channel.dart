import 'package:coresdk_plugin/meeting_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'coresdk_plugin_platform_interface.dart';

/// An implementation of [CoreSdkPluginPlatform] that uses method channels.
class MethodChannelCoreSdkPlugin extends CoreSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('coresdk_plugin');

  @override
  Future<String?> launchMeetingCoreTemplateUi(
      String meetingId,
      String meetingPin,
      String name,
      bool isInitialAudioOn,
      bool isInitialVideoOn) async {
    return await methodChannel.invokeMethod<String>(
        'launchMeetingCoreTemplateUi',
        MeetingDetails(
                meetingId: meetingId,
                meetingPin: meetingPin,
                displayName: name,
                isInitialAudioOn: isInitialAudioOn,
                isInitialVideoOn: isInitialVideoOn)
            .toJson());
  }

  @override
  Future<String?> setEnvironment(String environment) async {
    final Map<String, dynamic> configParams = <String, dynamic>{
      'environmentName': environment
    };
    return await methodChannel.invokeMethod<String>(
        'setEnvironment', configParams);
  }
}
