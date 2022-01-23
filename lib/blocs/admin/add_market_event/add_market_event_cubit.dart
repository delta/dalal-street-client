import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/AddMarketEvent.pb.dart';
import 'package:equatable/equatable.dart';

part 'add_market_event_state.dart';

class AddMarketEventCubit extends Cubit<AddMarketEventState> {
  AddMarketEventCubit() : super(AddMarketEventInitial());

  Future<void> addMarketEvent(final stockId, final headline, final text,
      final imageURL, final bool is_global) async {
    emit(const AddMarketEventLoading());
    try {
      final resp = await actionClient.addMarketEvent(
          AddMarketEventRequest(
              stockId: stockId,
              headline: headline,
              text: text,
              imageUrl: imageURL,
              isGlobal: is_global),
          options: sessionOptions(getIt()));
      if (resp.statusCode == AddMarketEventResponse_StatusCode.OK) {
        emit(AddMarketEventSuccess(resp.statusMessage));
      } else {
        emit(AddMarketEventFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const AddMarketEventFailure(failedToReachServer));
    }
  }
}
