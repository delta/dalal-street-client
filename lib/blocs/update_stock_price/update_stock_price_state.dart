part of 'update_stock_price_cubit.dart';

abstract class UpdateStockPriceState extends Equatable {
  const UpdateStockPriceState();

  @override
  List<Object> get props => [];
}

class UpdateStockPriceInitial extends UpdateStockPriceState {}

class UpdateStockPriceLoading extends UpdateStockPriceState {
  const UpdateStockPriceLoading();
}

class UpdateStockPriceFailure extends UpdateStockPriceState {
  final String msg;

  const UpdateStockPriceFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UpdateStockPriceSuccess extends UpdateStockPriceState {
  final stockID;
  final new_price;

  const UpdateStockPriceSuccess(this.stockID, this.new_price);
}
