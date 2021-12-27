import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'stockbar_state.dart';

class StockbarCubit extends Cubit<StockbarState> {
  StockbarCubit() : super(StockbarInitial());

  void listentoStockPrice() async {
    try {
      final stockPriceStream = getIt<GlobalStreams>().stockPricesStream;

      await for (var update in stockPriceStream) {
        emit(StockPriceUpdate(update.prices));
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
