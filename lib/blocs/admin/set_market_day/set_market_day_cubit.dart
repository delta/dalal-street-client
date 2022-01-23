import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SetMarketDay.pb.dart';
import 'package:equatable/equatable.dart';

part 'set_market_day_state.dart';

class SetMarketDayCubit extends Cubit<SetMarketDayState> {
  SetMarketDayCubit() : super(SetMarketDayInitial());

  Future<void> setMarketDay(final marketDay) async {
    emit(const SetMarketDayLoading());
    try {
      final resp = await actionClient.setMarketDay(
          SetMarketDayRequest(marketDay: marketDay),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetMarketDayResponse_StatusCode.OK) {
        emit(SetMarketDaySuccess(resp.statusMessage));
      } else {
        emit(SetMarketDayFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetMarketDayFailure(failedToReachServer));
    }
  }
}
