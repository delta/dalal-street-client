import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/models/company_info.dart';
import 'package:dalal_street_client/global_streams.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Logout.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

// TODO: rename to DalalBloc
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
      final sessionId = event.sessionId;
      try {
        final loginResponse = await actionClient.login(
          LoginRequest(),
          options: sessionOptions(event.sessionId),
        );
        // Internal Error. User should be given option to try again
        if (loginResponse.statusCode != LoginResponse_StatusCode.OK) {
          throw Exception(loginResponse.statusMessage);
        }
        final globalStreams = await subscribeToGlobalStreams(sessionId);
        emit(UserDataLoaded(
          loginResponse.user,
          loginResponse.sessionId,
          stockMapToCompanyMap(globalStreams.stockList),
          globalStreams,
        ));
      } on GrpcError catch (e) {
        logger.e(e);
        if (e.code == 16) {
          // Unauthenticated
          logger.i('Logged out becuase of invalid sessionId');
          emit(const UserLoggedOut(fromSplash: true));
        } else {
          emit(UserLoginFailed(sessionId));
        }
      } catch (e) {
        logger.e(e);
        emit(UserLoginFailed(sessionId));
      }
    });

    // TODO: UserLogIn event and UserDataLoaded state has the exact same data. Maybe some refactoring can be done?
    on<UserLogIn>((event, emit) => emit(UserDataLoaded(
          event.loginResponse.user,
          event.loginResponse.sessionId,
          event.companies,
          event.globalStreams,
        )));

    on<UserLogOut>((event, emit) {
      try {
        actionClient.logout(LogoutRequest(), options: sessionOptions(getIt()));
        unsubscribeFromGlobalStreams(getIt(), getIt());
      } catch (e) {
        // Cant do anything
        logger.e(e);
      }
      emit(const UserLoggedOut());
    });
  }

  @override
  Future<void> close() {
    if (state is! UserLoggedOut) {
      unsubscribeFromGlobalStreams(getIt(), getIt());
    }
    return super.close();
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
