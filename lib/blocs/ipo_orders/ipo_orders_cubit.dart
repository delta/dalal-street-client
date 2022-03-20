import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/proto_build/actions/GetMyOrders.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/IpoBid.pb.dart';
import 'package:equatable/equatable.dart';

import '../../config/get_it.dart';
import '../../grpc/client.dart';
import '../../proto_build/actions/CancelIpoBid.pb.dart';
import '../../proto_build/actions/GetMyOrders.pb.dart';

part 'ipo_orders_state.dart';

class IpoOrdersCubit extends Cubit<IpoOrdersState> {
  IpoOrdersCubit() : super(IpoOrdersInitial());

  Future<void> getmyipoorders() async {
    try {
      final resp = await actionClient.getMyIpoBids(GetMyIpoBidsRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == GetMyIpoBidsResponse_StatusCode.OK) {
        emit(GetMyIpoOrdersSucess(resp.ipoBids));
      } else {
        emit(GetMyIpoOrdersFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(GetMyIpoOrdersFailure(e.toString()));
    }
  }

  Future<void> cancelipobids(ipoBidId) async {
    try {
      // ignore: unused_local_variable
      final resp = actionClient.cancelIpoBid(
          CancelIpoBidRequest(ipoBidId: ipoBidId),
          options: sessionOptions(getIt()));
      emit(const CancelIpoBidSucess());
    } catch (e) {
      logger.e(e.toString());
      CancelIpoBidFailure(e.toString());
    }
  }
}
