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
              const SizedBox(
                height: 20,
              ),
              notifList()
            ]));
  }

  Widget notifList() =>
      BlocBuilder<NotificationsBloc, NotifState>(builder: (context, state) {
        if (state is GetNotifSuccess) {
          if (state.notifList.moreExists) {
            notifEvents.addAll(state.notifList.notifications);
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
                  child: notifItem(id, userid, createdAt, isBroadcast),
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
                  onPressed: () => context.read<NotificationsBloc>().add(
                      GetMoreNotifications(
                          notifEvents[notifEvents.length - 1].id - 1)),
                  child: const Text('Retry'),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          );
        }
      });

  Widget notifItem(
    int id,
    int userid,
    String createdAt,
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
                        child: Text(id.toString(),
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
                            child: Text(id.toString(),
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

class NotifsDetail extends StatelessWidget {
  final int id;
  final int userId;
  final String text;

  const NotifsDetail({
    Key? key,
    required this.id,
    required this.userId,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: background2, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox.square(
              dimension: 5,
            ),
            const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: whiteWithOpacity75),
                  textAlign: TextAlign.left,
                )),
            const Padding(
              padding: EdgeInsets.all(15),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                fit: FlexFit.loose,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 16, color: lightGray),
                ),
                fit: FlexFit.loose,
              ),
            )
          ]),
    )));
  }
}
