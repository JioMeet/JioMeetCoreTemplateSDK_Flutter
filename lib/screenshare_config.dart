class ScreenshareConfig {
  String appGroupName;
  String screenShareExtensionBundleIdentifier;

  ScreenshareConfig(
      {required this.appGroupName,
        required this.screenShareExtensionBundleIdentifier,
      });

  Map<String, dynamic> toJson() {
    return {
      'appGroupName': appGroupName,
      'screenShareExtensionBundleIdentifier': screenShareExtensionBundleIdentifier,
    };
  }
}
