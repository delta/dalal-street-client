part of 'companies_bloc.dart';

/// Base class for all the states of the [CompaniesBloc].
abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object> get props => [];
}

class CompaniesInitial extends CompaniesState {}

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

class GetCompanyByIdSuccess extends CompaniesState {
  final GetCompanyProfileResponse company;
  const GetCompanyByIdSuccess(this.company);

  @override
  List<Object> get props => [company];
}

class GetCompanyByIdFailed extends CompaniesState {
  final String error;
  const GetCompanyByIdFailed(this.error);

  @override
  List<Object> get props => [error];
}
