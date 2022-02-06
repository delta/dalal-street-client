import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetNotifications.pb.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  Future<void> getNotifications(int lastnotificationId, int count) async {
    emit(const NotificationsLoading());
    try {
      final resp = await actionClient.getNotifications(
          GetNotificationsRequest(
              lastNotificationId: lastnotificationId, count: count),
          options: sessionOptions(getIt()));
      if (resp.statusCode == GetNotificationsResponse_StatusCode.OK) {
        emit(NotificationsSuccess(resp.statusMessage));
      } else {
        emit(NotificationsFailure(resp.statusMessage));
        emit(NotificationsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const NotificationsFailure(failedToReachServer));
    }
  }
}
