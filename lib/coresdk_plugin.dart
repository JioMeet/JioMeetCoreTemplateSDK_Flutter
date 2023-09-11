
import 'coresdk_plugin_platform_interface.dart';

class JioCoreSdkPlugin {

  Future<void> launchMeetingCoreTemplateUi(String meetingId, String meetingPin, String name) {
    return CoreSdkPluginPlatform.instance.launchMeetingCoreTemplateUi(meetingId, meetingPin, name);
  }

}
