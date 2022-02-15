import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetNotifications.pb.dart';
import 'package:equatable/equatable.dart';

import '../../config/log.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsCubitState> {
  NotificationsCubit() : super(NotificationsCubitInitial());

  Future<void> getNotifications(int lastnotificationId) async {
    try {
      final GetNotificationsResponse notifResponse =
          await actionClient.getNotifications(
        GetNotificationsRequest(lastNotificationId: lastnotificationId),
        options: sessionOptions(getIt()),
      );
      if (notifResponse.statusCode == GetNotificationsResponse_StatusCode.OK) {
        emit(GetNotifSuccess(notifResponse));
      } else {
        emit(GetNotifFailure(notifResponse.statusMessage));
      }
    } catch (e) {
      emit(const GetNotifFailure(failedToReachServer));
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
      emit(const GetNotifFailure(failedToReachServer));
      logger.i('unsuccessful');
    }
  }
}
