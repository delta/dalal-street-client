import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/navigation/home_routes.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_bottom_sheet.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_nav_bar.dart';
import 'package:dalal_street_client/pages/home_page.dart';
import 'package:dalal_street_client/pages/leaderboard_page/leaderboard_page.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_page.dart';
import 'package:dalal_street_client/pages/stock_exchange/exchange_page.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DalalHome extends StatefulWidget {
  final User user;
  final String route;

  const DalalHome({Key? key, required this.user, required this.route})
      : super(key: key);

  @override
  State<DalalHome> createState() => _DalalHomeState();
}

class _DalalHomeState extends State<DalalHome> {
  List<String> get _homeRoutes => kIsWeb ? homeRoutesWeb : homeRoutesMobile;

  List<String> get _sheetPageRoutes => moreRoutesMobile;

  int get currentMenuItem => pageViewIndexForRoute(widget.route);

  final _bottomMenu = homeMenuMobile;

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

  int pageViewIndexForRoute(String route) {
    final index = _homeRoutes.indexOf(route);
    if (index == -1) {
      logger.e('Invalid page route sent to DalalHome');
      return 0;
    }
    return index;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentMenuItem);
  }

  @override
  void didUpdateWidget(covariant DalalHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pageController.jumpToPage(currentMenuItem);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> get _pageViewChildren => [
        BlocProvider(
          create: (context) => NewsBloc(),
          child: HomePage(user: widget.user),
        ),
        BlocProvider(
          create: (context) => PortfolioCubit(),
          child: const PortfolioPage(),
        ),
        BlocProvider(
          create: (context) => ExchangeCubit(),
          child: const ExchangePage(),
        ),
        const LeaderboardPage(),
        ...mobileHomePagesMore(widget.user).values,
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
            currentIndex: currentMenuItem,
            onItemSelect: _onHomeItemSelect,
            // TODO: can let the page know of reselection, and do some behaviour
            // Example: scroll to top of list, like in insta
            onItemReselect: (index) => {},
            onMoreClick: _showHomeBottomSheet,
          ),
        ),
      );

  void _onHomeItemSelect(int index) => context.go(_homeRoutes[index]);

  void _showHomeBottomSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: background2,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (_) => DalalHomeBottomSheet(
          items: _sheetMenu,
          onItemClick: (index) => context.push(_sheetPageRoutes[index]),
        ),
      );
}
