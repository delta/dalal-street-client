import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';

import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as notification;
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  List<MaterialColor> colors = [
    Colors.amber,
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.pink
  ];

  @override
  void initState() {
    super.initState();

    context.read<NotificationsCubit>().getNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<NotificationsCubit>().getNotifications();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(context) => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [const SizedBox(height: 5), notificationUI(context)],
            ),
          ),
        ),
      );

  Widget notificationUI(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
                // textAlign: TextAlign.right,
              ),
              const SizedBox(
                height: 20,
              ),
              notificationList()
            ]));
  }

  Widget notificationList() {
    List<notification.Notification> notifications = [];
    return BlocBuilder<NotificationsCubit, NotificationsCubitState>(
        builder: (context, state) {
      if (state is GetNotificationSuccess) {
        notifications.addAll(state.notifications);

        return ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var notification = notifications[index];

            return notificationItem(
                notification.text, notification.createdAt, notification.id);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      } else if (state is GetNotificationFailure) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () =>
                      context.read<NotificationsCubit>().getNotifications(),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: DalalLoadingBar(),
        );
      }
    });
  }

  Widget notificationItem(String text, String createdAt, int id) {
    Color iconColor = colors[id % colors.length];
    return Card(
      color: const Color.fromRGBO(19, 22, 20, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          )),
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: baseColor,
                          child: SvgPicture.asset(
                              'assets/icon/notification-icon.svg',
                              semanticsLabel: 'notification',
                              width: 22,
                              height: 24,
                              color: iconColor),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(ISOtoDateTime(createdAt),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: iconColor)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ]),
          ])),
    );
  }
}
