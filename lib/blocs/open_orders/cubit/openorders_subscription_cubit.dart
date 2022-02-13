import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/MyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'openorders_subscription_state.dart';

class OpenordersSubscriptionCubit extends Cubit<OpenordersSubscriptionState> {
  OpenordersSubscriptionCubit() : super(OpenordersSubscriptionInitial());

  Future<void> getOpenOrdersStream(SubscriptionId subscriptionId) async {
    try 
    {
      final orderupdatestream = streamClient.getMyOrderUpdates(subscriptionId,
          options: sessionOptions(getIt()));
      await for (final orderupdate in orderupdatestream) {
        emit(SubscriptionToOpenOrderSuccess(orderupdate));
      }
    } catch (e) {
      logger.e(e);
      emit(SubscriptionToOpenOrderFailed(subscriptionId));
    }
  }
}
