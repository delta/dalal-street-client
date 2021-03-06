import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/MortgageStocks.pb.dart';
import 'package:dalal_street_client/proto_build/actions/RetrieveMortgageStocks.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'mortgage_sheet_state.dart';

class MortgageSheetCubit extends Cubit<MortgageSheetState> {
  MortgageSheetCubit() : super(MortgageSheetInitial());

  Future<void> mortgageStocks(int stockId, int stockQuantity) async {
    try {
      final resp = await actionClient.mortgageStocks(
          MortgageStocksRequest(
            stockId: stockId,
            stockQuantity: Int64(stockQuantity),
          ),
          options: sessionOptions(getIt<String>()));
      if (resp.statusCode == MortgageStocksResponse_StatusCode.OK) {
        emit(MortgageSheetSuccess(stockId, stockQuantity));
      } else {
        logger.e(resp.statusMessage);
        emit(MortgageSheetFailure(resp.statusMessage));
      }
      emit(MortgageSheetInitial());
    } catch (e) {
      logger.e(e);
      emit(const MortgageSheetFailure(failedToReachServer));
    }
  }

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
        emit(MortgageSheetSuccess(stockId, stockQuantity));
      } else {
        logger.e(resp.statusMessage);
        emit(MortgageSheetFailure(resp.statusMessage));
      }
      emit(MortgageSheetInitial());
    } catch (e) {
      logger.e(e);
      emit(const MortgageSheetFailure(failedToReachServer));
    }
  }
}
