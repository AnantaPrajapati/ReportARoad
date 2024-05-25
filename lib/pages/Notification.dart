import 'package:flutter/material.dart';
import 'package:reportaroad/pages/NotificationService.dart' as customNotification;

class NotificationPage extends StatefulWidget {
  final String userId;
  final customNotification.NotificationService notificationService;

  const NotificationPage({
    required this.userId,
    required this.notificationService,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<customNotification.Notification>> _notificationsFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await widget.notificationService.markAsRead(notificationId);
      setState(() {
        _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to mark notification as read")),
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await widget.notificationService.deleteNotification(notificationId);
      setState(() {
        _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete notification")),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    key: _scaffoldKey,
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: AppBar(
          backgroundColor: Color(0xFF2C75FF),
          elevation: 5,
          title: const Text(
            "Notifications",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
    ),
    body: FutureBuilder<List<customNotification.Notification>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        print("FutureBuilder state: ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text("Error fetching notifications"));
        }

        final notifications = snapshot.data ?? [];
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        if (notifications.isEmpty) {
          return Center(child: Text("No notifications available"));
        }

        return Column(
          children: [
            // IconButton(
            //   icon: Icon(Icons.refresh),
            //   color: Colors.blue,
            //   onPressed: () {
            //     setState(() {
            //       _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
            //     });
            //   },
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final isRead = notification.isRead;
                  final bgColor = isRead ? Colors.grey[200] : Colors.lightBlue[100];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Dismissible(
                      key: Key(notification.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => deleteNotification(notification.id),
                      child: GestureDetector(
                        onTap: () {
                          if (!isRead) {
                            markAsRead(notification.id);
                          }
                        },
                        child: Card(
                          color: bgColor,
                          elevation: isRead ? 0.4 : 2,
                          child: ListTile(
                            title: Text(notification.message),
                            subtitle: Text("Time: ${notification.timestamp}"),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
  );
}
}