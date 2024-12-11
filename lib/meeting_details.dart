class MeetingDetails {
  String meetingId;
  String meetingPin;
  String displayName;
  bool isInitialAudioOn;
  bool isInitialVideoOn;
  String? hostToken;

  MeetingDetails(
      {required this.meetingId,
      required this.meetingPin,
      required this.displayName,
      this.isInitialAudioOn = false,
      this.isInitialVideoOn = false,
      this.hostToken,
      
      });

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
      'meetingPin': meetingPin,
      'displayName': displayName,
      'isInitialAudioOn': isInitialAudioOn,
      'isInitialVideoOn': isInitialVideoOn,
      'hostToken': hostToken,
    };
  }
}
