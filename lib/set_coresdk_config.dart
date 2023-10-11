class SetCoreSdkConfig {
  bool enableFlipCamera = false;
  bool isChatEnabled = false;
  bool isParticipantPanelEnabled = false;
  bool isMoreFeaturesEnabled = false;
  bool isAudioOnlyModeEnabled = false;
  bool isVirtualBackgroundEnabled = false;
  bool isRecordingEnabled = true;
  bool isShareEnabled = true;
  bool showMeetingTitle = false;
  bool showConnectionStateIndicator = false;
  bool showAudioOptions = false;
  bool showMeetingInfo = false;
  bool showMeetingTimer = false;

  SetCoreSdkConfig(
      {required this.enableFlipCamera,
      this.isChatEnabled = false,
      this.isParticipantPanelEnabled = false,
      this.isMoreFeaturesEnabled = false,
      this.isAudioOnlyModeEnabled = false,
      this.isVirtualBackgroundEnabled = false,
      this.isRecordingEnabled = false,
      this.isShareEnabled = false,
      this.showMeetingTitle = false,
      this.showConnectionStateIndicator = false,
      this.showAudioOptions = false,
      this.showMeetingInfo = false,
      this.showMeetingTimer = false});

  Map<String, dynamic> toJson() {
    return {
      'enableFlipCamera': enableFlipCamera,
      'isChatEnabled': isChatEnabled,
      'isParticipantPanelEnabled': isParticipantPanelEnabled,
      'isMoreFeaturesEnabled': isMoreFeaturesEnabled,
      'isAudioOnlyModeEnabled': isAudioOnlyModeEnabled,
      'isVirtualBackgroundEnabled': isVirtualBackgroundEnabled,
      'isRecordingEnabled': isRecordingEnabled,
      'isShareEnabled': isShareEnabled,
      'showMeetingTitle': showMeetingTitle,
      'showConnectionStateIndicator': showConnectionStateIndicator,
      'showAudioOptions': showAudioOptions,
      'showMeetingInfo': showMeetingInfo,
      'showMeetingTimer': showMeetingTimer
    };
  }
}
