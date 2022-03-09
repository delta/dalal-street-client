import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
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
      if (lastNotificationId == 0) {
        emit(NotificationsCubitInitial());
      }

      if (!moreExist) {
        return;
      }

      final GetNotificationsResponse response =
          await actionClient.getNotifications(
        GetNotificationsRequest(
            lastNotificationId:
                lastNotificationId == 0 ? 0 : lastNotificationId - 1),
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
        lastNotificationId = 0;
        moreExist = true;
        emit(GetNotificationFailure(response.statusMessage));
      }
    } catch (e) {
      lastNotificationId = 0;
      moreExist = true;
      emit(const GetNotificationFailure(failedToReachServer));
    }
  }
}
