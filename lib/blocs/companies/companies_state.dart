part of 'companies_bloc.dart';

/// Base class for all the states of the [CompaniesBloc].
abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object> get props => [];
}

class CompaniesInitial extends CompaniesState {}

class SubscriptionToStockPricesSuccess extends CompaniesState {
  final StockPricesUpdate stockPrices;
  const SubscriptionToStockPricesSuccess(this.stockPrices);

  @override
  List<Object> get props => [stockPrices];
}

class SubscriptionToStockPricesFailed extends CompaniesState {
  final String subscriptionId;
  const SubscriptionToStockPricesFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}

class GetCompaniesSuccess extends CompaniesState {
  final GetStockListResponse stockList;
  const GetCompaniesSuccess(this.stockList);

  @override
  List<Object> get props => [stockList];
}

class GetCompaniesFailed extends CompaniesState {
  final String error;
  const GetCompaniesFailed(this.error);

  @override
  List<Object> get props => [error];
}

class SubscriptionToStockExchangeSuccess extends CompaniesState {
  final StockExchangeUpdate stockExchangeUpdate;
  const SubscriptionToStockExchangeSuccess(this.stockExchangeUpdate);

  @override
  List<Object> get props => [stockExchangeUpdate];
}

class SubscriptionToStockExchangeFailed extends CompaniesState {
  final String subscriptionId;
  const SubscriptionToStockExchangeFailed(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
