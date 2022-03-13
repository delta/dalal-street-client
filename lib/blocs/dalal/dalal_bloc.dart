import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Logout.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'dalal_event.dart';
part 'dalal_state.dart';

/// Handles the Authentication State of User. Also persists the state using [HydratedBloc]
///
/// Must be provided at the root of the app widget tree
///
/// The [DalalBloc] object can be accesed from anywhere in the widget tree easily using a [BuildContext] :
/// ```dart
/// final dalalBloc = context.read<DalalBloc>();
/// dalalBloc.add(const DalalLogOut());
/// ```
class DalalBloc extends HydratedBloc<DalalEvent, DalalState> {
  DalalBloc() : super(const DalalLoggedOut()) {
    on<CheckUser>((event, emit) async {
      if (state is DalalLoggedIn) {
        add(GetUserData((state as DalalLoggedIn).sessionId));
      } else if (state is! DalalDataLoaded &&
          state is! DalalVerificationPending) {
        // really quick transition to login page looks wierd
        await Future.delayed(const Duration(milliseconds: 400));
        // go to login page
        emit(const DalalLoggedOut(manualLogout: false));
      }
    });

    on<GetUserData>((event, emit) async {
      final sessionId = event.sessionId;
      emit(DalalDataLoading(sessionId));
      try {
        final loginResponse = await actionClient.login(
          LoginRequest(),
          options: sessionOptions(event.sessionId),
        );
        // Internal Error. User should be given option to try again
        if (loginResponse.statusCode != LoginResponse_StatusCode.OK) {
          throw Exception(loginResponse.statusMessage);
        }
        if (!loginResponse.user.isPhoneVerified) {
          emit(DalalVerificationPending(sessionId));
          return;
        }
        final globalStreams = await subscribeToGlobalStreams(loginResponse);
        emit(DalalDataLoaded(
          loginResponse.user,
          loginResponse.sessionId,
          globalStreams,
        ));
      } on GrpcError catch (e) {
        if (e.code == 16) {
          logger.e(e);
          // Unauthenticated
          logger.i('Logged out becuase of invalid sessionId');
          emit(const DalalLoggedOut(manualLogout: false));
        } else {
          logger.e(e);
          await Future.delayed(const Duration(milliseconds: 200));
          emit(DalalLoginFailed(sessionId));
        }
      } catch (e) {
        logger.e(e);
        await Future.delayed(const Duration(milliseconds: 200));
        emit(DalalLoginFailed(sessionId));
      }
    });

    on<DalalCheckVerification>((event, emit) async {
      final resp = event.loginResponse;
      if (resp.user.isPhoneVerified) {
        emit(DalalDataLoaded(
          resp.user,
          resp.sessionId,
          await subscribeToGlobalStreams(resp),
        ));
      } else {
        emit(DalalVerificationPending(resp.sessionId));
      }
    });

    on<DalalLogOut>((event, emit) {
      try {
        actionClient.logout(LogoutRequest(), options: sessionOptions(getIt()));
        if (getIt.isRegistered<GlobalStreams>()) {
          unsubscribeFromGlobalStreams(getIt(), getIt());
        }
      } catch (e) {
        // Cant do anything
        logger.e(e);
      }
      emit(const DalalLoggedOut());
    });
  }

  bool get loggedIn => state is! DalalLoggedOut;

  @override
  Future<void> close() {
    if (state is! DalalLoggedOut) {
      unsubscribeFromGlobalStreams(getIt(), getIt());
    }
    return super.close();
  }

  /// To maintain constand storage name across different app versions
  String get storagePrefix => 'DalalBloc';

  // Methods required by HydratedBloc to persist state
  @override
  DalalState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('sessionId')) {
      return DalalLoggedIn(json['sessionId']);
    }
    return const DalalLoggedOut();
  }

  @override
  Map<String, dynamic>? toJson(DalalState state) {
    if (state is DalalDataLoaded) {
      return {'sessionId': state.sessionId};
    } else if (state is DalalVerificationPending) {
      return {'sessionId': state.sessionId};
    } else if (state is DalalLoggedIn) {
      return {'sessionId': state.sessionId};
    } else if (state is DalalDataLoading) {
      return {'sessionId': state.sessionId};
    } else if (state is DalalLoginFailed) {
      return {'sessionId': state.sessionId};
    }
    return {};
  }
}
