import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetNotifications.pb.dart';
import 'package:equatable/equatable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotifState> {
  NotificationsBloc() : super(NotifInitial()) {
    on<GetNotifications>((event, emit) async {
      try {
        final GetNotificationsResponse notifResponse =
            await actionClient.getNotifications(
          GetNotificationsRequest(),
          options: sessionOptions(getIt()),
        );

        emit(GetNotifSuccess(notifResponse));
      } catch (e) {
        emit(GetNotifFailure(e.toString()));
      }
    });

    on<GetMoreNotifications>((event, emit) async {
      try {
        final GetNotificationsResponse notifResponse =
            await actionClient.getNotifications(
          GetNotificationsRequest(lastNotificationId: event.lastnotificationid),
          options: sessionOptions(getIt()),
        );

        emit(GetNotifSuccess(notifResponse));
      } catch (e) {
        emit(GetNotifFailure(e.toString()));
      }
    });
  }
}
