import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

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
                  builder: (context, state) {
                    Object notification = state.data!;

                    return Column(
                      children: [
                        Text((notification).toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: whiteWithOpacity50,
                            )),
                        const SizedBox(
                          width: 1.0,
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      );
}
