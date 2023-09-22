import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coresdk_plugin/coresdk_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCoreSdkPlugin platform = MethodChannelCoreSdkPlugin();
  const MethodChannel channel = MethodChannel('coresdk_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
}
