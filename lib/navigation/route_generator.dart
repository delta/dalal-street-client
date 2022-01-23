import 'package:dalal_street_client/blocs/auth/forgot_password/forgot_password_cubit.dart';
import 'package:dalal_street_client/blocs/admin/add_daily_challenge/add_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/add_market_event/add_market_event_cubit.dart';
import 'package:dalal_street_client/blocs/admin/add_stocks_to_exchange/add_stocks_to_exchange_cubit.dart';
import 'package:dalal_street_client/blocs/admin/block_user/block_user_cubit.dart';
import 'package:dalal_street_client/blocs/admin/close_daily_challenge/close_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/close_market/close_market_cubit.dart';
import 'package:dalal_street_client/blocs/admin/inspect_user/inspect_user_cubit.dart';
import 'package:dalal_street_client/blocs/admin/load_stocks/load_stocks_cubit.dart';
import 'package:dalal_street_client/blocs/admin/open_daily_challenge/open_daily_challenge_cubit.dart';
import 'package:dalal_street_client/blocs/admin/open_market/open_market_cubit.dart';
import 'package:dalal_street_client/blocs/admin/send_dividends/send_dividends_cubit.dart';
import 'package:dalal_street_client/blocs/admin/send_notifications/send_notifications_cubit.dart';
import 'package:dalal_street_client/blocs/admin/set_bankruptcy/set_bankruptcy_cubit.dart';
import 'package:dalal_street_client/blocs/admin/set_gives_dividends/set_gives_dividends_cubit.dart';
import 'package:dalal_street_client/blocs/admin/set_market_day/set_market_day_cubit.dart';
import 'package:dalal_street_client/blocs/admin/unblock_all_users/unblock_all_users_cubit.dart';
import 'package:dalal_street_client/blocs/admin/unblock_user/unblock_user_cubit.dart';
import 'package:dalal_street_client/blocs/admin/update_end_of_day_values/update_end_of_day_values_cubit.dart';
import 'package:dalal_street_client/blocs/admin/update_stock_price/update_stock_price_cubit.dart';
import 'package:dalal_street_client/blocs/auth/login/login_cubit.dart';
import 'package:dalal_street_client/pages/admin_page.dart';
import 'package:dalal_street_client/blocs/admin/send_news/send_news_cubit.dart';
import 'package:dalal_street_client/blocs/auth/register/register_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/blocs/auth/verify_phone/enter_phone/enter_phone_cubit.dart';
import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/market_depth/market_depth_bloc.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home.dart';
import 'package:dalal_street_client/pages/auth/check_mail_page.dart';
import 'package:dalal_street_client/pages/auth/forgot_password_page.dart';
import 'package:dalal_street_client/pages/auth/login_page.dart';
import 'package:dalal_street_client/pages/auth/register_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_otp_page.dart';
import 'package:dalal_street_client/pages/auth/verify_phone/enter_phone_page.dart';
import 'package:dalal_street_client/pages/company_page/company_page.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenges_page.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_home.dart';
import 'package:dalal_street_client/pages/news_page.dart';
import 'package:dalal_street_client/pages/referral_page.dart';
import 'package:dalal_street_client/pages/stock_exchange/exchange_page.dart';
import 'package:dalal_street_client/pages/landing_page.dart';
import 'package:dalal_street_client/pages/splash_page.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';

import '../blocs/news/news_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      final page = _getPage(settings);
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    } catch (e) {
      return _errorRoute(e.toString());
    }
  }

  static Widget _getPage(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return const SplashPage();
      case '/landing':
        return const LandingPage();

      //Admin Pages
      case '/admin':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SendNewsCubit(),
            ),
            BlocProvider(
              create: (context) => SendNotificationsCubit(),
            ),
            BlocProvider(
              create: (context) => BlockUserCubit(),
            ),
            BlocProvider(
              create: (context) => SendDividendsCubit(),
            ),
            BlocProvider(
              create: (context) => OpenMarketCubit(),
            ),
            BlocProvider(
              create: (context) => CloseMarketCubit(),
            ),
            BlocProvider(
              create: (context) => UpdateEndOfDayValuesCubit(),
            ),
            BlocProvider(
              create: (context) => LoadStocksCubit(),
            ),
            BlocProvider(
              create: (context) => AddStocksToExchangeCubit(),
            ),
            BlocProvider(
              create: (context) => UpdateStockPriceCubit(),
            ),
            BlocProvider(
              create: (context) => AddMarketEventCubit(),
            ),
            BlocProvider(
              create: (context) => SetGivesDividendsCubit(),
            ),
            BlocProvider(
              create: (context) => SetBankruptcyCubit(),
            ),
            BlocProvider(
              create: (context) => SetMarketDayCubit(),
            ),
            BlocProvider(
              create: (context) => InspectUserCubit(),
            ),
            BlocProvider(
              create: (context) => UnblockUserCubit(),
            ),
            BlocProvider(
              create: (context) => UnblockAllUsersCubit(),
            ),
            BlocProvider(
              create: (context) => OpenDailyChallengeCubit(),
            ),
            BlocProvider(
              create: (context) => CloseDailyChallengeCubit(),
            ),
            BlocProvider(
              create: (context) => AddDailyChallengeCubit(),
            ),
          ],
          child: const AdminPage(),
        );

      // Auth Pages
      case '/login':
        return BlocProvider(
          create: (context) => LoginCubit(context.read()),
          child: LoginPage(),
        );
      case '/referral':
        if (args is User) {
          return BlocProvider(
            create: (context) => ReferralCubit(),
            child: ReferralPage(user: args),
          );
        }
        throw Exception('Invalid user args');

      case '/forgotPassword':
        return BlocProvider(
          create: (context) => ForgotPasswordCubit(),
          child: ForgotPasswordPage(),
        );
      case '/register':
        return BlocProvider(
            create: (context) => RegisterCubit(), child: RegisterPage());

      case '/checkMail':
        if (args is String) {
          return CheckMailPage(mail: args);
        }
        throw Exception('Invalid args in check mail page');
      // Verify Phone Pages
      case '/enterPhone':
        return BlocProvider(
          create: (context) => EnterPhoneCubit(context.read()),
          child: EnterPhonePage(),
        );
      case '/enterOtp':
        if (args is String) {
          return BlocProvider(
            create: (context) => EnterOtpCubit(context.read(), args),
            child: const EnterOtpPage(),
          );
        }
        throw Exception('Invalid phone args');

      case '/news':
        return MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => NewsBloc(),
          ),
          BlocProvider(create: (context) => SubscribeCubit())
        ], child: const NewsPage());

      // Home Pages
      case '/home':
        if (args is User) {
          return DalalHome(user: args);
        }
        throw Exception('Invalid user args');

      case '/dailyChallenges':
        return BlocProvider(
          create: (context) =>
              DailyChallengesPageCubit()..getChallengesConfig(),
          child: const DailyChallengesPage(),
        );
      // Company Page
      case '/company':
        if (args is List<int>) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MarketDepthBloc(),
              ),
              BlocProvider(
                create: (context) => SubscribeCubit(),
              ),
            ],
            child: CompanyPage(data: args),
          );
        }
        throw Exception('Invalid company or user args' + args.toString());

      // Stock Exchange Page
      case '/exchange':
        return BlocProvider(
          create: (context) => ExchangeCubit(),
          child: const ExchangePage(),
        );
      // Portfolio Page
      case '/portfolio':
        return BlocProvider(
          create: (context) => PortfolioCubit(),
          child: const PortfolioPage(),
        );
      // Mortgage page
      case '/mortgage':
        return const MortgageHome();
      default:
        throw Exception('Invalid Route');
    }
  }

  static Route<dynamic> _errorRoute(String msg) => MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Error Page')),
          body: Center(
            child: Text(msg),
          ),
        ),
      );
}
