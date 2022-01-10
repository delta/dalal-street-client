part of 'portfolio_transactions_cubit.dart';

@immutable
abstract class PortfolioTransactionsState extends Equatable {
  const PortfolioTransactionsState();

  @override
  List<Object> get props => [];
}

class PortfolioTransactionsLoaded extends PortfolioTransactionsState {
  final List transactions;

  PortfolioTransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class PortfolioTransactionsLoading extends PortfolioTransactionsState {
  const PortfolioTransactionsLoading();
}

class PortfolioTransactionsError extends PortfolioTransactionsState {
  final String message;

  const PortfolioTransactionsError(this.message);

  @override
  List<Object> get props => [message];
}
