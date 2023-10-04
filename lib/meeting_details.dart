class MeetingDetails {
  String meetingId;
  String meetingPin;
  String displayName;
  bool isInitialAudioOn = false;
  bool isInitialVideoOn = false;

  MeetingDetails(
      {required this.meetingId,
      required this.meetingPin,
      required this.displayName,
      required this.isInitialAudioOn,
      required this.isInitialVideoOn});

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
      'meetingPin': meetingPin,
      'displayName': displayName,
      'isInitialAudioOn': isInitialAudioOn,
      'isInitialVideoOn': isInitialVideoOn
    };
  }
}
