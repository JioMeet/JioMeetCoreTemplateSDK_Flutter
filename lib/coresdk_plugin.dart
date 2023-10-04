
import 'package:coresdk_plugin/Environment.dart';

import 'coresdk_plugin_platform_interface.dart';

class JioCoreSdkPlugin {

  Future<void> launchMeetingCoreTemplateUi(String meetingId, String meetingPin, String name, bool isInitialAudioOn, bool isInitialVideoOn) {
    return CoreSdkPluginPlatform.instance.launchMeetingCoreTemplateUi(meetingId, meetingPin, name, isInitialAudioOn, isInitialVideoOn);
  }

  Future<void> setEnvironment(NetWorkEnvironment environment) {
    return CoreSdkPluginPlatform.instance.setEnvironment(environment.name);
  }

}
