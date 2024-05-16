 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reportaroad/main.dart';


class Notification {
  final int id;
  final String userId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String actionType;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.actionType,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    print("from json reu");
    return Notification(
      id: json['id'] as int,
      userId: json['userId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']), 
      isRead: json['read'], 

      actionType: json['actionType'],
    );
  }
}
class NotificationService {


  Future<Notification> createNotification(
      String userId,
      String message,
      String actionType,
      bool isRead
      ) async {
    final response = await http.post(
      Uri.parse('${serverBaseUrl}createNotification'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'message': message,
        'actionType': actionType,
        'isRead':isRead
      }),
    );

    if (response.statusCode == 200) {
      await getNotificationCount(email);
      return Notification.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create notification");
    }
  }

  Future<List<Notification>> getNotifications(String userId) async {

    print(userId);
    final response = await http.get(
      Uri.parse('${serverBaseUrl}notifications/user/?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await getNotificationCount(email);
      print(response.body);
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Notification.fromJson(item)).toList();
    } else {
      print("responseBody is ");
      print(response.body);
      throw Exception("Failed to fetch notifications");
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final response = await http.put(
      Uri.parse('${serverBaseUrl}notifications/mark-as-read/?notificationId=$notificationId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      await getNotificationCount(email);
      throw Exception("Failed to mark notification as read");
    }
  }
 
  Future<void> deleteNotification(int notificationId) async {
    final response = await http.delete(
      Uri.parse('${serverBaseUrl}notifications/delete?notificationId=$notificationId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      await getNotificationCount(email);
      throw Exception("Failed to delete notification");
    }
  }

}
Future<void> getNotificationCount(String userId) async {
  var notificationCount=0;
  final url = Uri.parse('${serverBaseUrl}notifications/user/count?userId=$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final int count = int.parse(response.body);
    notificationCount=count;
  } else {
    throw Exception('Failed to load notification count');
  }
}