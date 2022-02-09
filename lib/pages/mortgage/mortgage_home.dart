import 'package:dalal_street_client/blocs/mortgage/mortgage_details/mortgage_details_cubit.dart';
import 'package:dalal_street_client/components/stock_bar.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_page.dart';
import 'package:dalal_street_client/pages/mortgage/retrieve_page.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MortgageHome extends StatefulWidget {
  const MortgageHome({Key? key}) : super(key: key);

  @override
  _MortgageHomeState createState() => _MortgageHomeState();
}

class _MortgageHomeState extends State<MortgageHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const StockBar(),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Mortgage/Retrieve',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              _mortgageTabView(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _mortgageTabView(BuildContext context) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Mortgage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Tab(
                  child: Text(
                    'Retrieve',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: lightGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              indicatorColor: lightGray,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: MediaQuery.of(context).size.height * 0.8,
              child: TabBarView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    const MortgagePage(),
                    BlocProvider(
                      create: (context) => MortgageDetailsCubit(),
                      child: const RetrievePage(),
                    )
                  ]),
            )
          ],
        ),
      ));
}
