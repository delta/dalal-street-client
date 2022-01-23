import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetReferralCode.pb.dart';
import 'package:equatable/equatable.dart';
part 'referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  ReferralCubit() : super(ReferralInitial());
  Future<void> getreferralcode(String email) async {
    try {
      final GetReferralCodeResponse getReferralCodeResponse =
          await actionClient.getReferralCode(
              GetReferralCodeRequest(
                email: email,
              ),
              options: sessionOptions(getIt()));
      emit(ReferralSuccess(getReferralCodeResponse.referralCode));
    } catch (e) {
      emit(ReferralFailed(e.toString()));
    }
  }
}
