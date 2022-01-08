import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/OpenMarket.pb.dart';
import 'package:equatable/equatable.dart';

part 'open_market_state.dart';

class OpenMarketCubit extends Cubit<OpenMarketState> {
  OpenMarketCubit() : super(OpenMarketInitial());

  Future<void> openMarket(final bool dayHighAndLow) async {
    emit(const OpenMarketLoading());
    try {
      final resp = await actionClient
          .openMarket(OpenMarketRequest(updateDayHighAndLow: dayHighAndLow));
      if (resp.statusCode == OpenMarketResponse_StatusCode.OK) {
        emit(OpenMarketSuccess(dayHighAndLow));
      } else {
        emit(OpenMarketFailure(resp.statusMessage));
        emit(OpenMarketInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const OpenMarketFailure(failedToReachServer));
    }
  }
}
