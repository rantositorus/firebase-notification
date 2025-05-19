import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  static Future<void> initializeAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required NotificationType type,
  }) async {
    Color? color;
    switch (type) {
      case NotificationType.success:
        color = Colors.green;
        break;
      case NotificationType.error:
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
        break;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        color: color,
      ),
    );
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {}
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {}
}

enum NotificationType {
  success,
  error,
  info,
}