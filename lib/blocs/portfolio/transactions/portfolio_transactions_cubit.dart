import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dalal_street_client/proto_build/actions/GetTransactions.pb.dart';
import 'package:dalal_street_client/constants/error_messages.dart';

part 'portfolio_transactions_state.dart';

class PortfolioTransactionsCubit extends Cubit<PortfolioTransactionsState> {
  PortfolioTransactionsCubit() : super(const PortfolioTransactionsLoading());

  Future<void> listenToTransactionStream() async {
    try {
      final res = await actionClient.getTransactions(GetTransactionsRequest(),
          options: sessionOptions(getIt()));

      if (res.statusCode == GetTransactionsResponse_StatusCode.OK) {
        emit(PortfolioTransactionsLoaded(res.transactions));
      } else {
        emit(PortfolioTransactionsError(res.statusMessage));
      }
    } catch (e) {
      emit(const PortfolioTransactionsError(failedToReachServer));
    }
  }
}
