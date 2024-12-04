import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:zoom/resources/auth_methods.dart';
import 'package:zoom/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  Future<void> createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      // Handle user information
      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName ?? 'Guest';
      } else {
        name = username;
      }

      // Define meeting options
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName,
        userDisplayName: name,
        userEmail: _authMethods.user.email,
        userAvatarUrl: _authMethods.user.photoURL,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        featureFlags: {
          'isWelcomePageEnabled': false, // Disable welcome page
        },
      );

      // Add meeting to history
      _firestoreMethods.addToMeetingHistory(roomName);

      // Join the meeting
      await JitsiMeetWrapper.joinMeeting(options: options);
    } catch (error) {
      print("Error: $error");
    }
  }
}