
import 'package:coresdk_plugin/Environment.dart';
import 'package:coresdk_plugin/screenshare_config.dart';
import 'package:coresdk_plugin/set_coresdk_config.dart';
import 'package:coresdk_plugin/meeting_details.dart';
import 'coresdk_plugin_platform_interface.dart';

class JioCoreSdkPlugin {

  Future<void> launchMeetingCoreTemplateUi(MeetingDetails meeting_details) {
    return CoreSdkPluginPlatform.instance.launchMeetingCoreTemplateUi(meeting_details);
  }

  Future<void> leaveMeeting() {
    return CoreSdkPluginPlatform.instance.leaveMeeting();
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

  Future<void> setScreenShareConfig(ScreenshareConfig config) {
    return CoreSdkPluginPlatform.instance.setScreenShareConfig(config);
  }

  Future<void> onMaximizeMeetingView() {
    return CoreSdkPluginPlatform.instance.onMaximizeMeetingView();
  }
}
