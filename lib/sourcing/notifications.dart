import 'package:flutter/material.dart';

import 'OnBoarding/fragments.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<NotificationItem> notifications = List.generate(
    10,
        (index) => NotificationItem(
      id: index,
      title: 'Notification Title $index',
      body: 'This is the detailed description for notification $index.',
      timestamp: '2 hrs ago',
      isRead: false,
      isStarred: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void updateNotification(NotificationItem item) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == item.id);
      if (index != -1) {
        notifications[index] = item;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins-Regular",
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFD42D3F),
        leading: InkWell(
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey.shade300),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            child: Icon(Icons.arrow_back_ios_sharp, size: 16),
          ),
          onTap: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Fragments())),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                notifications.forEach((n) {
                  n.isRead = false;
                  n.isStarred = false;
                });
              });
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
            Tab(text: 'Starred'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotificationList(
            type: 'all',
            notifications: notifications,
            onUpdate: updateNotification,
          ),
          NotificationList(
            type: 'unread',
            notifications: notifications.where((n) => !n.isRead).toList(),
            onUpdate: updateNotification,
          ),
          NotificationList(
            type: 'read',
            notifications: notifications.where((n) => n.isRead).toList(),
            onUpdate: updateNotification,
          ),
          NotificationList(
            type: 'starred',
            notifications: notifications.where((n) => n.isStarred).toList(),
            onUpdate: updateNotification,
          ),
        ],
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final String type;
  final List<NotificationItem> notifications;
  final ValueChanged<NotificationItem> onUpdate;

  NotificationList({
    required this.type,
    required this.notifications,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationCard(
          notification: notifications[index],
          onUpdate: onUpdate,
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final ValueChanged<NotificationItem> onUpdate;

  NotificationCard({
    required this.notification,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          notification.isRead
              ? Icons.mark_email_read
              : Icons.mark_email_unread,
          color: notification.isRead ? Colors.green : Colors.orange,
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notification.body),
        trailing: IconButton(
          icon: Icon(
            notification.isStarred ? Icons.star : Icons.star_border,
            color: notification.isStarred ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            onUpdate(notification.copyWith(isStarred: !notification.isStarred));
          },
        ),
        onTap: () {
          onUpdate(notification.copyWith(isRead: true));
        },
      ),
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String timestamp;
  late final bool isRead;
  late final bool isStarred;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.isStarred = false,
  });

  NotificationItem copyWith({bool? isRead, bool? isStarred}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}
