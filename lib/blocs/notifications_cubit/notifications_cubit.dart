import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetNotifications.pb.dart';
import 'package:equatable/equatable.dart';

import '../../config/log.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsCubitState> {
  NotificationsCubit() : super(NotificationsCubitInitial());

  Future<void> getNotifications() async {
    try {
      final GetNotificationsResponse notifResponse =
          await actionClient.getNotifications(
        GetNotificationsRequest(),
        options: sessionOptions(getIt()),
      );

      emit(GetNotifSuccess(notifResponse));
    } catch (e) {
      emit(GetNotifFailure(e.toString()));
      logger.i('unsuccessful');
    }
  }

  Future<void> getMoreNotifications() async {
    try {
      final GetNotificationsResponse notifResponse =
          await actionClient.getNotifications(
        GetNotificationsRequest(lastNotificationId: state.lastnotificationid),
        options: sessionOptions(getIt()),
      );

      emit(GetNotifSuccess(notifResponse));
    } catch (e) {
      emit(GetNotifFailure(e.toString()));
      logger.i('unsuccessful');
    }
  }

  @override
  void onChange(Change<NotificationsCubitState> change) {
    super.onChange(change);
    if (state is GetNotifSuccess) {
      logger.i('successful');
    } else if (state is GetNotifFailure) {
      logger.i('unsuccessful');
    }
  }
}
