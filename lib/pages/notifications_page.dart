import 'dart:math';

import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as notifications;
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotifsState();
}

class _NotifsState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  final notifStream = getIt<GlobalStreams>().notificationStream;
  List<notifications.Notification> notifEvents = [];
  int lastnotificationId = 0;
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications(lastnotificationId);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (notifEvents[notifEvents.length].id > 0) {
            context
                .read<NotificationsCubit>()
                .getNotifications(lastnotificationId);
          }
        }
      }
    });
  }

  @override
  Widget build(context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [const SizedBox(height: 23), notificationUI(context)],
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
                textAlign: TextAlign.right,
              ),
              const SizedBox(
                height: 20,
              ),
              notifList()
            ]));
  }

  Widget notifList() =>
      BlocBuilder<NotificationsCubit, NotificationsCubitState>(
          builder: (context, state) {
        if (state is GetNotifSuccess) {
          notifEvents.addAll(state.getNotifResponse.notifications);

          return ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: notifEvents.length,
            itemBuilder: (context, index) {
              notifications.Notification notification = notifEvents[index];

              String text = notification.text;
              String isCreatedAt = notification.createdAt;

              return notifItem(text, isCreatedAt);
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        } else if (state is GetNotifFailure) {
          return Column(
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context
                      .read<NotificationsCubit>()
                      .getNotifications(lastnotificationId),
                  child: const Text('Retry'),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: DalalLoadingBar(),
          );
        }
      });

  Widget notifItem(String notif, String createdAt) {
    Color iconColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

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
                      SizedBox(
                          width: 45,
                          height: 45,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(43, 52, 52, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(45, 45)),
                                    ))),
                            Positioned(
                                top: 9.7,
                                left: 12.9,
                                child: SvgPicture.asset(
                                    'assets/icon/notification-icon.svg',
                                    semanticsLabel: 'notification',
                                    width: 22,
                                    height: 24,
                                    color: iconColor)),
                          ])),
                      const Positioned(child: SizedBox(width: 20)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(notif.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(ISOtoDateTime(createdAt),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: iconColor)),
                  ),
                ]),
          ])),
    );
  }
}
