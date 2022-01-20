import 'package:dalal_street_client/blocs/admin/send_news/send_news_cubit.dart';
import 'package:dalal_street_client/blocs/admin/send_notifications/send_notifications_cubit.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController newsText = TextEditingController();
  TextEditingController notifText = TextEditingController();
  TextEditingController notifUserId = TextEditingController();
  bool? isGlobal;

  @override
  initState() {
    super.initState();
    //final newsCubit = BlocProvider.of<SendNewsCubit>(context);

    context.read<SendNewsCubit>().add(SendNewsCubit());
    context.read<SendNotificationsCubit>().add(SendNotificationsCubit());
  }

  @override
  Widget build(context) => BlocConsumer<SendNewsCubit, SendNewsState>(
        listener: (context, state) {
          if (state is SendNewsFailure) {}
          if (state is SendNewsSuccess) {
            showSnackBar(context, state.news);
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: (() {
              if (state is SendNewsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildBody(context);
            })(),
          ),
        ),
      );

  Widget buildBody(context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
              Tab(icon: Icon(Icons.ac_unit)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: newsText,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter News',
                      ),
                    ),
                    TextButton(
                        onPressed: () => _onSendNews(context),
                        child: const Text('news sent')),
                    TextField(
                      controller: notifUserId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter User ID',
                      ),
                    ),
                    TextField(
                      controller: notifText,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Text',
                      ),
                    ),
                    TextButton(
                        onPressed: () => _onSendNotifications(context),
                        child: const Text('notifs sent')),
                  ],
                ),
              ),
            ),
            Container(),
            Container()
          ],
        ),
      ),
    );
  }

  @override
  /*Widget build(context) =>
      BlocConsumer<SendNotificationsCubit, SendNotificationsState>(
        listener: (context, state) {
          if (state is SendNotificationsFailure) {}
          if (state is SendNotificationsSuccess) {
            showSnackBar(context, 'Sent notifications successfully');
          }
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: (() {
              if (state is SendNotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return buildBody(context);
            })(),
          ),
        ),
      );
      */

  void _onSendNews(BuildContext context) =>
      context.read<SendNewsCubit>().sendNews('Sent news successfully');

  void _onSendNotifications(BuildContext context) => context
      .read<SendNotificationsCubit>()
      .sendNotifs(notifUserId.text, notifText.text, true);
}
