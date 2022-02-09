import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/RetrieveMortgageStocks.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'retrieve_sheet_state.dart';

class RetrieveSheetCubit extends Cubit<RetrieveSheetState> {
  RetrieveSheetCubit() : super(RetrieveSheetInitial());

  Future<void> retrieveStocks(
      int stockId, int stockQuantity, int mortgagePrice) async {
    try {
      final resp = await actionClient.retrieveMortgageStocks(
          RetrieveMortgageStocksRequest(
              stockId: stockId,
              stockQuantity: Int64(stockQuantity),
              retrievePrice: Int64(mortgagePrice)),
          options: sessionOptions(getIt<String>()));
      if (resp.statusCode == RetrieveMortgageStocksResponse_StatusCode.OK) {
        emit(const RetrieveSheetSuccess());
      } else {
        logger.e(resp.statusMessage);
        emit(RetrieveSheetFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const RetrieveSheetFailure(failedToReachServer));
    }
  }
}
