part of 'companies_bloc.dart';

/// Base class for all [CompaniesEvent]s which are handled by the [CompaniesBloc].
abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object> get props => [];
}

class GetStockById extends CompaniesEvent {
  final int stockId;
  const GetStockById(this.stockId);

  @override
  List<Object> get props => [stockId];
}
