import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_portal/utils/notification_provider.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false).clearNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Alerts')),
      body: notificationProvider.notifications.isEmpty
          ? Center(child: Text('No notifications yet'))
          : ListView.builder(
        itemCount: notificationProvider.notifications.length,
        itemBuilder: (context, index) {
          final item = notificationProvider.notifications[index];
          return ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['body']),
            trailing: Text(item['timestamp'].split(' ')[0]),
            tileColor: _getNotificationColor(item['type']),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'Urgent':
        return Colors.red.shade100;
      case 'Reminder':
        return Colors.orange.shade100;
      default:
        return Colors.blue.shade50;
    }
  }
}
