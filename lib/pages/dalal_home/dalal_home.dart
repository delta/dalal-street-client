import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_bottom_sheet.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_nav_bar.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:dalal_street_client/pages/leaderboard_page/leaderboard_page.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_page.dart';
import 'package:dalal_street_client/pages/stock_exchange/exchange_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DalalHome extends StatefulWidget {
  final User user;

  const DalalHome({Key? key, required this.user}) : super(key: key);

  @override
  State<DalalHome> createState() => _DalalHomeState(user);
}

class _DalalHomeState extends State<DalalHome> {
  final User user;
  _DalalHomeState(this.user);
  final _bottomMenu = {
    'Home': AppIcons.home,
    'Portfolio': AppIcons.portfolio,
    'DSE': AppIcons.rupee,
    'Ranking': AppIcons.trophy,
    'More': AppIcons.hamburger,
  };

  final _sheetMenu = {
    'News': AppIcons.news,
    'Mortgage': AppIcons.mortgage,
    'Daily Challenges': AppIcons.dailyChallenges,
    'Open Orders': AppIcons.openOrders,
    'Refer and Earn': AppIcons.referAndEarn,
    'Media Partners': AppIcons.mobileAd,
    'Notifications': AppIcons.notificationBell,
  };

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> get _pageViewChildren => [
        HomePage(user: widget.user),
        BlocProvider(
          create: (context) => PortfolioCubit(),
          child: const PortfolioPage(),
        ),
        BlocProvider(
          create: (context) => ExchangeCubit(),
          child: const ExchangePage(),
        ),
        const LeaderboardPage()
      ];

  List<String> get _sheetPageRoutes => [
        '/news',
        '/mortgage',
        '/dailyChallenges',
        '/openOrders',
        '/referAndEarn',
        '/mediaPartners',
        '/notifications'
      ];

  @override
  build(context) => SafeArea(
        child: Scaffold(
          appBar: const StockBar(),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pageViewChildren,
          ),
          bottomNavigationBar: DalalHomeNavBar(
            menu: _bottomMenu,
            onItemSelect: (index) => _pageController.jumpToPage(index),
            onItemReselect: (index) => logger.d('$index reselected'),
            onMoreClick: _showHomeBottomSheet,
          ),
        ),
      );

  void _showHomeBottomSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: background2,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (_) => DalalHomeBottomSheet(
          items: _sheetMenu,
          onItemClick: (index) {
            if (_sheetPageRoutes[index].compareTo('/referAndEarn') == 0) {
              Navigator.of(context)
                  .pushNamed(_sheetPageRoutes[index], arguments: user);
            } else {
              Navigator.of(context).pushNamed(_sheetPageRoutes[index]);
            }
          },
        ),
      );
}
