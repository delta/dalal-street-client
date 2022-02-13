import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DalalNavBuilder extends StatelessWidget {
  final Widget child;

  const DalalNavBuilder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i('nav builder');
    return BlocListener<DalalBloc, DalalState>(
      listener: (context, state) {
        if (state is DalalDataLoaded) {
          // Register sessionId
          getIt.registerSingleton(state.sessionId);
          // Register Global Streams
          getIt.registerSingleton(state.globalStreams);

          logger.i('user logged in');
          context.replace('/home', extra: state.user);
        } else if (state is DalalVerificationPending) {
          // Register sessionId
          getIt.registerSingleton(state.sessionId);

          showSnackBar(context, 'Verify your phone to continue');
          context.replace('/enterPhone');
        } else if (state is DalalLoggedOut) {
          // Unregister everything
          getIt.reset();

          if (!state.fromSplash) {
            // Show msg only when coming from a page other than splash
            logger.i('user logged out');
            showSnackBar(context, 'User Logged Out');
          }
          context.replace('/landing');
        } else if (state is DalalLoginFailed) {
          // Handled in SplashPage
        }
      },
      child: child,
    );
  }
}
