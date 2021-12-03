part of 'companies_bloc.dart';

/// Base class for all the states of the [CompaniesBloc].
abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object> get props => [];
}

class CompaniesInitial extends CompaniesState {}

class SubscriptionToStockPricesSuccess extends CompaniesState {
  final stockPrices;
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
