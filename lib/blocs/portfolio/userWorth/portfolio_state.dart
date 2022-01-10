
part of 'portfolio_cubit.dart';

@immutable
abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object> get props => [];
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class UserWorthLoaded extends PortfolioState {
  final dynamic user;
  final dynamic stocks;
  final dynamic reservedStocks;
  const UserWorthLoaded(
    this.user,
    this.stocks,
    this.reservedStocks
  );

  @override
  List<Object> get props => [user];
}

class UserWorthFailure extends PortfolioState {
  final String message;

  const UserWorthFailure(this.message);

  @override
  List<Object> get props => [message];
}
