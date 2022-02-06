//import 'package:dalal_street_client/blocs/notifications/notifications_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
//import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
//import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

final notifStream = getIt<GlobalStreams>().notificationStream;

class NotifsPage extends StatefulWidget {
  const NotifsPage({Key? key}) : super(key: key);

  @override
  State<NotifsPage> createState() => _NotifsState();
}

class _NotifsState extends State<NotifsPage> {
  @override
  void initState() {
    super.initState();
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
            ],
          ),
        ),
      );

  /*Widget _onGetNotifications() {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
      if (state is NotificationsSuccess) {
        logger.i('got notifications successfully');
        showSnackBar(context, 'got notifications successfully');
      } else if (state is NotificationsFailure) {
        logger.i('unsuccessful');
        showSnackBar(context, state.msg);
      }
    }, builder: (context, state) {
      if (state is NotificationsLoading) {
        logger.i('loading');
        return const Center(child: CircularProgressIndicator());
      } else if (state is NotificationsFailure) {
        logger.i('unsuccessful');
      }
      return const SizedBox();
    });
  }
  */
}
