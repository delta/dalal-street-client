import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stock_history_stream_state.dart';

class StockHistoryStreamCubit extends Cubit<StockHistoryStreamState> {
  StockHistoryStreamCubit() : super(StockHistoryStreamInitial());
}
