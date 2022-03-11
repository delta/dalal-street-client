import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:fixnum/fixnum.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/PlaceOrder.pb.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  PlaceOrderCubit() : super(PlaceOrderInitial());

  Future<void> placeOrder(bool isAsk, int stockId, OrderType orderType,
      Int64 price, Int64 stockQuantity) async {
    emit(const PlaceOrderLoading());
    try {
      final resp = await actionClient.placeOrder(
        PlaceOrderRequest(
            isAsk: isAsk,
            stockId: stockId,
            orderType: orderType,
            price: price,
            stockQuantity: stockQuantity),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == PlaceOrderResponse_StatusCode.OK) {
        emit(PlaceOrderSuccess(resp.orderId));
      } else {
        emit(PlaceOrderFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const PlaceOrderFailure(failedToReachServer));
    }
  }
}
