import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'subscribe_state.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit() : super(SubscribeInitial());

// Bloc which will subscribe to given DataStream and emit subscription ID
  Future<void> subscribe(DataStreamType dataStreamType) async {
    try {
      final subscribeResponse = await streamClient.subscribe(
          SubscribeRequest(dataStreamType: dataStreamType),
          options: sessionOptions(getIt<String>()));

      if (subscribeResponse.statusCode == SubscribeResponse_StatusCode.OK) {
        emit(SubscriptionDataLoaded(subscribeResponse.subscriptionId));
      } else if (subscribeResponse.statusCode ==
          SubscribeResponse_StatusCode.InvalidDataStreamId) {
        emit(SubscriptonDataFailed(subscribeResponse.statusMessage));
      } else if (subscribeResponse.statusCode ==
          SubscribeResponse_StatusCode.InternalServerError) {
        emit(SubscriptonDataFailed(subscribeResponse.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SubscriptonDataFailed(
          'Failed to reach server. Try again later'));
    }
  }

// Bloc which will unsubscribe to given SubscriptionID
  Future<void> unsubscribe(SubscriptionId subscriptionId) async {
    try {
      final unSubscribeResponse = await streamClient.unsubscribe(
          UnsubscribeRequest(subscriptionId: subscriptionId),
          options: sessionOptions(getIt<String>()));
      if (unSubscribeResponse.statusCode != UnsubscribeResponse_StatusCode.OK) {
        logger.e('Failed to unsubscribe');
      }
    } catch (e) {
      logger.e(e);
    }
  }
}
