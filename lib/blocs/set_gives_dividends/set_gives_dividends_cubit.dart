import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SetGivesDividends.pb.dart';
import 'package:equatable/equatable.dart';

part 'set_gives_dividends_state.dart';

class SetGivesDividendsCubit extends Cubit<SetGivesDividendsState> {
  SetGivesDividendsCubit() : super(SetGivesDividendsInitial());

  Future<void> setGivesDividends(
    final stockId,
    final bool givesDividends,
  ) async {
    emit(const SetGivesDividendsLoading());
    try {
      final resp = await actionClient.setGivesDividends(
          SetGivesDividendsRequest(
              stockId: stockId, givesDividends: givesDividends));
      if (resp.statusCode == SetGivesDividendsResponse_StatusCode.OK) {
        emit(SetGivesDividendsSuccess(stockId, givesDividends));
      } else {
        emit(SetGivesDividendsFailure(resp.statusMessage));
        emit(SetGivesDividendsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SetGivesDividendsFailure(failedToReachServer));
    }
  }
}
