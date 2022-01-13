import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/StockPrices.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';


part 'companies_event.dart';
part 'companies_state.dart';

/// Bloc which manages states of all the company specific data streams
class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesBloc() : super(CompaniesInitial()) {
    /// Subscribe to Stock Prices Data Stream
    on<SubscribeToStockPrices>((event, emit) async {
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
        emit(GetCompaniesSuccess(stockList));
      } catch (e) {
        logger.e(e);
        emit(GetCompaniesFailed(e.toString()));
      }
    });
  }
}
