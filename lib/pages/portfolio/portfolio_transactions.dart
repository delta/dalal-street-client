import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalal_street_client/blocs/portfolio/transactions/portfolio_transactions_cubit.dart';
import 'package:dalal_street_client/utils/transaction_to_str.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';


class UserTransactions extends StatefulWidget {
  const UserTransactions({Key? key}) : super(key: key);

  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  List transactions = [];
  @override
  void initState() {
    super.initState();
    context.read<PortfolioTransactionsCubit>().listenToTransactionStream(0);
  }

  @override
  Widget build(BuildContext context) => _transactionsContainer();

  Widget _transactionsContainer() =>
      BlocBuilder<PortfolioTransactionsCubit, PortfolioTransactionsState>(
          builder: (context, state) {
        if (state is PortfolioTransactionsLoaded) {
          transactions.addAll(state.transactions);
          var lastId = state.transactions.last.id;
          bool moreExists = state.moreExists;
          String loadMore = moreExists? 'Load More ↻':'';
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: background2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    const Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                    ),
                    _transactionBody(
                        transactions.length, transactions),
                        const SizedBox(
                      height: 10,
                      ),
                        GestureDetector(
                          onTap: (() => {
                            context.read<PortfolioTransactionsCubit>().listenToTransactionStream(lastId-1)
                          }),
                          child: Text(  
                          loadMore,
                        style: const TextStyle(
                          fontStyle:FontStyle.italic,
                          fontSize: 15,
                          color: blue
                        ),
                        ),)
                  ]));
        } else if (state is PortfolioTransactionsError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Text('');
      });

  Widget _transactionBody(int count, dynamic transactions) => ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        dynamic type = transactions[index].type;
        var qty = transactions[index].stockQuantity;
        var price = transactions[index].price;
        var cash = transactions[index].total;
        int stockId = transactions[index].stockId;
        var reservedCash = transactions[index].reservedCashTotal;
        var reservedStocks = transactions[index].reservedStockQuantity;
        var transactionTime = transactions[index].createdAt;
        return _singleTransaction(
            type, qty, price, cash, stockId, reservedCash, reservedStocks,transactionTime);
      });

  _singleTransaction(dynamic type, var qty, var price, var cash, int stockId,
      var reservedCash, var reservedStocks, var transactionTime) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: blurredGray))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 5, top: 10),
                child: Text(
                  mapOfStocks[stockId]?.fullName.toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Type',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(
                    transactionTypeToStr(type),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Qty',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(
                    qty.toString(),
                    style:
                        TextStyle(color: qty > 0 ? secondaryColor : heartRed),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Trade Price',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(price == 0 ? '-' : price.toString())
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Cash',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(
                    cash.toString(),
                    style:
                        TextStyle(color: cash > 0 ? secondaryColor : heartRed),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Reserved Cash',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(reservedCash.toString())
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Reserved Stocks',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(reservedStocks.toString())
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Created At',
                        style: TextStyle(color: blurredGray),
                      )),
                  Text(
                    ISOtoDateTime(transactionTime)
                  )
                ],
              ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
