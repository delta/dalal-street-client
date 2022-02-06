import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyLeaderboard.pb.dart';
import 'package:dalal_street_client/proto_build/models/DailyLeaderboardRow.pb.dart';
import 'package:equatable/equatable.dart';

part 'daily_leaderboard_state.dart';

class DailyLeaderboardCubit extends Cubit<DailyLeaderboardState> {
  DailyLeaderboardCubit() : super(DailyLeaderboardInitial());

  Future<void> getDailyLeaderboard(int startingId, int count) async {
    emit(const DailyLeaderboardLoading());
    try {
      final resp = await actionClient.getDailyLeaderboard(
        GetDailyLeaderboardRequest(startingId: startingId, count: count),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetDailyLeaderboardResponse_StatusCode.OK) {
        emit(DailyLeaderboardSuccess(resp.myRank, resp.rankList));
      } else {
        emit(DailyLeaderboardFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const DailyLeaderboardFailure(failedToReachServer));
    }
  }
}
