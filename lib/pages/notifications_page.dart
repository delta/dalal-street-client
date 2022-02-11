//import 'package:dalal_street_client/blocs/notifications/notifications_bloc.dart';
import 'package:dalal_street_client/blocs/notifications_cubit/notifications_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';

import 'package:dalal_street_client/pages/notifications_details.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as test;
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';

import 'package:flutter/material.dart';
// ignore: implementation_imports
//import 'package:provider/src/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                      return const SizedBox();
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
                        return const Text('empty data');
                      }
                    } else {
                      return Text('State: ${snapshot.connectionState}');
                    }
                  }),
              //_onGetNotifications(),
              notificationUI(context)
            ],
          ),
        ),
      );

  /*_onGetNotifications() {
    return BlocConsumer<NotificationsCubitState, NotificationsCubitState>(
        listener: (context, state) {
      if (state is GetNotifSuccess) {
        logger.i('successful');
        showSnackBar(context, 'Notifications set successfully');
      } else if (state is GetNotifFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.error);
      }
    }, builder: (context, state) {
      return notificationUI(context);
    });
  }
  */

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
              int id = notification.id;
              int userid = notification.userId;
              String text = notification.text;
              String createdAt = notification.createdAt;
              bool isBroadcast = notification.isBroadcast;

              return GestureDetector(
                  child: notifItem(text, isBroadcast),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NotifsDetail(id: id, userId: userid, text: text),
                      )));
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

  Widget notifItem(
    String notif,
    // int id,
    //int userid,
    //String createdAt,
    bool islatest,
  ) {
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
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(notif.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      ),
                      fit: FlexFit.loose,
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
      return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Flexible(
                            child: Text(notif.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            fit: FlexFit.loose),
                      ),
                      const SizedBox.square(
                        dimension: 5,
                      ),
                    ]),
                const SizedBox.square(
                  dimension: 20,
                ),
              ]));
    }
  }
}
