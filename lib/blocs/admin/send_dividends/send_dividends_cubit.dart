import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SendDividends.pb.dart';

part 'send_dividends_state.dart';

class SendDividendsCubit extends Cubit<SendDividendsState> {
  SendDividendsCubit() : super(SendDividendsInitial());

  Future<void> sendDividends(final stockId, final dividendAmount) async {
    emit(const SendDividendsLoading());
    try {
      final resp = await actionClient.sendDividends(
          SendDividendsRequest(
              stockId: stockId, dividendAmount: dividendAmount),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SendDividendsResponse_StatusCode.OK) {
        emit(SendDividendsSuccess(stockId, dividendAmount));
      } else {
        emit(SendDividendsFailure(resp.statusMessage));
        emit(SendDividendsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SendDividendsFailure(failedToReachServer));
    }
  }
}
