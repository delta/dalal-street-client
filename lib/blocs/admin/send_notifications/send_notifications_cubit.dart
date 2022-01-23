import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SendNotifications.pb.dart';
import 'package:equatable/equatable.dart';

part 'send_notifications_state.dart';

class SendNotificationsCubit extends Cubit<SendNotificationsState> {
  SendNotificationsCubit() : super(SendNotificationsInitial());

  Future<void> sendNotifications(
    final userID,
    final String text,
    final bool isGlobal,
  ) async {
    emit(const SendNotificationsLoading());
    try {
      final resp = await actionClient.sendNotifications(
          SendNotificationsRequest(
              userId: userID, text: text, isGlobal: isGlobal),
          options: sessionOptions(getIt()));

      if (resp.statusCode == SendNotificationsResponse_StatusCode.OK) {
        emit(SendNotificationsSuccess(resp.statusMessage));
      } else {
        emit(SendNotificationsFailure(resp.statusMessage));
        emit(SendNotificationsInitial());
      }
    } catch (e) {
      emit(const SendNotificationsFailure(failedToReachServer));
    }
  }

  void add(SendNotificationsCubit sendNotificationsCubit) {}
}
