import 'package:dalal_street_client/blocs/mortgage/mortgage_details/mortgage_details_cubit.dart';
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
              desktop: _desktopBody(),
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

Widget _desktopBody() {
  List<String> mortgageMap = ['Mortgage', 'Retrieve'];
  var selectedPage = 'Mortgage';
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: 300,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                isExpanded: true,
                value: selectedPage,
                iconSize: 48,
                icon: const Icon(Icons.arrow_drop_down, color: white),
                items: mortgageMap.map((type) {
                  return DropdownMenuItem(
                    child: Text(
                      type,
                      style: const TextStyle(fontSize: 42, color: white),
                    ),
                    value: type,
                  );
                }).toList(),
                onChanged: (newValue) {}),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    ),
  );
}

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
}
