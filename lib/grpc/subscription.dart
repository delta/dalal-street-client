import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/exception.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';

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
class Subscription {
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

      logger.d(
          '[$subscribeResponse.subscriptionId.dataStreamType}]: subscribe successful');

      return subscribeResponse.subscriptionId;
    } catch (e) {
      logger.e(e);
      throw failedToReachServerError;
    }
  }

  Future<void> unSubscribe(SubscriptionId subscriptionId) async {
    try {
      final unsubscribeResponse = await streamClient.unsubscribe(
          UnsubscribeRequest(subscriptionId: subscriptionId),
          options: sessionOptions(getIt<String>()));

      if (unsubscribeResponse.statusCode ==
          UnsubscribeResponse_StatusCode.InvalidDataStreamId) {
        throw invalidDataStreamIdError;
      }

      if (unsubscribeResponse.statusCode ==
          UnsubscribeResponse_StatusCode.InternalServerError) {
        throw internalServerError;
      }

      logger.d('[${subscriptionId.dataStreamType}]: unsubscribe successful');
    } catch (e) {
      logger.e(e);
      throw failedToReachServerError;
    }
  }
}
