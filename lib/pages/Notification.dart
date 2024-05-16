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

  Future<void> markAsRead(int notificationId) async {
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

  Future<void> deleteNotification(int notificationId) async {
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching notifications"));
          }
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return Center(child: Text("No notifications available"));
          }
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isRead = notification.isRead;
              final bgColor = isRead ? Colors.white : Colors.white70;
              return Column(
                children: [
                  SizedBox(height: 5,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Dismissible(
                      key: Key(notification.id.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16.0),
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
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
