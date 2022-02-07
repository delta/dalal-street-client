import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:flutter/foundation.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:dalal_street_client/proto_build/actions/GetPortfolio.pb.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/constants/error_messages.dart';

part 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(const PortfolioLoading());

  Future<void> getPortfolio() async {
    try {
      final res = await actionClient.getPortfolio(GetPortfolioRequest(),
          options: sessionOptions(getIt()));
      if (res.statusCode == GetPortfolioResponse_StatusCode.OK) {
        emit(UserWorthLoaded(
            res.user, res.stocksOwned, res.reservedStocksOwned, res.cashSpent));
      } else {
        emit(UserWorthFailure(res.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UserWorthFailure(failedToReachServer));
    }
  }
}
