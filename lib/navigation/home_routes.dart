import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/news_subscription/news_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenges_page.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_home.dart';
import 'package:dalal_street_client/pages/news_page.dart';
import 'package:dalal_street_client/pages/notifications_page.dart';
import 'package:dalal_street_client/pages/openorders_page.dart';
import 'package:dalal_street_client/pages/referral_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Home Menu items for mobile
final homeMenuMobile = {
  '/home': MenuItem('Home', AppIcons.home),
  '/portfolio': MenuItem('Portfolio', AppIcons.portfolio),
  '/exchange': MenuItem('DSE', AppIcons.rupee),
  '/ranking': MenuItem('Ranking', AppIcons.trophy),
};

/// Home Menu items in more section for mobile
final moreMenuMobile = {
  '/news': MenuItem('News', AppIcons.news),
  '/mortgage': MenuItem('Mortgage', AppIcons.mortgage),
  '/dailyChallenges': MenuItem('Daily Challenges', AppIcons.dailyChallenges),
  '/openOrders': MenuItem('Open Orders', AppIcons.openOrders),
  '/referAndEarn': MenuItem('Refer and Earn', AppIcons.referAndEarn),
  '/mediaPartners': MenuItem('Media Partners', AppIcons.mobileAd),
  '/notifications': MenuItem('Notifications', AppIcons.notificationBell),
};

// Sorry for wierd hack. Dart sucks
final _homeMenuMobileCopy = {
  '/home': MenuItem('Home', AppIcons.home),
  '/portfolio': MenuItem('Portfolio', AppIcons.portfolio),
  '/exchange': MenuItem('DSE', AppIcons.rupee),
  '/ranking': MenuItem('Ranking', AppIcons.trophy),
};

/// Home Menu items for web
final homeMenuWeb = _homeMenuMobileCopy..addAll(moreMenuMobile);

/// Home routes for mobile
final homeRoutesMobile = homeMenuMobile.keys.toList();

/// More section routes for mobile
final moreRoutesMobile = moreMenuMobile.keys.toList();

/// Home routes for web
final homeRoutesWeb = homeRoutesMobile + moreRoutesMobile;

/// Routes not directly in home page, but accesed by only authenticated users
final otherNonAuthRoutes = ['/company'];

/// Widgets for routes in more section in mobile
Map<String, Widget> mobileHomePagesMore(User extra) => {
      '/news': MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NewsBloc()),
          BlocProvider(create: (context) => SubscribeCubit()),
          BlocProvider(
            create: (context) => NewsSubscriptionCubit(),
          )
        ],
        child: const NewsPage(),
      ),
      '/mortgage': const MortgageHome(),
      '/dailyChallenges': BlocProvider(
        create: (context) => DailyChallengesPageCubit()..getChallengesConfig(),
        child: const DailyChallengesPage(),
      ),
      '/openOrders': BlocProvider(
        create: (context) => MyOrdersCubit(),
        child: const OpenOrdersPage(),
      ),
      '/referAndEarn': BlocProvider(
        create: (context) => ReferralCubit(),
        child: ReferralPage(user: extra),
      ),
      '/notifications': BlocProvider(
        create: ((context) => NotificationsCubit()),
        child: const NotificationsPage(),
      ),
      '/mediaPartners': const Text('Media partners tbd'),
    };
