import 'package:dalal_street_client/blocs/exchange/exchange_cubit.dart';
import 'package:dalal_street_client/blocs/exchange/sheet/exchange_sheet_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/constants/format.dart';
import 'package:dalal_street_client/constants/icons.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/pages/company_page/components/market_status_tile.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StockDetail extends StatefulWidget {
  final Stock company;
  final void Function(int stockId) onKnowMoreClicked;
  const StockDetail(
      {Key? key, required this.company, required this.onKnowMoreClicked})
      : super(key: key);

  @override
  _StockDetailState createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  int quantity = 1;
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: background3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _companyStaticDetails(widget.company),
          const SizedBox(
            height: 20,
          ),
          _marketStatus(widget.company),
          const SizedBox(
            height: 20,
          ),
          _stockExchangeDetails(widget.company),
          const SizedBox(
            height: 20,
          ),
          _buyFromExchangeFooter(widget.company)
        ],
      ),
    );
  }

  Widget _companyStaticDetails(Stock company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 60,
                  width: 100,
                  child: Image.asset(
                    'assets/images/DalalImage.png',
                    fit: BoxFit.contain,
                  ),
                )),
            const SizedBox(
              width: 20,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    company.shortName,
                    style: const TextStyle(fontSize: 24, color: white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    company.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: whiteWithOpacity50,
                    ),
                  ),
                ]),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            company.description.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: lightGray,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _marketStatus(Stock company) {
    final dayHighStream =
        getIt<GlobalStreams>().stockMapStream.dayHighStream(company.id);
    final dayLowStream =
        getIt<GlobalStreams>().stockMapStream.dayLowStream(company.id);
    final allTimeHighStream =
        getIt<GlobalStreams>().stockMapStream.allTimeHighStream(company.id);
    final allTimeLowStream =
        getIt<GlobalStreams>().stockMapStream.allTimeLowStream(company.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Market Status',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: white,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<Int64>(
            stream: dayHighStream,
            initialData: company.dayHigh,
            builder: (context, state) {
              return marketStatusTile(AppIcons.dayHigh, 'Day High',
                  oCcy.format(state.data).toString(), false, true);
            }),
        StreamBuilder<Int64>(
            stream: dayLowStream,
            initialData: company.dayLow,
            builder: (context, state) {
              return marketStatusTile(AppIcons.dayHigh, 'Day Low',
                  oCcy.format(state.data).toString(), true, true);
            }),
        StreamBuilder<Int64>(
            stream: allTimeHighStream,
            initialData: company.allTimeHigh,
            builder: (context, state) {
              return marketStatusTile(AppIcons.alltimeHigh, 'All Time High',
                  oCcy.format(state.data).toString(), false, true);
            }),
        StreamBuilder<Int64>(
            stream: allTimeLowStream,
            initialData: company.allTimeLow,
            builder: (context, state) {
              return marketStatusTile(AppIcons.alltimeHigh, 'All Time Low',
                  oCcy.format(state.data).toString(), true, true);
            }),
      ],
    );
  }

  Widget _stockExchangeDetails(Stock company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Exchange',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: white,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<ExchangeCubit, ExchangeState>(
          builder: (context, state) {
            if (state is ExchangeDataLoaded) {
              int stockId = company.id;
              int stocksInMarket =
                  state.exchangeData[stockId]?.stocksInMarket.toInt() ??
                      (mapOfStocks[stockId]?.stocksInMarket.toInt() ?? 0);
              mapOfStocks[stockId]?.stocksInMarket = Int64(stocksInMarket);
              int stocksInExchange =
                  state.exchangeData[stockId]?.stocksInExchange.toInt() ??
                      (mapOfStocks[stockId]?.stocksInExchange.toInt() ?? 0);
              mapOfStocks[stockId]?.stocksInExchange = Int64(stocksInExchange);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 14,
                          children: [
                            SvgPicture.asset(
                              AppIcons.stockMarket,
                              width: 18,
                            ),
                            const Text(
                              'Stocks in Market',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: lightGray,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(
                          stocksInMarket.toString(),
                          style: const TextStyle(
                            color: bronze,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 14,
                          children: [
                            SvgPicture.asset(
                              AppIcons.stockExchange,
                              width: 18,
                            ),
                            const Text(
                              'Stocks in Exchange',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: lightGray,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(stocksInExchange.toString(),
                            style: const TextStyle(
                              color: gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start)
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 14,
                        children: [
                          SvgPicture.asset(
                            AppIcons.stockMarket,
                            width: 18,
                          ),
                          const Text(
                            'Stocks in Market',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: lightGray,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Text(company.stocksInMarket.toString(),
                          style: const TextStyle(
                              color: bronze,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 14,
                        children: [
                          SvgPicture.asset(
                            AppIcons.stockMarket,
                            width: 18,
                          ),
                          const Text(
                            'Stocks in Exchange',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: lightGray,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Text(company.stocksInExchange.toString(),
                          style: const TextStyle(
                              color: gold,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buyFromExchangeFooter(Stock company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Buy from Exchange',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: white,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Number of Stocks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: lightGray,
              ),
            ),
            Container(
              height: 40,
              width: 180,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: primaryColor.withOpacity(0.2),
              ),
              child: SpinBox(
                min: 1,
                max: 30,
                value: 01,
                onChanged: (value) {
                  quantity = value as int;
                },
                decoration: const InputDecoration(border: InputBorder.none),
                iconColor: MaterialStateProperty.all(primaryColor),
                spacing: 15,
                cursorColor: primaryColor,
                textStyle: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
            )
          ]),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
                onPressed: () => widget.onKnowMoreClicked(widget.company.id),
                child: const Text('Know More')),
            const SizedBox(
              width: 40,
            ),
            BlocProvider(
              create: (context) => ExchangeSheetCubit(),
              child: BlocConsumer<ExchangeSheetCubit, ExchangeSheetState>(
                listener: (context, state) {
                  if (state is ExchangeSheetSuccess) {
                    showSnackBar(context,
                        'Successfully bought $quantity ${company.fullName} stocks',
                        type: SnackBarType.success);
                  } else if (state is ExchangeSheetFailure) {
                    showSnackBar(context, state.msg, type: SnackBarType.error);
                  }
                },
                builder: (context, state) {
                  if (state is ExchangeSheetLoading) {
                    return const Center(child: DalalLoadingBar());
                  }
                  return ElevatedButton(
                    onPressed: () =>
                        _buyStocksFromExchange(context, company.id, quantity),
                    child: const Text('Buy'),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  void _buyStocksFromExchange(BuildContext context, int stockId, int quantity) {
    context.read<ExchangeSheetCubit>().buyStocksFromExchange(stockId, quantity);
  }
}
