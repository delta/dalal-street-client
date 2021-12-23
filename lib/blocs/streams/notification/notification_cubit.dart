import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Notification.pb.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationStreamCubit extends Cubit<NotificationStreamState> {
  late final Subscription subscription;
  NotificationStreamCubit() : super(NotificationStreamLoading()) {
    subscription = Subscription();
  }
  // subscribe to notification stream and listen for updates
  Future<void> start() async {
    try {
      // subscribing to notification stream
      final subscriptionId = await subscription.subscribe(
          SubscribeRequest(dataStreamType: DataStreamType.NOTIFICATIONS));

      final notificationStream = streamClient.getNotificationUpdates(
          subscriptionId,
          options: sessionOptions(getIt<String>()));

      // emitting success state after subscription
      emit(NotificationStreamSuccess());

      await for (final notification in notificationStream) {
        // emitting on each notification updates
        emit(NotificationStreamUpdate(notification.notification));
      }
    } catch (e) {
      logger.e(e);
      emit(NotificationStreamError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // unsubscribing to notification stream
    subscription.unSubscribe();
    return super.close();
  }
}
