import 'package:dalal_street_client/blocs/companies/companies_bloc.dart';
import 'package:dalal_street_client/blocs/user/user_bloc.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/theme/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context)
        .add(const Subscribe(DataStreamType.STOCK_PRICES));
  }

// [TODO] : Remove print statements
  @override
  Widget build(context) => SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    color: backgroundColor2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Home',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: whiteWithOpacity75),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Top Companies',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => CompaniesBloc(),
                            ),
                          ],
                          child: BlocListener<UserBloc, UserState>(
                              listener: (context, state) {
                            if (state is SubscriptionDataLoaded) {
                              SubscriptionId subscriptionId =
                                  state.subscriptionId;
                              // ignore: avoid_print, unnecessary_string_interpolations
                              print(subscriptionId);
                              context
                                  .read<CompaniesBloc>()
                                  .add(SubscribeToStockPrices(subscriptionId));
                            } else if (state is SubscriptonDataFailed) {
                              // ignore: avoid_print
                              print('Stock Prices Stream Failed $state');
                            }
                          }, child: BlocBuilder<CompaniesBloc, CompaniesState>(
                            builder: (context, state) {
                              if (state is SubscriptionToStockPricesSuccess) {
                                return Flexible(
                                  child: ListView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      'AIRTEL',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Bharti Airtel Ltd',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            whiteWithOpacity75,
                                                      ),
                                                    ),
                                                  ]),
                                              Image.network(
                                                  'https://i.imgur.com/zrmdl8j.png'),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      '1,569.34',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      '+25.12',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: secondaryColor,
                                                      ),
                                                    ),
                                                  ])
                                            ])),
                                  ),
                                );
                              } else if (state
                                  is SubscriptionToStockPricesFailed) {
                                return const Center(
                                  child: Text(
                                    'Failed to load data \nReason : //',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
