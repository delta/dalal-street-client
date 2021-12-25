import 'package:dalal_street_client/proto_build/models/DailyChallenge.pb.dart';
import 'package:dalal_street_client/proto_build/models/UserState.pb.dart';

class DailyChallengeInfo {
  final DailyChallenge challenge;
  final UserState userState;

  DailyChallengeInfo(this.challenge, this.userState);
}
