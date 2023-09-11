
class MeetingDetails {
  String meetingId;
  String meetingPin;
  String displayName;

  MeetingDetails({required this.meetingId, required this.meetingPin, required this.displayName});

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
      'meetingPin': meetingPin,
      'displayName': displayName,
    };
  }
}
