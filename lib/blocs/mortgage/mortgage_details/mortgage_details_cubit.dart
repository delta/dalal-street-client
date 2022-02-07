import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/GetMortgageDetails.pb.dart';
import 'package:dalal_street_client/proto_build/models/MortgageDetail.pb.dart';
import 'package:equatable/equatable.dart';

part 'mortgage_details_state.dart';

class MortgageDetailsCubit extends Cubit<MortgageDetailsState> {
  MortgageDetailsCubit() : super(MortgageDetailsLoading());

  Future<void> getMortgageDetails() async {
    try {
      final resp = await actionClient.getMortgageDetails(
          GetMortgageDetailsRequest(),
          options: sessionOptions(getIt<String>()));
      if (resp.statusCode == GetMortgageDetailsResponse_StatusCode.OK) {
        emit(MortgageDetailsLoaded(resp.mortgageDetails));
      } else {
        emit(MortgageDetailsFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const MortgageDetailsFailure(failedToReachServer));
    }
  }
}
