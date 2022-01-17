import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetCompanyProfile.pb.dart';
import 'package:equatable/equatable.dart';

part 'companies_event.dart';
part 'companies_state.dart';

/// Bloc which manages states of all the company specific rpc calls
class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesBloc() : super(CompaniesInitial()) {
    on<GetStockById>((event, emit) async {
      try {
        final stockpricesStream =
            streamClient.getStockPricesUpdates(event.subscriptionId);
        await for (final stockPrices in stockpricesStream) {
          emit(SubscriptionToStockPricesSuccess(stockPrices));
        }
      } catch (e) {
        logger.e(e);
        emit(SubscriptionToStockPricesFailed(e.toString()));
      }
    });

    on<GetStockList>((event, emit) async {
      try {
        final stockList = await actionClient.getStockList(
          GetStockListRequest(),
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
