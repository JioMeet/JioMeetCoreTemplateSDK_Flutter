
import 'package:coresdk_plugin/Environment.dart';
import 'package:coresdk_plugin/set_coresdk_config.dart';

import 'coresdk_plugin_platform_interface.dart';

class JioCoreSdkPlugin {

  Future<void> launchMeetingCoreTemplateUi(String meetingId, String meetingPin, String name, bool isInitialAudioOn, bool isInitialVideoOn) {
    return CoreSdkPluginPlatform.instance.launchMeetingCoreTemplateUi(meetingId, meetingPin, name, isInitialAudioOn, isInitialVideoOn);
  }

  Future<void> setEnvironment(NetWorkEnvironment environment) {
    return CoreSdkPluginPlatform.instance.setEnvironment(environment.name);
  }

  Future<void> setAuthParams(String token, String userId) {
    return CoreSdkPluginPlatform.instance.setAuthParams(token,userId);
  }

  Future<void> setConfig(SetCoreSdkConfig config) {
    return CoreSdkPluginPlatform.instance.setConfig(config);
  }

}
