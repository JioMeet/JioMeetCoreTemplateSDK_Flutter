import 'package:flutter_test/flutter_test.dart';
import 'package:coresdk_plugin/coresdk_plugin.dart';
import 'package:coresdk_plugin/coresdk_plugin_platform_interface.dart';
import 'package:coresdk_plugin/coresdk_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCoresdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements CoreSdkPluginPlatform {


  @override
  Future<void> launchMeetingCoreTemplateUi(String meetingId, String meetingPin, String name) {

    throw UnimplementedError();
  }
}

void main() {
  final CoreSdkPluginPlatform initialPlatform = CoreSdkPluginPlatform.instance;

  test('$MethodChannelCoreSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCoreSdkPlugin>());
  });
}
