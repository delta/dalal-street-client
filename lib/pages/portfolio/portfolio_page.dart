import 'package:dalal_street_client/blocs/portfolio/userWorth/portfolio_cubit.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_userworth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_transactions.dart';
import 'package:dalal_street_client/blocs/portfolio/transactions/portfolio_transactions_cubit.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_userworth_web.dart';
import 'package:dalal_street_client/pages/portfolio/portfolio_transactions_web.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

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

  SingleChildScrollView _desktopPortfolio() {
    return SingleChildScrollView(
      child: SizedBox(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                const PortfolioUserWorthWeb(),
                SizedBox(
                  height: 25,
                ),
                BlocProvider(
                    create: (context) => PortfolioTransactionsCubit(),
                    child: const UserTransactionsWeb())
              ],
            ),
          ),
        ],
      )),
    );
  }

  SingleChildScrollView _tabletPortfolio() {
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
                  child: const UserTransactions())
            ],
          ),
        ),
      ],
    ));
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
                  child: const UserTransactions())
            ],
          ),
        ),
      ],
    ));
  }
}
