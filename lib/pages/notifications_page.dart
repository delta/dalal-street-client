import 'dart:math';

import 'package:dalal_street_client/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as test;
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
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
  List<test.Notification> notifEvents = [];
  int i = 1;
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (notifEvents[notifEvents.length - 1].id > 0) {
            context.read<NotificationsCubit>().getMoreNotifications();
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
            children: [
              const SizedBox(height: 23),
              StreamBuilder(
                  stream: notifStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('error');
                      } else if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                          style: const TextStyle(color: white, fontSize: 16),
                        );
                      } else {
                        return const Text('No new notifications');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  }),
              notificationUI(context)
            ],
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
          if (state.getNotifResponse.moreExists) {
            notifEvents.addAll(state.getNotifResponse.notifications);
            if (i == 1) {
              notifEvents.remove(notifEvents[0]);
              i++;
            }
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: notifEvents.length,
            itemBuilder: (context, index) {
              test.Notification notification = notifEvents[index];

              String text = notification.text;
              String isCreatedAt = notification.createdAt;

              bool isBroadcast = notification.isBroadcast;

              return notifItem(text, isBroadcast, isCreatedAt);
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
                  onPressed: () =>
                      context.read<NotificationsCubit>().getMoreNotifications(),
                  child: const Text('Retry'),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: white,
            ),
          );
        }
      });

  // ignore: non_constant_identifier_names
  String ISOtoDateTime(String createdAt) {
    DateTime createdAtTime = DateTime.parse(createdAt);
    DateTime currentTime = DateTime.now();
    Duration diff = currentTime.difference(createdAtTime);
    int hourDifference = diff.inHours - (diff.inDays * 24);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return (diff.inMinutes.toString() + ' minutes ago');
      } else if (diff.inHours == 1) {
        return (diff.inHours.toString() + ' hour ago');
      } else {
        return (diff.inHours.toString() + ' hours ago');
      }
    } else {
      return (diff.inDays.toString() +
          ' days' +
          '  ' +
          hourDifference.toString() +
          '  '
              'hours ago');
    }
  }

  Widget notifItem(String notif, bool islatest, String createdAt) {
    Color iconColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    if (!islatest) {
      return (Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 100) * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(notif.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                ]),
          ],
        ),
      ));
    } else {
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
                          width: MediaQuery.of(context).size.width * 0.8,
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
}
