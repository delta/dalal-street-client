import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/market_event/events/market_event_cubit.dart';
import 'package:dalal_street_client/blocs/notification/notifications_cubit.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/menu_item.dart';
import 'package:dalal_street_client/navigation/home_routes.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_home_bottom_sheet.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_bottom_bar.dart';
import 'package:dalal_street_client/pages/dalal_home/dalal_sidebar.dart';
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

/// The main home widget, with bottom bar or side bar based on mobile or web, to
/// navigate between different screens in Dalal Street.
///
/// The different screens based on selected item are shown using [PageView],
/// without any scrolling animation
///
/// The current menu item is determined using [route] field
/// Example: In dalalstreet.com/portfolio, route is '/portfolio'
class DalalHome extends StatefulWidget {
  final User user;
  final String route;

  const DalalHome({Key? key, required this.user, required this.route})
      : super(key: key);

  @override
  State<DalalHome> createState() => _DalalHomeState();
}

/// State for [DalalHome]
///
/// Checkout https://gorouter.dev/nested-navigation to understand how url is
/// changed and web history is maintained when switching between pages
///
/// In short:
/// - Whenever a new item is selected, we do `context.go(newRoute)`
/// - When the page is rebuilt with change in route, [didUpdateWidget] is called
/// - So in [didUpdateWidget], update the bottom/side bar selection and the [PageView] item
class _DalalHomeState extends State<DalalHome> {
  MenuItem get _logoutItem => MenuItem('Logout', AppIcons.logout);

  final _bottomMenu = homeMenuMobile.values.toList();

  final _sideMenu = homeMenuWeb.values.toList();

  List<MenuItem> get _sheetMenu =>
      moreMenuMobile.values.toList() + [_logoutItem];

  List<String> get _homeRoutes => kIsWeb ? homeRoutesWeb : homeRoutesMobile;

  List<String> get _sheetRoutes => moreRoutesMobile;

  int get currentMenuItem => pageViewIndexForRoute(widget.route);

  int pageViewIndexForRoute(String route) {
    final index = _homeRoutes.indexOf(route);
    if (index == -1) {
      logger.e('Invalid page route sent to DalalHome: $route');
      return 0;
    }
    return index;
  }

  late PageController _pageController;

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
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MarketEventCubit()),
            BlocProvider(create: (context) => NotificationsCubit()),
          ],
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
          body: body(),
          bottomNavigationBar: !kIsWeb
              ? DalalBottomBar(
                  menu: _bottomMenu,
                  currentIndex: currentMenuItem,
                  onItemSelect: (index) =>
                      _onMenuItemSelect(_homeRoutes[index]),
                  // TODO: can let the page know of reselection, and do some behaviour
                  // Example: scroll to top of list, like in insta
                  onItemReselect: (index) => {},
                  onMoreClick: _showHomeBottomSheet,
                )
              : null,
        ),
      );

  Widget body() {
    final content = PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _pageViewChildren,
    );
    if (!kIsWeb) return content;
    return DalalSideBar(
      menu: _sideMenu,
      currentIndex: currentMenuItem,
      onItemSelect: (index) => _onMenuItemSelect(_homeRoutes[index]),
      onItemReselect: (index) {},
      body: content,
    );
  }

  void _onMenuItemSelect(String route) => context.go(route);

  void _showHomeBottomSheet() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: background2,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (_) => DalalHomeBottomSheet(
          items: _sheetMenu,
          onItemClick: (index) {
            if (index != _sheetMenu.length - 1) {
              context.push(_sheetRoutes[index]);
            } else {
              _onLogoutClick();
            }
          },
        ),
      );

  void _onLogoutClick() {
    logger.e('logout');
  }
}
