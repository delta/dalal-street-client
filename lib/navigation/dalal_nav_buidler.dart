import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/navigation/router.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:dalal_street_client/utils/stream_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Provided as `navigatorBuilder` in [GoRouter].
///
/// It will wrap all the pages, and serve as a place to perform common app logic
class DalalNavBuilder extends StatefulWidget {
  final GoRouterState routerState;
  final Widget child;

  const DalalNavBuilder(
      {Key? key, required this.routerState, required this.child})
      : super(key: key);

  @override
  State<DalalNavBuilder> createState() => _DalalNavBuilderState();
}

class _DalalNavBuilderState extends State<DalalNavBuilder> {
  @override
  void initState() {
    super.initState();
    logger.i('DalalNavBuilder init');
    context.read<DalalBloc>().add(const CheckUser());
  }

  @override
  build(context) => BlocConsumer<DalalBloc, DalalState>(
        listener: (context, state) {
          if (state is DalalDataLoaded) {
            // Register sessionId
            getIt.registerSingleton(state.sessionId);
            // Register Global Streams
            getIt.registerSingleton(state.globalStreams);

            logger.i('user logged in');

            if (!isUserRoute(widget.routerState)) {
              context.webGo('/home');
              logger.i(
                  'Redirecting to /home from ${widget.routerState.location}');
            } else if (!isVerifyRoute(widget.routerState)) {
              // Redirect to the same route, without adding to web history
              // Originally state will not be DalalDataLoaded, so exception will happen
              // But we covered over it by showing loading ui
              // Now the state has required data, so router can again direct to the required page
              //
              // Hacky fix, but no other way possible unless the routing lib gives a dedicated api for async loading of data
              context.webGo(
                widget.routerState.location,
                extra: widget.routerState.extra,
              );
            }

            // snackbar util
            streamSnackBarUpdates(context);
          } else if (state is DalalVerificationPending) {
            // Register sessionId
            getIt.registerSingleton(state.sessionId);

            showSnackBar(context, 'Verify your phone to continue',
                type: SnackBarType.warning);
            context.webGo('/enterPhone');
          } else if (state is DalalLoggedOut) {
            // Unregister everything
            getIt.reset();

            if (state.manualLogout) {
              logger.i('user logged out manually');
              showSnackBar(context, 'User Logged Out',
                  type: SnackBarType.success);
            } else {
              logger.i('user logged out because of issue with session id');
            }
            if (isUserRoute(widget.routerState)) context.webGo('/');
          } else if (state is DalalLoginFailed) {
            // Nothing to do. Just show button to retry
          }
        },
        builder: (context, state) {
          if (state is DalalDataLoaded ||
              state is DalalLoggedOut ||
              state is DalalVerificationPending) {
            return widget.child;
          }
          if (state is DalalLoginFailed) {
            return _retryScreen(() {
              context.read<DalalBloc>().add(GetUserData(state.sessionId));
            });
          }
          return _loadingScreen();
        },
      );

  Widget _retryScreen(void Function() onRetryClick) => SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Failed to reach server'),
                const SizedBox(height: 20),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: onRetryClick,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _loadingScreen() => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DalalLoadingBar(),
              Text(
                'Dalal Street',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      );
}
