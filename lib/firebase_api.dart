import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();

    // Get the Firebase Cloud Messaging token
    final fCMToken = await _firebaseMessaging.getToken();
    print('Initial Token: $fCMToken');

    await FirebaseMessaging.instance.subscribeToTopic('general_notification');

    // Set the background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // ✅ Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('Token Refreshed: $newToken');

      // If user is logged in → you can also send token to server here (future work)
    });
  }

}


// Future<void> getAndSendFCMToken() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // Request permission
//   await messaging.requestPermission();
//
//   // Get token
//   String? fCMToken = await messaging.getToken();
//   if (fCMToken != null) {
//     print('FCM Token: $fCMToken');
//
//     // Send the token to your backend server
//     await sendTokenToServer(fCMToken);
//   }
// }
//
// Future<void> sendTokenToServer(String token) async {
//   final response = await http.post(
//     Uri.parse('https://your-backend-api-url.com/store-fcm-token'),
//     body: {'fcm_token': token},
//   );
//
//   if (response.statusCode == 200) {
//     print('Token sent successfully to the server');
//   } else {
//     print('Failed to send token to the server');
//   }
// }