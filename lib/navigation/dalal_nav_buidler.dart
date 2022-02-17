import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
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
    logger.e('DalalNavBuilder init');
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

            context.webGo('/home', extra: state.user);
          } else if (state is DalalVerificationPending) {
            // Register sessionId
            getIt.registerSingleton(state.sessionId);

            showSnackBar(context, 'Verify your phone to continue',
                type: SnackBarType.warning);
            context.webGo('/enterPhone');
          } else if (state is DalalLoggedOut) {
            // Unregister everything
            getIt.reset();

            // TODO: how to change this if splash screen is removed?
            if (!state.fromSplash) {
              // Show msg only when coming from a page other than splash
              logger.i('user logged out');
              showSnackBar(context, 'User Logged Out',
                  type: SnackBarType.success);
            }
            if (widget.routerState.location != '/') context.webGo('/');
          } else if (state is DalalLoginFailed) {}
        },
        builder: (context, state) {
          if (state is DalalDataLoaded ||
              state is DalalLoggedOut ||
              state is DalalVerificationPending) {
            return widget.child;
          }
          if (state is DalalLoginFailed) {
            _retryScreen(() {});
          }
          return _loadingScreen();
        },
      );

  Widget _retryScreen(void Function() onRetryClick) => Column(
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
