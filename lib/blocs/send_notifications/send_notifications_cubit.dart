import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/SendNotifications.pb.dart';
import 'package:equatable/equatable.dart';

import '../../main.dart';

part 'send_notifications_state.dart';

class SendNotificationsCubit extends Cubit<SendNotificationsState> {
  SendNotificationsCubit() : super(SendNotificationsInitial());

  Future<void> sendNotifs(
    final userID,
    final String text,
    final bool isGlobal,
  ) async {
    emit(const SendNotificationsLoading());
    try {
      final resp = await actionClient.sendNotifications(
          SendNotificationsRequest(
              userId: userID, text: text, isGlobal: isGlobal));
      if (resp.statusCode == SendNotificationsResponse_StatusCode.OK) {
        emit(SendNotificationsSuccess(userID, text, isGlobal));
      } else {
        emit(SendNotificationsFailure(resp.statusMessage));
        emit(SendNotificationsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SendNotificationsFailure(failedToReachServer));
    }
  }
}
