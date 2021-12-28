import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:dalal_street_client/proto_build/actions/BuyStocksFromExchange.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockExchange.pb.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/utils/convert.dart';
import 'package:equatable/equatable.dart';

part 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  ExchangeCubit() : super(const ExchangeLoading());

  Future<void> listenToExchangeStream(Map<int, Stock> mapOfStocks) async {
    // Load initial state
    emit(ExchangeDataLoaded(mapOfStocks
        .map((key, value) => MapEntry(key, stockDataToExchangeData(value)))));
    final exchangeStream = getIt<GlobalStreams>().stockExchangeStream;
    await for (var item in exchangeStream) {
      final exchangeData = item.stocksInExchange;
      logger.d(exchangeData);
      // Load new updates
      emit(ExchangeDataLoaded(exchangeData));
    }
  }
}
