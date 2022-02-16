import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/CancelOrder.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pb.dart';
import 'package:equatable/equatable.dart';
part 'open_orders_state.dart';

class OpenOrdersCubit extends Cubit<OpenOrdersState> {
  OpenOrdersCubit() : super(OpenOrdersInitial());
  Future<void> getOpenOrders() async {
    try {
      final resp = await actionClient.getMyOpenOrders(GetMyOpenOrdersRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == GetMyOpenOrdersResponse_StatusCode.OK) {
        emit(GetOpenordersSuccess(resp));
      } else {
        emit(OrderFailure(resp.statusMessage, OpenOrderType.open));
      }
    } catch (e) {
      logger.e(e);
      emit(const OrderFailure(failedToReachServer, OpenOrderType.open));
    }
  }

  Future<void> cancelOpenOrders(int orderId, bool isAsk) async {
    try {
      final resp = await actionClient.cancelOrder(
          CancelOrderRequest(orderId: orderId, isAsk: isAsk),
          options: sessionOptions(getIt()));
      if (resp.statusCode == CancelOrderResponse_StatusCode.OK) {
        emit(const CancelorderSuccess());
      } else {
        emit(OrderFailure(resp.statusMessage, OpenOrderType.cancel));
      }
    } catch (e) {
      logger.e(e);
      emit(const OrderFailure(failedToReachServer, OpenOrderType.cancel));
    }
  }
}
