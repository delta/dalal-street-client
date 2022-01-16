import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/SetBankruptcy.pb.dart';
import 'package:equatable/equatable.dart';

part 'set_bankruptcy_state.dart';

class SetBankruptcyCubit extends Cubit<SetBankruptcyState> {
  SetBankruptcyCubit() : super(SetBankruptcyInitial());

  Future<void> setBankruptcy(final stockID, final isBankrupt) async {
    emit(const SetBankruptcyLoading());
    try {
      final resp = await actionClient.setBankruptcy(
          SetBankruptcyRequest(stockId: stockID, isBankrupt: isBankrupt));
      if (resp.statusCode == SetBankruptcyResponse_StatusCode.OK) {
        emit(SetBankruptcySuccess(stockID, isBankrupt));
      } else {
        emit(SetBankruptcyFailure(resp.statusMessage));
        emit(SetBankruptcyInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SetBankruptcyFailure(failedToReachServer));
    }
  }
}
