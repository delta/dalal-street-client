import 'package:dalal_street_client/blocs/notifications/notifications_bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart'
    as test;
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
//import 'package:provider/src/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final notifStream = getIt<GlobalStreams>().notificationStream;

class NotifsPage extends StatefulWidget {
  const NotifsPage({Key? key}) : super(key: key);

  @override
  State<NotifsPage> createState() => _NotifsState();
}

class _NotifsState extends State<NotifsPage> {
  final ScrollController _scrollController = ScrollController();
  List<test.Notification> notifEvents = [];
  int i = 1;
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const GetNotifications());
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (notifEvents[notifEvents.length - 1].id > 0) {
            context.read<NotificationsBloc>().add(GetMoreNotifications(
                notifEvents[notifEvents.length - 1].id - 1));
          }
        }
      }
    });
  }

  @override
  Widget build(context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 23),
              StreamBuilder(
                  stream: notifStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
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
              _onGetNotifications()
            ],
          ),
        ),
      );

  _onGetNotifications() {
    return BlocConsumer<NotificationsBloc, NotifState>(
        listener: (context, state) {
      if (state is GetNotifSuccess) {
        logger.i('successful');
        showSnackBar(context, 'Notif set successfully');
      } else if (state is GetNotifFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.error);
      }
    }, builder: (context, state) {
      if (state is GetNotifFailure) {
        logger.i('unsuccessful');
      }
      return notificationUI(context);
    });
  }

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
                textAlign: TextAlign.start,
              ),
              context.read<NotificationsBloc>().getNotifications(),
              const SizedBox(
                height: 20,
              ),
            ]));
  }
}
