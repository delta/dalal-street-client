import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/LoadStocks.pb.dart';
import 'package:equatable/equatable.dart';

part 'load_stocks_state.dart';

class LoadStocksCubit extends Cubit<LoadStocksState> {
  LoadStocksCubit() : super(LoadStocksInitial());

  Future<void> loadStocks() async {
    emit(const LoadStocksLoading());
    try {
      final resp = await actionClient.loadStocks(LoadStocksRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == LoadStocksResponse_StatusCode.OK) {
        emit(LoadStocksSuccess(resp.statusMessage));
      } else {
        emit(LoadStocksFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const LoadStocksFailure(failedToReachServer));
    }
  }
}
