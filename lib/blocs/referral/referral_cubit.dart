

import 'package:bloc/bloc.dart';

import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetReferralCode.pb.dart';
import 'package:equatable/equatable.dart';

part 'referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  // final DalalBloc dalalBloc;

  // LoginCubit(this.dalalBloc) : super(LoginInitial());
  ReferralCubit() : super(ReferralInitial());
  Future<void> referralCode() async {
    // emit(ReferralInitial());
    try {
      final referralResp =
          await actionClient.getReferralCode(GetReferralCodeRequest());
      if (referralResp.statusCode != GetReferralCodeResponse_StatusCode.OK) {
        emit(ReferralFailed(referralResp.statusMessage));
        // return;

      } else {
        emit(ReferralSuccess(referralResp.referralCode));
      }
    } catch (e) {
      logger.e(e);
      emit(const ReferralFailed(failedToReachServer));
    }
  }
}
