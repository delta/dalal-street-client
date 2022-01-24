import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
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
              stockId: stockId, givesDividends: givesDividends),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetGivesDividendsResponse_StatusCode.OK) {
        emit(SetGivesDividendsSuccess(resp.statusMessage));
      } else {
        emit(SetGivesDividendsFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetGivesDividendsFailure(failedToReachServer));
    }
  }
}
