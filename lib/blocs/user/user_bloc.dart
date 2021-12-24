import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/models/company_info.dart';
import 'package:dalal_street_client/proto_build/actions/GetStockList.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Logout.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

/// Handles the Authentication State of User. Also persists the state using [HydratedBloc]
///
/// Must be provided at the root of the app widget tree
///
/// The [UserBloc] object can be accesed from anywhere in the widget tree easily using a [BuildContext] :
/// ```dart
/// final userBloc = context.read<UserBloc>();
/// userBloc.add(const UserLogOut());
/// ```
class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc() : super(const UserLoggedOut()) {
    on<CheckUser>((event, emit) async {
      if (state is UserLoggedIn) {
        add(GetUserData((state as UserLoggedIn).sessionId));
      } else {
        // really quick transition to login page looks wierd
        await Future.delayed(const Duration(milliseconds: 400));
        // go to login page
        emit(const UserLoggedOut(fromSplash: true));
      }
    });

    on<GetUserData>((event, emit) async {
      try {
        final loginResponse = await actionClient.login(
          LoginRequest(),
          options: sessionOptions(event.sessionId),
        );
        final sessionId = event.sessionId;
        // TODO: handle LoginResponse_StatusCode.InvalidCredentialsError separately
        if (loginResponse.statusCode != LoginResponse_StatusCode.OK) {
          emit(UserLoginFailed(sessionId));
          return;
        }
        // Need a seperate try catch because login failure is different from stock response failure
        try {
          final stockResponse = await actionClient.getStockList(
            GetStockListRequest(),
            options: sessionOptions(sessionId),
          );
          if (stockResponse.statusCode != GetStockListResponse_StatusCode.OK) {
            emit(UserLoginFailed(sessionId));
            return;
          }
          final gameStateResp = await streamClient.subscribe(
            SubscribeRequest(dataStreamType: DataStreamType.GAME_STATE),
            options: sessionOptions(sessionId),
          );
          if (gameStateResp.statusCode != SubscribeResponse_StatusCode.OK) {
            emit(UserLoginFailed(sessionId));
            return;
          }
          final gameStateStream = streamClient.getGameStateUpdates(
            gameStateResp.subscriptionId,
            options: sessionOptions(sessionId),
          );
          emit(UserDataLoaded(
            loginResponse.user,
            loginResponse.sessionId,
            stockMapToCompanyMap(stockResponse.stockList),
            gameStateStream,
          ));
        } catch (e) {
          logger.e(e);
          emit(UserLoginFailed(sessionId));
        }
      } catch (e) {
        // Session invalid or expired
        logger.e(e);
        emit(const UserLoggedOut(fromSplash: true));
      }
    });

    on<UserLogIn>((event, emit) => emit(UserDataLoaded(
          event.loginResponse.user,
          event.loginResponse.sessionId,
          event.companies,
          event.gameStateStream,
        )));

    on<UserLogOut>((event, emit) {
      try {
        actionClient.logout(LogoutRequest(),
            options: sessionOptions(getIt<String>()));
      } catch (e) {
        // Cant do anything
        logger.e(e);
      }
      emit(const UserLoggedOut());
    });
  }

  // Methods required by HydratedBloc to persist state
  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      return UserLoggedIn(json['sessionId']);
    } catch (_) {
      return const UserLoggedOut();
    }
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is UserDataLoaded) {
      return {'sessionId': state.sessionId};
    } else if (state is UserLoggedIn) {
      return {'sessionId': state.sessionId};
    } else if (state is UserLoginFailed) {
      return {'sessionId': state.sessionId};
    }
    return {};
  }
}
