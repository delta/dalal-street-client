import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/LoadStocks.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SendDividends.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SendNews.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SendNotifications.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SetBankruptcy.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SetGivesDividends.pb.dart';
import 'package:dalal_street_client/proto_build/actions/SetMarketDay.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'tab1_state.dart';

class Tab1Cubit extends Cubit<Tab1State> {
  Tab1Cubit() : super(Tab1Initial());

  Future<void> sendNews(
    String news,
  ) async {
    emit(const SendNewsLoading());
    try {
      final resp = await actionClient.sendNews(
          SendNewsRequest(
            news: news,
          ),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SendNewsResponse_StatusCode.OK) {
        emit(SendNewsSuccess(resp.statusMessage));
      } else {
        emit(SendNewsFailure(resp.statusMessage));
        emit(SendNewsInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const SendNewsFailure(failedToReachServer));
    }
  }

  Future<void> sendNotifications(
    final userID,
    final String text,
    final bool isGlobal,
  ) async {
    emit(const SendNotificationsLoading());
    try {
      final resp = await actionClient.sendNotifications(
          SendNotificationsRequest(
              userId: userID, text: text, isGlobal: isGlobal),
          options: sessionOptions(getIt()));

      if (resp.statusCode == SendNotificationsResponse_StatusCode.OK) {
        emit(SendNotificationsSuccess(resp.statusMessage));
      } else {
        emit(SendNotificationsFailure(resp.statusMessage));
        emit(SendNotificationsInitial());
      }
    } catch (e) {
      emit(const SendNotificationsFailure(failedToReachServer));
    }
  }

  Future<void> setMarketDay(final marketDay) async {
    emit(const SetMarketDayLoading());
    try {
      final resp = await actionClient.setMarketDay(
          SetMarketDayRequest(marketDay: marketDay),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetMarketDayResponse_StatusCode.OK) {
        emit(SetMarketDaySuccess(resp.statusMessage));
      } else {
        emit(SetMarketDayFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetMarketDayFailure(failedToReachServer));
    }
  }

  Future<void> sendDividends(
    final int stockId,
    final Int64 dividendAmount,
  ) async {
    emit(const SendDividendsLoading());
    try {
      final resp = await actionClient.sendDividends(
          SendDividendsRequest(
              stockId: stockId, dividendAmount: dividendAmount),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SendDividendsResponse_StatusCode.OK) {
        emit(SendDividendsSuccess(resp.statusMessage));
      } else {
        emit(SendDividendsFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SendDividendsFailure(failedToReachServer));
    }
  }

  Future<void> setGivesDividends(
    final stockId,
    final bool givesDividends,
  ) async {
    emit(const SetGivesDividendsLoading());
    try {
      final resp = await actionClient.setGivesDividends(
          SetGivesDividendsRequest(
              stockId: stockId, givesDividends: givesDividends),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetGivesDividendsResponse_StatusCode.OK) {
        emit(SetGivesDividendsSuccess(resp.statusMessage));
      } else {
        emit(SetGivesDividendsFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetGivesDividendsFailure(failedToReachServer));
    }
  }

  Future<void> setBankruptcy(final stockID, final isBankrupt) async {
    emit(const SetBankruptcyLoading());
    try {
      final resp = await actionClient.setBankruptcy(
          SetBankruptcyRequest(stockId: stockID, isBankrupt: isBankrupt),
          options: sessionOptions(getIt()));
      if (resp.statusCode == SetBankruptcyResponse_StatusCode.OK) {
        emit(SetBankruptcySuccess(resp.statusMessage));
      } else {
        emit(SetBankruptcyFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const SetBankruptcyFailure(failedToReachServer));
    }
  }

  Future<void> loadStocks() async {
    emit(const LoadStocksLoading());
    try {
      final resp = await actionClient.loadStocks(LoadStocksRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == LoadStocksResponse_StatusCode.OK) {
        emit(LoadStocksSuccess(resp.statusMessage));
      } else {
        emit(LoadStocksFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const LoadStocksFailure(failedToReachServer));
    }
  }

  void add(
      Tab1Cubit sendNewsCubit,
      Tab1Cubit sendNotificationsCubit,
      Tab1Cubit setMarketDayCubit,
      Tab1Cubit sendDividendsCubit,
      Tab1Cubit setGivesDividendsCubit,
      Tab1Cubit setBankruptcyCubit,
      Tab1Cubit loadStocksCubit) {}
}
