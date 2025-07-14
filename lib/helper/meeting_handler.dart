import 'package:chess_app/helper/schedule_meeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';


  final currentUser = FirebaseAuth.instance.currentUser;
  // initializing the Jitsi Meet SDK
  final jitsiMeet = JitsiMeet();
  DateTime? _selectedDateTime;
  

   // listener for Jitsi Meet events
  final listener = JitsiMeetEventListener(
    conferenceJoined: (url) {
      print("Conference Joined: $url");
    },
    participantJoined: (email, name, role, participantId) {
      print("Participant Joined: $name ($email)");
    },
    conferenceTerminated: (url, error) {
      print("Conference Terminated: $url, Error: $error");
    },
  );


  // generating instant meeting link
  Future<String> generateInstantMeetingLink() async {
    final instantRoomName = 'InstantMeeting${DateTime.now().millisecondsSinceEpoch}';
    final meetingUrl = 'https://meet.jit.si$instantRoomName';
    return meetingUrl;
  }

  // generating scheduled meeting link
  Future<String> generateScheduledMeetingLink(ScheduleMeeting meeting) async {
    final scheduledRoomName = meeting.roomName;
    final meetingUrl = 'https://meet.jit.si/$scheduledRoomName';
    return meetingUrl;
  }

  // joining the meeting
  Future<void> joinInstantMeeting(String instantRoomName) async {
  // defining meeting options 
  var options = JitsiMeetConferenceOptions(
    serverURL: 'https://8x8.vc',
    room: instantRoomName,
    configOverrides: {
      'startWithAudioMuted': true,
      'startWithVideoMuted': true,
      'subject': 'Instant Meeting',
    },
    featureFlags: {
      'unsaferoomwarning.enabled': false,
    },
    userInfo: JitsiMeetUserInfo(
      displayName: 'Chess User',
      email: currentUser?.email,
    )
  );
    await jitsiMeet.join(options, listener);
  }

 Future<void> joinScheduledMeeting(String scheduledRoomName) async {
    var options = JitsiMeetConferenceOptions(
      room: scheduledRoomName,
      serverURL: 'https://meet.jit.si',
      configOverrides: {
        'startWithAudioMuted': true,
        'startWithVideoMuted': true,
        'subject': 'Scheduled Meeting',
      },
      featureFlags: {
        'unsaferoomwarning.enabled': false,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: 'Chess User',
        email: currentUser?.email,
      )
    );
    jitsiMeet.join(options, listener);
 }

Future<void> storeMeeting(String senderId, String receiverId, DateTime scheduledTime) async {
  final meetingUrl = await generateInstantMeetingLink();
  await FirebaseFirestore.instance
      .collection('Meetings')
      .add({
        'senderId': senderId,
        'receiverId': receiverId,
        'meetingUrl': await generateInstantMeetingLink(),
        'scheduledTime': scheduledTime,
        'timeStamp': FieldValue.serverTimestamp(),
      });
}
