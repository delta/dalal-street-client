import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/proto_build/actions/GetIpoStockList.pb.dart';
import 'package:dalal_street_client/proto_build/actions/PlaceIpoBid.pb.dart';
import 'package:dalal_street_client/proto_build/models/IpoStock.pb.dart';
import 'package:equatable/equatable.dart';
import '../../config/get_it.dart';
import '../../grpc/client.dart';
part 'ipo_state.dart';

class IpoCubit extends Cubit<IpoState> {
  IpoCubit() : super(IpoInitial());
  Future<void> getipostocklist() async {
    try {
      final resp = await actionClient.getIpoStockList(GetIpoStockListRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == GetIpoStockListResponse_StatusCode.OK) {
        logger.i('length ${resp.ipoStockList}');
        emit(GetIpoStockListSucess(resp.ipoStockList));
      } else {
        emit(GetIpoStockListFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(GetIpoStockListFailure(e.toString()));
    }
  }

  Future<void> placeipobid(stockId, slotQuantity, slotPrice) async {
    try {
      // ignore: unused_local_variable
      final resp = await actionClient.placeIpoBid(
          PlaceIpoBidRequest(stockId: stockId, slotQuantity: 1),
          options: sessionOptions(getIt()));

      if (resp.statusCode == PlaceIpoBidResponse_StatusCode.OK) {
        emit(const PlaceIpoSucess());
        return;
      }

      emit(PlaceIpoFailure(resp.statusMessage));
    } catch (e) {
      logger.e(e);
      emit(const PlaceIpoFailure(failedToReachServer));
    }
  }
}
