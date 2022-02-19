import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetNotifications.pb.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsCubitState> {
  NotificationsCubit() : super(NotificationsCubitInitial());

  var lastNotificationId = 0;
  var moreExist = true;

  Future<void> getNotifications() async {
    try {
      logger.d('requested  $lastNotificationId');

      if (lastNotificationId == 0) {
        emit(NotificationsCubitInitial());
      }

      final GetNotificationsResponse response =
          await actionClient.getNotifications(
        GetNotificationsRequest(lastNotificationId: lastNotificationId),
        options: sessionOptions(getIt()),
      );

      if (response.statusCode == GetNotificationsResponse_StatusCode.OK) {
        if (!response.moreExists) {
          moreExist = false;
        }

        if (response.notifications.isNotEmpty) {
          lastNotificationId =
              response.notifications[response.notifications.length - 1].id;
        }

        emit(GetNotificationSuccess(response.notifications));
      } else {
        emit(GetNotificationFailure(response.statusMessage));
      }
    } catch (e) {
      emit(const GetNotificationFailure(failedToReachServer));
    }
  }
}
