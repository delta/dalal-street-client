import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/error_messages.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/actions/BlockUser.pb.dart';
import 'package:dalal_street_client/proto_build/actions/CloseMarket.pb.dart';
import 'package:dalal_street_client/proto_build/actions/InspectUser.pb.dart';
import 'package:dalal_street_client/proto_build/actions/OpenMarket.pb.dart';
import 'package:dalal_street_client/proto_build/actions/UnblockAllUsers.pb.dart';
import 'package:dalal_street_client/proto_build/actions/UnblockUser.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';

part 'tab2_state.dart';

class Tab2Cubit extends Cubit<Tab2State> {
  Tab2Cubit() : super(Tab2Initial());

  Future<void> openMarket(final bool dayHighAndLow) async {
    emit(const OpenMarketLoading());
    try {
      final resp = await actionClient.openMarket(
          OpenMarketRequest(updateDayHighAndLow: dayHighAndLow),
          options: sessionOptions(getIt()));

      if (resp.statusCode == OpenMarketResponse_StatusCode.OK) {
        emit(OpenMarketSuccess(resp.statusMessage));
      } else {
        emit(OpenMarketFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const OpenMarketFailure(failedToReachServer));
    }
  }

  Future<void> closeMarket(
    final bool updatePrevDayClose,
  ) async {
    emit(const CloseMarketLoading());
    try {
      final resp = await actionClient.closeMarket(
          CloseMarketRequest(updatePrevDayClose: updatePrevDayClose),
          options: sessionOptions(getIt()));
      if (resp.statusCode == CloseMarketResponse_StatusCode.OK) {
        emit(CloseMarketSuccess(resp.statusMessage));
      } else {
        emit(CloseMarketFailure(resp.statusMessage));
        emit(CloseMarketInitial());
      }
    } catch (e) {
      logger.e(e);
      emit(const CloseMarketFailure(failedToReachServer));
    }
  }

  Future<void> blockUser(final int userID, final Int64 penalty) async {
    emit(const BlockUserLoading());
    try {
      final resp = await actionClient.blockUser(
          BlockUserRequest(userId: userID, penalty: penalty),
          options: sessionOptions(getIt()));
      if (resp.statusCode == BlockUserResponse_StatusCode.OK) {
        emit(BlockUserSuccess(resp.statusMessage));
      } else {
        emit(BlockUserFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const BlockUserFailure(failedToReachServer));
    }
  }

  Future<void> inspectUser(
      final userID, final transactionType, final day) async {
    emit(const InspectUserLoading());
    try {
      final resp = await actionClient.inspectUser(
          InspectUserRequest(
              userId: userID, transactionType: transactionType, day: day),
          options: sessionOptions(getIt()));
      if (resp.statusCode == InspectUserResponse_StatusCode.OK) {
        emit(InspectUserSuccess(resp.statusMessage));
      } else {
        emit(InspectUserFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const InspectUserFailure(failedToReachServer));
    }
  }

  Future<void> unblockAllUsers() async {
    emit(const UnblockAllUsersLoading());
    try {
      final resp = await actionClient.unBlockAllUsers(UnblockAllUsersRequest(),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UnblockAllUsersResponse_StatusCode.OK) {
        emit(UnblockAllUsersSuccess(resp.statusMessage));
      } else {
        emit(UnblockAllUsersFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UnblockAllUsersFailure(failedToReachServer));
    }
  }

  Future<void> unblockUser(final userID) async {
    emit(const UnblockUserLoading());
    try {
      final resp = await actionClient.unBlockUser(
          UnblockUserRequest(userId: userID),
          options: sessionOptions(getIt()));
      if (resp.statusCode == UnblockUserResponse_StatusCode.OK) {
        emit(UnblockUserSuccess(resp.statusMessage));
      } else {
        emit(UnblockUserFailure(resp.statusMessage));
      }
    } catch (e) {
      logger.e(e);
      emit(const UnblockUserFailure(failedToReachServer));
    }
  }

  void add(
    Tab2Cubit openMarketCubit,
    Tab2Cubit closeMarketCubit,
    Tab2Cubit blockUserCubit,
    Tab2Cubit inspectUserCubit,
    Tab2Cubit unblockAllUsersCubit,
    Tab2Cubit unblockUserCubit,
  ) {}
}
