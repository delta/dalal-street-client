import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/ipo/ipo_cubit.dart';
import 'package:dalal_street_client/blocs/my_orders/my_orders_cubit.dart';
import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenges_page.dart';
import 'package:dalal_street_client/pages/ipo_page.dart';
import 'package:dalal_street_client/pages/mediapartners_page.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_home.dart';
import 'package:dalal_street_client/pages/news/news_page.dart';
import 'package:dalal_street_client/pages/notifications_page.dart';
import 'package:dalal_street_client/pages/open_orders/open_orders_page.dart';
import 'package:dalal_street_client/pages/referral_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ipo_orders/ipo_orders_cubit.dart';

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
  // '/ipo': MenuItem('IPO', AppIcons.ipo),
  '/mortgage': MenuItem('Mortgage', AppIcons.mortgage),
  '/dailyChallenges': MenuItem('Daily Challenges', AppIcons.dailyChallenges),
  '/openOrders': MenuItem('Open Orders', AppIcons.openOrders),
  '/referAndEarn': MenuItem('Refer and Earn', AppIcons.referAndEarn),
  '/mediaPartners': MenuItem('Media Partners', AppIcons.speaker),
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

/// Widgets for routes in more section in mobile
Map<String, Widget> mobileHomePagesMore(User extra) => {
      '/news': const NewsPageWrapper(),
      // '/ipo': MultiBlocProvider(providers: [
      //   BlocProvider(create: (context) => IpoCubit()),
      //   BlocProvider(create: (context) => IpoOrdersCubit())
      // ], child: const IpoPage()),
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
      '/mediaPartners': const MediaPartners(),
      '/notifications': BlocProvider(
        create: ((context) => NotificationsCubit()),
        child: const NotificationsPage(),
      ),
    };
