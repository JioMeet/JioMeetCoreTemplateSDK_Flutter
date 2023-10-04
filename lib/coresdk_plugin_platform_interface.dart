import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'coresdk_plugin_method_channel.dart';

abstract class CoreSdkPluginPlatform extends PlatformInterface {
  /// Constructs a CoresdkPluginPlatform.
  CoreSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CoreSdkPluginPlatform _instance = MethodChannelCoreSdkPlugin();

  /// The default instance of [CoreSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCoreSdkPlugin].
  static CoreSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CoreSdkPluginPlatform] when
  /// they register themselves.
  static set instance(CoreSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> launchMeetingCoreTemplateUi(String meetingId, String meetingPin,
      String name, bool isInitialAudioOn, bool isInitialVideoOn) {
    throw UnimplementedError(
        'launchMeetingCoreTemplateUi has not been implemented.');
  }

  Future<void> setEnvironment(String environment) {
    throw UnimplementedError('setEnvironment has not been implemented.');
  }
}
