import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SetMarketDay.pb.dart';
import 'package:equatable/equatable.dart';

part 'set_market_day_state.dart';

class SetMarketDayCubit extends Cubit<SetMarketDayState> {
  SetMarketDayCubit() : super(SetMarketDayInitial());

  Future<void> setMarketDay(final market_day) async {
    emit(const SetMarketDayLoading());
    try {
      final resp = await actionClient
          .setMarketDay(SetMarketDayRequest(marketDay: market_day));
      if (resp.statusCode == SetMarketDayResponse_StatusCode.OK) {
        emit(SetMarketDaySuccess(market_day));
      } else {
        emit(SetMarketDayFailure(resp.statusMessage));
        emit(SetMarketDayInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SetMarketDayFailure(failedToReachServer));
    }
  }
}
