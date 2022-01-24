import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/UpdateEndOfDayValues.pb.dart';
import 'package:equatable/equatable.dart';

part 'update_end_of_day_values_state.dart';

class UpdateEndOfDayValuesCubit extends Cubit<UpdateEndOfDayValuesState> {
  UpdateEndOfDayValuesCubit() : super(UpdateEndOfDayValuesInitial());

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
}
