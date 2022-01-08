part of 'add_market_event_cubit.dart';

abstract class AddMarketEventState extends Equatable {
  const AddMarketEventState();

  @override
  List<Object> get props => [];
}

class AddMarketEventInitial extends AddMarketEventState {}

class AddMarketEventLoading extends AddMarketEventState {
  const AddMarketEventLoading();
}

class AddMarketEventFailure extends AddMarketEventState {
  final String msg;

  const AddMarketEventFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddMarketEventSuccess extends AddMarketEventState {
  final int stockID;
  final String headline;
  final String text;
  final String imageURL;
  final bool is_global;

  const AddMarketEventSuccess(
      this.stockID, this.headline, this.text, this.imageURL, this.is_global);
}
