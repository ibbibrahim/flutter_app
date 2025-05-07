import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationProvider extends ChangeNotifier {
  int _notificationCount = 0;
  List<Map<String, dynamic>> _notifications = [];

  int get notificationCount => _notificationCount;
  List<Map<String, dynamic>> get notifications => _notifications;

  NotificationProvider() {
    _listenToLiveNotifications();
  }

  void _listenToLiveNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final newNotification = {
        'title': message.notification?.title ?? 'New Notification',
        'body': message.notification?.body ?? '',
        'timestamp': DateTime.now().toString(),
        'type': message.data['type'] ?? 'General',
      };

      _notifications.insert(0, newNotification);
      _notificationCount++;

      notifyListeners(); // Update UI
    });
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }
}
