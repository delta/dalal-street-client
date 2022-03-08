import 'package:dalal_street_client/blocs/admin/tab1/tab1_cubit.dart';
import 'package:dalal_street_client/blocs/admin/tab2/tab2_cubit.dart';
import 'package:dalal_street_client/blocs/admin/tab3/tab3_cubit.dart';
import 'package:dalal_street_client/blocs/auth/change_password/change_password_cubit.dart';
import 'package:dalal_street_client/blocs/auth/forgot_password/forgot_password_cubit.dart';
import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/blocs/dalal/dalal_bloc.dart';
import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/resend_mail/resend_mail_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/navigation/dalal_nav_buidler.dart';
import 'package:dalal_street_client/navigation/home_routes.dart';
import 'package:dalal_street_client/pages/admin_page/admin_page.dart';
import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/pages/company_page/company_page.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home.dart';
import 'package:dalal_street_client/pages/auth/check_mail_page.dart';
import 'package:dalal_street_client/pages/auth/forgot_password_page.dart';
import 'package:dalal_street_client/pages/auth/change_password_page.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/auth/register_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_otp_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_phone_page.dart';
import 'package:dalal_street_client/pages/landing_page.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/utils/regex_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Creates [GoRouter] object from all the routes.
///
/// [context] is required because some routes need to access [DalalState] for
/// displaying ui.
GoRouter generateRouter(BuildContext context) => GoRouter(
    debugLogDiagnostics: true,
    routes: [
      ..._initialRoutes,
      ..._authRoutes,
      ...verifyGoRoutes,
      GoRoute(
        /// A regular expression to match all home routes
        /// Note: Sorry for hardcoding everything, i am noob in regex
        ///
        /// Since this is important routing logic, always test in online regex
        /// sites, like https://regex101.com/, before changing anything. When
        /// testing regex pattern, get rid of ':p' at the beginning. It is
        /// only required by gorouter, and will give incorrect regex results
        path:
            // TODO: do this without hardcoding
            '/:p(home|portfolio|exchange|ranking|news|mortgage|dailyChallenges|openOrders|referAndEarn|mediaPartners|notifications)',
        builder: (_, state) {
          final userState = context.read<DalalBloc>().state as DalalDataLoaded;
          final location = state.location;
          final mobileExtras = mobileHomePagesMore(userState.user);
          if (kIsWeb || !mobileExtras.containsKey(location)) {
            return DalalHome(
              user: userState.user,
              route: location,
            );
          }
          // If device is mobile, and the route is from bottom sheet
          return mobileExtras[location]!;
        },
      ),
      GoRoute(
        path: '/company/:id',
        builder: (_, state) {
          final stockId = int.tryParse(state.params['id']!);
          if (stockId == null) {
            throw Exception('Invalid company id');
          }

          final stockIds = getIt<GlobalStreams>().latestStockMap.keys.toList();
          if (!stockIds.contains(stockId)) {
            throw Exception('Company with id $stockId doesn\'t exist');
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MarketDepthBloc()),
              BlocProvider(create: (_) => SubscribeCubit()),
              BlocProvider(create: (_) => NewsBloc()),
            ],
            child: CompanyPage(stockId: stockId),
          );
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => Tab1Cubit()),
            BlocProvider(create: (_) => Tab2Cubit()),
            BlocProvider(create: (_) => Tab3Cubit()),
          ],
          child: const AdminPage(),
        ),
        redirect: (_) {
          final dalalData = context.read<DalalBloc>().state as DalalDataLoaded;
          final user = dalalData.user;
          if (!user.isAdmin) return '/home';
          return null;
        },
      ),
    ],
    // Show snackbar and navigate to Home or Login page whenever UserState changes
    navigatorBuilder: (context, state, child) => DalalNavBuilder(
          routerState: state,
          child: child,
        ),
    redirect: (routerState) {
      final loggedIn = context.read<DalalBloc>().loggedIn;
      final userRoute = isUserRoute(routerState);
      if (loggedIn && !userRoute) {
        return '/home';
      } else if (!loggedIn && userRoute) {
        return '/';
      }
      return null;
    });

/// Returns if the route is for an authenticated user
bool isUserRoute(GoRouterState routerState) =>
    userRoutes.hasMatch(routerState.location);

/// Routes that can be accessed by only authenticated users
final userRoutes = [
  ...homeRoutesWeb,
  ...verifyRoutes,
  '/company/:id',
  '/admin',
];

bool isVerifyRoute(GoRouterState routerState) =>
    verifyRoutes.hasMatch(routerState.location);

final verifyRoutes = [
  '/enterPhone',
  '/enterOtp',
];

// TODO: Add redirects
final verifyGoRoutes = [
  GoRoute(
    path: '/enterPhone',
    builder: (_, __) => BlocProvider(
      create: (context) => EnterPhoneCubit(context.read()),
      child: EnterPhonePage(),
    ),
  ),
  GoRoute(
    path: '/enterOtp',
    builder: (_, state) => BlocProvider(
      create: (context) =>
          EnterOtpCubit(context.read(), state.extra! as String),
      child: const EnterOtpPage(),
    ),
  ),
];

final _initialRoutes = [
  GoRoute(
    path: '/',
    builder: (_, __) => const LandingPage(),
  ),
];

final _authRoutes = [
  GoRoute(
    path: '/login',
    builder: (_, __) => BlocProvider(
      create: (context) => LoginCubit(context.read()),
      child: LoginPage(),
    ),
  ),
  GoRoute(
    path: '/forgotPassword',
    builder: (_, __) => BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: ForgotPasswordPage(),
    ),
  ),
  GoRoute(
    path: '/resetPassword',
    builder: (_, __) => BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: ChangePasswordPage(),
    ),
  ),
  GoRoute(
    path: '/register',
    builder: (_, __) => BlocProvider(
      create: (context) => RegisterCubit(),
      child: RegisterPage(),
    ),
  ),
  GoRoute(
    path: '/checkMail',
    builder: (_, state) => BlocProvider(
      create: (_) => ResendMailCubit(),
      child: CheckMailPage(mail: state.extra! as String),
    ),
  ),
];
