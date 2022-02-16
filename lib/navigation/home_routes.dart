import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/news_subscription/news_subscription_cubit.dart';
import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/blocs/subscribe/subscribe_cubit.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/pages/daily_challenges/daily_challenges_page.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_home.dart';
import 'package:dalal_street_client/pages/news_page.dart';
import 'package:dalal_street_client/pages/referral_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final homeMenuMobile = {
  '/home': MenuItem('Home', AppIcons.home),
  '/portfolio': MenuItem('Portfolio', AppIcons.portfolio),
  '/exchange': MenuItem('DSE', AppIcons.rupee),
  '/ranking': MenuItem('Ranking', AppIcons.trophy),
};

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
final homeMenuWeb = _homeMenuMobileCopy..addAll(moreMenuMobile);

final homeRoutesMobile = homeMenuMobile.keys.toList();

final moreRoutesMobile = moreMenuMobile.keys.toList();

final homeRoutesWeb = homeRoutesMobile + moreRoutesMobile;

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
      '/openOrders': const Text('OpenOrders tbd'),
      '/referAndEarn': BlocProvider(
        create: (context) => ReferralCubit(),
        child: ReferralPage(user: extra),
      ),
      '/mediaPartners': const Text('Media partners tbd'),
      '/notifications': const Text('Notifications tbd'),
    };
