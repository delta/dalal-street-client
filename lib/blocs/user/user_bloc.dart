import 'dart:async';

import 'package:dalal_street_client/blocs/streams/gamestate/gamestate_cubit.dart';
import 'package:dalal_street_client/blocs/streams/notification/notification_cubit.dart';
import 'package:dalal_street_client/blocs/streams/stockprice/stockprice_cubit.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/Login.pb.dart';
import 'package:dalal_street_client/proto_build/actions/Logout.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
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
  final GamestateStreamCubit gamestateStreamCubit;
  final StockpriceStreamCubit stockpriceStreamCubit;
  final NotificationStreamCubit notificationStreamCubit;

  late final StreamSubscription gamestateStreamSubscription;
  late final StreamSubscription stockpriceStreamSubscription;
  late final StreamSubscription notificationStreamSubscription;

  bool globalStreamSubscriptionStatus = true;

  UserBloc(this.gamestateStreamCubit, this.stockpriceStreamCubit,
      this.notificationStreamCubit)
      : super(const UserLoggedOut()) {
    gamestateStreamSubscription = gamestateStreamCubit.stream.listen((state) {
      if (state is GamestateStreamError) {
        globalStreamSubscriptionStatus = false;
      }

      if (state is GamestateStreamSuccess) {
        logger.i('success');
      }
    });

    stockpriceStreamSubscription = stockpriceStreamCubit.stream.listen((state) {
      if (state is StockpriceStreamError) {
        globalStreamSubscriptionStatus = false;
      }

      if (state is StockpriceStreamSuccess) {
        logger.i('success');
      }
    });

    notificationStreamSubscription =
        notificationStreamCubit.stream.listen((state) {
      if (state is NotificationStreamError) {
        globalStreamSubscriptionStatus = false;
      }

      if (state is NotificationStreamSuccess) {
        logger.i('success');
      }
    });

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
        final loginResponse = await actionClient.login(LoginRequest(),
            options: sessionOptions(event.sessionId));

        if (loginResponse.statusCode == LoginResponse_StatusCode.OK) {
          // Register sessionId
          getIt.registerSingleton(loginResponse.sessionId);

          await _startGlobalStream();

          // if global subscription fails
          if (!globalStreamSubscriptionStatus) {
            return emit(UserDataError());
          }
          logger.i('escaped');

          emit(UserDataLoaded(loginResponse.user, loginResponse.sessionId));
        }
      } catch (e) {
        // Session invalid or expired
        logger.e(e);
        emit(UserDataError());
      }
    });

    on<UserLogIn>((event, emit) async {
      // Register sessionId
      getIt.registerSingleton(event.loginResponse.sessionId);

      await _startGlobalStream();
      // if global subscription fails
      if (!globalStreamSubscriptionStatus) {
        return emit(UserDataError());
      }

      logger.i('escaped');

      emit(UserDataLoaded(
          event.loginResponse.user, event.loginResponse.sessionId));
    });

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
    }
    return {};
  }

  // method to subscribe all the global streams
  Future<List<void>> _startGlobalStream() async {
    // starting the global stream
    return Future.wait([
      gamestateStreamCubit.start(),
      stockpriceStreamCubit.start(),
      notificationStreamCubit.start()
    ]);
  }
}
