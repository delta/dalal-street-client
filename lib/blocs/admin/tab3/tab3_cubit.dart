import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/AddDailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/actions/AddMarketEvent.pb.dart';
import 'package:dalal_street_client/proto_build/actions/AddStocksToExchange.pb.dart';
import 'package:dalal_street_client/proto_build/actions/CloseDailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/actions/OpenDailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/actions/UpdateEndOfDayValues.pb.dart';
import 'package:dalal_street_client/proto_build/actions/UpdateStockPrice.pb.dart';
import 'package:equatable/equatable.dart';

part 'tab3_state.dart';

class Tab3Cubit extends Cubit<Tab3State> {
  Tab3Cubit() : super(Tab3Initial());

  Future<void> updateEndOfDaysValues() async {
    emit(const UpdateEndOfDayValuesLoading());
    try {
      final resp = await actionClient.updateEndOfDayValues(
          UpdateEndOfDayValuesRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UpdateEndOfDayValuesResponse_StatusCode.OK) {
        emit(UpdateEndOfDayValuesSuccess(resp.statusMessage));
      } else {
        emit(UpdateEndOfDayValuesFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UpdateEndOfDayValuesFailure(failedToReachServer));
    }
  }

  Future<void> updateStockPrice(
    final stockId,
    final newPrice,
  ) async {
    emit(const UpdateStockPriceLoading());
    try {
      final resp = await actionClient.updateStockPrice(
          UpdateStockPriceRequest(
            stockId: stockId,
            newPrice: newPrice,
          ),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UpdateStockPriceResponse_StatusCode.OK) {
        emit(UpdateStockPriceSuccess(resp.statusMessage));
      } else {
        emit(UpdateStockPriceFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UpdateStockPriceFailure(failedToReachServer));
    }
  }

  Future<void> addStocksToExchange(
    final stockId,
    final newStocks,
  ) async {
    emit(const AddStocksToExchangeLoading());
    try {
      final resp = await actionClient.addStocksToExchange(
          AddStocksToExchangeRequest(stockId: stockId, newStocks: newStocks),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddStocksToExchangeResponse_StatusCode.OK) {
        emit(AddStocksToExchangeSuccess(resp.statusMessage));
      } else {
        emit(AddStocksToExchangeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const AddStocksToExchangeFailure(failedToReachServer));
    }
  }

  Future<void> addMarketEvent(final stockId, final headline, final text,
      final imageURL, final bool isGlobal) async {
    emit(const AddMarketEventLoading());
    try {
      final resp = await actionClient.addMarketEvent(
          AddMarketEventRequest(
              stockId: stockId,
              headline: headline,
              text: text,
              imageUrl: imageURL,
              isGlobal: isGlobal),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddMarketEventResponse_StatusCode.OK) {
        emit(AddMarketEventSuccess(resp.statusMessage));
      } else {
        emit(AddMarketEventFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const AddMarketEventFailure(failedToReachServer));
    }
  }

  Future<void> addDailyChallenge(int? marketDay, int? stockID, int? reward,
      dynamic value, ChallengeType challengeType) async {
    emit(const AddDailyChallengeLoading());
    try {
      final resp = await actionClient.addDailyChallenge(
          AddDailyChallengeRequest(
              marketDay: marketDay,
              stockId: stockID,
              reward: reward,
              value: value,
              challengeType: challengeType),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddDailyChallengeResponse_StatusCode.OK) {
        emit(AddDailyChallengeSuccess(resp.statusMessage));
      } else {
        emit(AddDailyChallengeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);

      emit(const AddDailyChallengeFailure(failedToReachServer));
    }
  }

  Future<void> openDailyChallenge() async {
    emit(const OpenDailyChallengeLoading());
    try {
      final resp = await actionClient.openDailyChallenge(
          OpenDailyChallengeRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == OpenDailyChallengeResponse_StatusCode.OK) {
        emit(OpenDailyChallengeSuccess(resp.statusMessage));
      } else {
        emit(OpenDailyChallengeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const OpenDailyChallengeFailure(failedToReachServer));
    }
  }

  Future<void> closeDailyChallenges() async {
    emit(const CloseDailyChallengeLoading());
    try {
      final resp = await actionClient.closeDailyChallenge(
          CloseDailyChallengeRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == CloseDailyChallengeResponse_StatusCode.OK) {
        emit(CloseDailyChallengeSuccess(resp.statusMessage));
      } else {
        emit(CloseDailyChallengeFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const CloseDailyChallengeFailure(failedToReachServer));
    }
  }

  void add(
      Tab3Cubit updateEndOfDayValuesCubi,
      Tab3Cubit updateStockPriceCubit,
      Tab3Cubit addStocksToExchangeCubit,
      Tab3Cubit addMarketEventCubit,
      Tab3Cubit addDailyChallengeCubit,
      Tab3Cubit openDailyChallengeCubit,
      Tab3Cubit closeDailyChallengeCubit) {}
}
