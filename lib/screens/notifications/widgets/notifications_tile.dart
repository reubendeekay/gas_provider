import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gas_provider/models/notification_model.dart';

class NotificationsTile extends StatelessWidget {
  const NotificationsTile({Key? key, required this.notification})
      : super(key: key);
  final NotificationsModel notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: CachedNetworkImageProvider(
                  notification.imageUrl!,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(child: Text(notification.message!)),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }
}
