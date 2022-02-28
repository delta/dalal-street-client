import 'package:dalal_street_client/blocs/mortgage/mortgage_details/mortgage_details_cubit.dart';
import 'package:dalal_street_client/blocs/mortgage/mortgage_sheet/cubit/mortgage_sheet_cubit.dart';
import 'package:dalal_street_client/pages/mortgage/components/mortgage_table.dart';
import 'package:dalal_street_client/pages/mortgage/components/retrieve_table.dart';
import 'package:dalal_street_client/pages/mortgage/mortgage_page.dart';
import 'package:dalal_street_client/pages/mortgage/retrieve_page.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            primary: false,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Responsive(
              desktop: _desktopBody(context),
              mobile: _mobileBody(context),
              tablet: _tabletBody(),
            )),
      ),
    );
  }
}

Center _tabletBody() {
  return const Center(
    child: Text(
      'Tablet UI will design soon :)',
      style: TextStyle(
        fontSize: 14,
        color: secondaryColor,
      ),
    ),
  );
}

Widget _desktopBody(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _mortgageHomeWeb(context),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}

Widget _mortgageHomeWeb(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mortgage/Retrieve',
            style: TextStyle(
                fontSize: 48, fontWeight: FontWeight.w700, color: white),
            textAlign: TextAlign.end,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Carefully invest in the market to make some gains',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: lightGray),
            textAlign: TextAlign.end,
          ),
          const SizedBox(
            height: 10,
          ),
          _mortgageBodyWeb(context)
        ]),
  );
}

Widget _mortgageBodyWeb(BuildContext context) => DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: TabBar(
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    unselectedLabelColor: secondaryColor,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(color: primaryColor)),
                          child: const Text(
                            'Mortgage',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(color: primaryColor)),
                          child: const Text(
                            'Retrieve',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  BlocProvider(
                    create: (context) => MortgageSheetCubit(),
                    child: const MortgageTable(),
                  ),
                  MultiBlocProvider(providers: [
                    BlocProvider(create: (context) => MortgageDetailsCubit()),
                    BlocProvider(create: (context) => MortgageSheetCubit())
                  ], child: const RetrieveTable())
                ]),
          )
        ],
      ),
    );

Widget _mobileBody(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
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
    );

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
