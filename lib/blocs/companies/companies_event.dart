part of 'companies_bloc.dart';

/// Base class for all [CompaniesEvent]s which are handled by the [CompaniesBloc].
abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToStockPrices extends CompaniesEvent {
  final SubscriptionId subscriptionId;
  const SubscribeToStockPrices(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}

class GetStockList extends CompaniesEvent {
  const GetStockList();
}

class SubscribeToStockExchange extends CompaniesEvent {
  final SubscriptionId subscriptionId;
  const SubscribeToStockExchange(this.subscriptionId);

  @override
  List<Object> get props => [subscriptionId];
}
