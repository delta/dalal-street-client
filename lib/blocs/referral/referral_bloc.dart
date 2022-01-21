import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetReferralCode.pb.dart';
import 'package:equatable/equatable.dart';

part 'referral_event.dart';
part 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  ReferralBloc() : super(ReferralInitial()) {
    on<GetReferralCode>((event, emit)async {
      try
      { 
         final GetReferralCodeResponse getReferralCodeResponse = await 
         actionClient.getReferralCode(GetReferralCodeRequest(email: event.email,),options: sessionOptions(getIt()));
         emit(ReferralSuccess(getReferralCodeResponse.referralCode));
      }
      catch(e)
      {
        ReferralFailed(e.toString());
      }
    });
  }
}
