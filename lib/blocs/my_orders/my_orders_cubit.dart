import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/grpc/subscription.dart';
import 'package:dalal_street_client/proto_build/actions/CancelOrder.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/Ask.pb.dart';
import 'package:dalal_street_client/proto_build/models/Bid.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  MyOrdersCubit() : super(OpenOrdersInitial());
  // this will store subcribtionId of openOrdersUpdate stream
  // will be used to unsubscribe to this stream on dispose of open order widget
  late SubscriptionId subscribtionId;

  Future<void> getMyOpenOrders() async {
    // these two maps contains all the open ask and bid
    // orders of the loggedIn user
    Map<int, Ask> openAskMap = {};
    Map<int, Bid> openBidMap = {};

    try {
      emit(OpenOrdersInitial());
      // initial fetch of all the open orders
      final response = await actionClient.getMyOpenOrders(
          GetMyOpenOrdersRequest(),
          options: sessionOptions(getIt()));

      if (response.statusCode == GetMyOpenOrdersResponse_StatusCode.OK) {
        for (var ask in response.openAskOrders) {
          openAskMap[ask.id] = ask;
        }

        for (var bid in response.openBidOrders) {
          openBidMap[bid.id] = bid;
        }

        logger.d('fetched open orders details');

        // emit initial fetch data
        emit(OpenOrdersSuccess(
            openAskMap.values.toList(), openBidMap.values.toList()));

        // listening to open orders stream to update the orders
        SubscribeRequest subscribeRequest =
            SubscribeRequest(dataStreamType: DataStreamType.MY_ORDERS);

        subscribtionId = await subscribe(subscribeRequest, getIt<String>());

        final myOrdersUpdateStream = streamClient.getMyOrderUpdates(
            subscribtionId,
            options: sessionOptions(getIt()));

        await for (final update in myOrdersUpdateStream) {
          logger.d(update);
          // based on each stream update, have to
          // update, delete,add openOrders Maps i.e [openAskMap] [openBidMap]

          if (update.isNewOrder) {
            // new order directly add to the map based on the order type

            if (update.isAsk) {
              // ask order
              Ask newAsk = Ask();

              newAsk.id = update.id;
              newAsk.stockId = update.stockId;
              newAsk.stockQuantity = update.stockQuantity;
              newAsk.orderType = update.orderType;
              newAsk.price = update.orderPrice;
              newAsk.stockQuantityFulfilled = Int64.ZERO;
              newAsk.createdAt = DateTime.now().toUtc().toString();

              openAskMap[newAsk.id] = newAsk;
            } else {
              // bid order
              Bid newBid = Bid();
              newBid.id = update.id;
              newBid.stockId = update.stockId;
              newBid.stockQuantity = update.stockQuantity;
              newBid.orderType = update.orderType;
              newBid.price = update.orderPrice;
              newBid.stockQuantityFulfilled = Int64.ZERO;
              newBid.createdAt = DateTime.now().toUtc().toString();

              openBidMap[newBid.id] = newBid;
            }
          } else {
            // not a new order (update or delete from the map)

            if (update.isAsk) {
              if (update.isClosed) {
                //order is closed
                openAskMap.remove(update.id);
              } else {
                // updating stock quantity
                openAskMap[update.id]?.stockQuantityFulfilled +=
                    update.tradeQuantity;
              }
            } else {
              if (update.isClosed) {
                // order is closed
                openBidMap.remove(update.id);
              } else {
                // updating the stock quantity
                openBidMap[update.id]?.stockQuantityFulfilled +=
                    update.tradeQuantity;
              }
            }
          }
          // emit state on each stream update
          emit(OpenOrdersSuccess(
              openAskMap.values.toList(), openBidMap.values.toList()));
        }
      } else {
        emit(OpenOrdersFailure(response.statusMessage));
      }
    } catch (e) {
      emit(const OpenOrdersFailure(failedToReachServer));
    }
  }

  Future<void> cancelMyOrder(bool isAsk, int orderId) async {
    try {
      final response = await actionClient
          .cancelOrder(CancelOrderRequest(orderId: orderId, isAsk: isAsk));

      if (response.statusCode != CancelOrderResponse_StatusCode.OK) {
        emit(CancelOrderFailure(response.statusMessage)); // emit error state
      }

      // if the cancel order is successful, we'll get a update in my order update stream
    } catch (e) {
      emit(const CancelOrderFailure(failedToReachServer));
    }
  }

  // unsubscribe to the stream, must be called at disposing
  // error handling is not needed though
  void unsubscribe() {
    unSubscribe(subscribtionId, getIt<String>());
  }
}
