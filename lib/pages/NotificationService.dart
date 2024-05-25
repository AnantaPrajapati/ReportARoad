import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reportaroad/main.dart';

class Notification {
  final String id;
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
       id: json['_id'] != null ? json['_id'].toString() : '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
      isRead: json['isRead'] ?? false,
      actionType: json['actionType'] ?? '',
    );
  }
}

class NotificationService {
  Future<Notification> createNotification(
      String userId, String message, String actionType, bool isRead) async {
    final response = await http.post(
      Uri.parse('${serverBaseUrl}createNotification'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'message': message,
        'actionType': actionType,
        'isRead': isRead
      }),
    );

    if (response.statusCode == 200) {
      // await getNotificationCount(userId);
      return Notification.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create notification");
    }
  }

  Future<List<Notification>> getNotifications(String userId) async {
    print(userId);
    final response = await http.get(
      Uri.parse('${serverBaseUrl}getNotifications?userId=${userId}'),
      headers: {
        "Content-type": "application/json",
        "Cache-Control": "no-cache"
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      // await getNotificationCount(userId);
      print(response.body);
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Notification.fromJson(item)).toList();
    } else {
      // print("responseBody is ");
      // print(response.body);
      throw Exception("Failed to fetch notifications");
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final response = await http.put(
      Uri.parse(
          '${serverBaseUrl}markAsRead?notificationId=${notificationId}'),
      headers: {
        'Content-Type': 'application/json',
        "Cache-Control": "no-cache"
      },
    );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      // await getNotificationCount(userId);
      throw Exception("Failed to mark notification as read");
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final response = await http.post(
      Uri.parse(
          '${serverBaseUrl}deleteNotification?notificationId=${notificationId}'),
      headers: {
        'Content-Type': 'application/json',
            "Cache-Control": "no-cache"
      },
    );

    if (response.statusCode != 200) {
      // await getNotificationCount(userId);
      throw Exception("Failed to delete notification");
    }
  }
}

// Future<void> getNotificationCount(String userId) async {
//   var notificationCount = 0;
//   final url =
//       Uri.parse('${serverBaseUrl}notifications/user/count?userId=$userId');
//   final response = await http.get(url);

//   if (response.statusCode == 200) {
//     final int count = int.parse(response.body);
//     notificationCount = count;
//   } else {
//     throw Exception('Failed to load notification count');
//   }
// }
