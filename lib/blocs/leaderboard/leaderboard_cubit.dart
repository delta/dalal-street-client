import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetDailyLeaderboard.pb.dart';
import 'package:dalal_street_client/proto_build/actions/GetLeaderboard.pb.dart';
import 'package:dalal_street_client/proto_build/models/DailyLeaderboardRow.pb.dart';
import 'package:dalal_street_client/proto_build/models/LeaderboardRow.pb.dart';
import 'package:equatable/equatable.dart';

part 'leaderboard_state.dart';

enum leaderboardTypes { Overall, Daily }

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardInitial());

  Future<void> getLeaderboard(
      int startingId, int count, String leaderboardType) async {
    emit(const LeaderboardLoading());
    try {
      if (leaderboardType == leaderboardTypes.Overall.toString()) {
        final resp = await actionClient.getLeaderboard(
          GetLeaderboardRequest(startingId: startingId, count: count),
          options: sessionOptions(getIt()),
        );
        if (resp.statusCode == GetLeaderboardResponse_StatusCode.OK) {
          emit(OverallLeaderboardSuccess(resp.myRank, resp.rankList));
        } else {
          emit(LeaderboardFailure(resp.statusMessage));
        }
      } else {
        final resp = await actionClient.getDailyLeaderboard(
          GetDailyLeaderboardRequest(startingId: startingId, count: count),
          options: sessionOptions(getIt()),
        );
        if (resp.statusCode == GetDailyLeaderboardResponse_StatusCode.OK) {
          emit(DailyLeaderboardSuccess(resp.myRank, resp.rankList));
        } else {
          emit(LeaderboardFailure(resp.statusMessage));
        }
      }
    } catch (e) {
      logger.e(e);
      emit(const LeaderboardFailure(failedToReachServer));
    }
  }
}
