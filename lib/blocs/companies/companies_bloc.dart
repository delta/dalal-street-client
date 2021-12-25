import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetCompanyProfile.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:equatable/equatable.dart';

import '../../main.dart';

part 'companies_event.dart';
part 'companies_state.dart';

/// Bloc which manages states of all the company specific rpc calls
class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesBloc() : super(CompaniesInitial()) {
    on<GetStockList>((event, emit) async {
      try {
        final stockList = await actionClient.getStockList(
          GetStockListRequest(),
          options: sessionOptions(getIt()),
        );
        emit(GetCompaniesSuccess(stockList));
      } catch (e) {
        logger.e(e);
        emit(GetCompaniesFailed(e.toString()));
      }
    });
    on<GetStockById>((event, emit) async {
      try {
        final company = await actionClient.getCompanyProfile(
          GetCompanyProfileRequest(stockId: event.stockId),
          options: sessionOptions(getIt()),
        );
        emit(GetCompanyByIdSuccess(company));
      } catch (e) {
        logger.e(e);
        emit(GetCompanyByIdFailed(e.toString()));
      }
    });
  }
}
