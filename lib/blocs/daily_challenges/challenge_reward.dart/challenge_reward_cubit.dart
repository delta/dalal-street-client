import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';
import 'package:equatable/equatable.dart';

part 'challenge_reward_state.dart';

class ChallengeRewardCubit extends Cubit<ChallengeRewardState> {
  final UserState userState;

  ChallengeRewardCubit(this.userState)
      : super(() {
          if (!userState.isCompleted) {
            return const ChallengeIncomplete();
          } else if (userState.isCompleted && !userState.isRewardClamied) {
            return const ChallengeComplete();
          } else {
            return const ChallengeRewardCalimed();
          }
        }());
}
