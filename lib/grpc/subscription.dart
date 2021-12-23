import 'package:dalal_street_client/constants/exception.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';

import '../main.dart';

/// Subscription is used to handle subscribing and unsubscribing
/// of grpc server server side streaming
///
/// [SubscriptionId] is used for unsubcribing and calling respected stream rpc
///
///  Flow
///  - subscribe to a stream, return [SubscriptionId]
///  - call the valid server side streaming rpc
///  - unsubcribe to that stream, with [SubscriptionId]
///
/// creating instance of [Subscription] with bloc(stream) is encouraged
class Subscription {
  SubscriptionId? _subscriptionId;

  Future<SubscriptionId> subscribe(SubscribeRequest subscribeRequest) async {
    try {
      final subscribeResponse = await streamClient.subscribe(subscribeRequest,
          options: sessionOptions(getIt<String>()));

      if (subscribeResponse.statusCode ==
          SubscribeResponse_StatusCode.InvalidDataStreamId) {
        throw invalidDataStreamIdError;
      }

      if (subscribeResponse.statusCode ==
          SubscribeResponse_StatusCode.InternalServerError) {
        throw internalServerError;
      }

      logger.d('[${_subscriptionId?.dataStreamType}]: subscribe successful');

      _subscriptionId = subscribeResponse.subscriptionId;

      return _subscriptionId!;
    } catch (e) {
      logger.e(e);
      throw failedToReachServerError;
    }
  }

  Future<void> unSubscribe() async {
    try {
      final unsubscribeResponse = await streamClient.unsubscribe(
          UnsubscribeRequest(subscriptionId: _subscriptionId),
          options: sessionOptions(getIt<String>()));

      if (unsubscribeResponse.statusCode ==
          UnsubscribeResponse_StatusCode.InvalidDataStreamId) {
        throw invalidDataStreamIdError;
      }

      if (unsubscribeResponse.statusCode ==
          UnsubscribeResponse_StatusCode.InternalServerError) {
        throw internalServerError;
      }

      logger.d('[${_subscriptionId?.dataStreamType}]: unsubscribe successful');
    } catch (e) {
      logger.e(e);
      throw failedToReachServerError;
    }
  }
}
