import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetLeaderboard.pb.dart';
import 'package:dalal_street_client/proto_build/models/LeaderboardRow.pb.dart';
import 'package:equatable/equatable.dart';

part 'overall_leaderboard_state.dart';

class OverallLeaderboardCubit extends Cubit<OverallLeaderboardState> {
  OverallLeaderboardCubit() : super(OverallLeaderboardInitial());

  Future<void> getOverallLeaderboard(int startingId, int count) async {
    emit(const OverallLeaderboardLoading());
    try {
      final resp = await actionClient.getLeaderboard(
        GetLeaderboardRequest(startingId: startingId, count: count),
        options: sessionOptions(getIt()),
      );
      if (resp.statusCode == GetLeaderboardResponse_StatusCode.OK) {
        emit(OverallLeaderboardSuccess(resp.myRank, resp.rankList));
      } else {
        emit(OverallLeaderboardFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const OverallLeaderboardFailure(failedToReachServer));
    }
  }
}
