import 'package:dalal_street_client/blocs/portfolio/open_orders/open_orders_cubit.dart';
import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/pages/openorders_page.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_userworth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_transactions.dart';
import 'package:dalal_street_client/blocs/portfolio/transactions/portfolio_transactions_cubit.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<PortfolioCubit>().getPortfolio();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Responsive(
              desktop: _desktopPortfolio(),
              tablet: _tabletPortfolio(),
              mobile: _mobilePortfolio())),
    );
  }

  Center _desktopPortfolio() {
    return const Center(
      child: Text(
        'Soon',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  Center _tabletPortfolio() {
    return const Center(
      child: Text(
        'Soon',
        style: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
    );
  }

  SingleChildScrollView _mobilePortfolio() {
    return SingleChildScrollView(
        child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              const PortfolioUserWorth(),
              BlocProvider(
                  create: (context) => PortfolioTransactionsCubit(),
                  child: const UserTransactions()),
            ],
          ),
        ),
      ],
    ));
  }
}
