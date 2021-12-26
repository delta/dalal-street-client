import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/exception.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';

///  grpc server server side streaming
///
///  Flow
///  - subscribe to a stream,that'll return [SubscriptionId] as response
///  - call the valid server side streaming rpc
///  - unsubcribe to that stream, with [SubscriptionId]
///
/// [SubscriptionId] is used for unsubcribing and calling respected stream rpc

Future<SubscriptionId> subscribe(
    SubscribeRequest subscribeRequest, String sessionId) async {
  late final SubscribeResponse subscribeResponse;

  subscribeResponse = await streamClient.subscribe(subscribeRequest,
      options: sessionOptions(sessionId));

  if (subscribeResponse.statusCode ==
      SubscribeResponse_StatusCode.InvalidDataStreamId) {
    throw invalidDataStreamIdException;
  }

  if (subscribeResponse.statusCode ==
      SubscribeResponse_StatusCode.InternalServerError) {
    throw internalServerException;
  }

  logger.d(
      '[${subscribeResponse.subscriptionId.dataStreamType}]: subscribe successful');

  return subscribeResponse.subscriptionId;
}

Future<void> unSubscribe(
    SubscriptionId subscriptionId, String sessionId) async {
  late final UnsubscribeResponse unsubscribeResponse;

  unsubscribeResponse = await streamClient.unsubscribe(
      UnsubscribeRequest(subscriptionId: subscriptionId),
      options: sessionOptions(sessionId));

  if (unsubscribeResponse.statusCode ==
      UnsubscribeResponse_StatusCode.InvalidDataStreamId) {
    throw invalidDataStreamIdException;
  }

  if (unsubscribeResponse.statusCode ==
      UnsubscribeResponse_StatusCode.InternalServerError) {
    throw internalServerException;
  }

  logger.d('[${subscriptionId.dataStreamType}]: unsubscribe successful');
}
