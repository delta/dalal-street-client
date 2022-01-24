import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/SetBankruptcy.pb.dart';
import 'package:equatable/equatable.dart';

part 'set_bankruptcy_state.dart';

class SetBankruptcyCubit extends Cubit<SetBankruptcyState> {
  SetBankruptcyCubit() : super(SetBankruptcyInitial());

  Future<void> setBankruptcy(final stockID, final isBankrupt) async {
    emit(const SetBankruptcyLoading());
    try {
      final resp = await actionClient.setBankruptcy(
          SetBankruptcyRequest(stockId: stockID, isBankrupt: isBankrupt),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetBankruptcyResponse_StatusCode.OK) {
        emit(SetBankruptcySuccess(resp.statusMessage));
      } else {
        emit(SetBankruptcyFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetBankruptcyFailure(failedToReachServer));
    }
  }
}
