import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/CloseMarket.pb.dart';
import 'package:equatable/equatable.dart';

part 'close_market_state.dart';

class CloseMarketCubit extends Cubit<CloseMarketState> {
  CloseMarketCubit() : super(CloseMarketInitial());

  Future<void> closeMarket(
    final bool updatePrevDayClose,
  ) async {
    emit(const CloseMarketLoading());
    try {
      final resp = await actionClient.closeMarket(
          CloseMarketRequest(updatePrevDayClose: updatePrevDayClose));
      if (resp.statusCode == CloseMarketResponse_StatusCode.OK) {
        emit(CloseMarketSuccess(updatePrevDayClose));
      } else {
        emit(CloseMarketFailure(resp.statusMessage));
        emit(CloseMarketInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const CloseMarketFailure(failedToReachServer));
    }
  }
}
