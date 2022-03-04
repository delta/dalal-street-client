import 'package:dalal_street_client/blocs/mortgage/mortgage_details/mortgage_details_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/pages/mortgage/components/retrieve_stock_item.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RetrievePage extends StatefulWidget {
  const RetrievePage({Key? key}) : super(key: key);

  @override
  _RetrievePageState createState() => _RetrievePageState();
}

class _RetrievePageState extends State<RetrievePage> {
  Map<int, Stock> mapOfStocks = getIt<GlobalStreams>().latestStockMap;
  @override
  void initState() {
    super.initState();
    context.read<MortgageDetailsCubit>().getMortgageDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: _retrieveBody(),
    );
  }

  Widget _retrieveBody() {
    return BlocBuilder<MortgageDetailsCubit, MortgageDetailsState>(
      builder: (context, state) {
        if (state is MortgageDetailsLoaded) {
          if (state.mortgageDetails.isEmpty) {
            return const Center(
              child: Text('No mortgaged Stocks'),
            );
          }
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: state.mortgageDetails.length,
            itemBuilder: (context, index) {
              int stockId = state.mortgageDetails[index].stockId;
              return RetrieveStockItem(
                  company: mapOfStocks[stockId]!,
                  mortgageDetail: state.mortgageDetails[index],
                  onViewClicked: _navigateToCompanyPage);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          );
        } else if (state is MortgageDetailsLoading) {
          return const Center(
            child: DalalLoadingBar(),
          );
        } else {
          return const Center(
            child: Text('Failed to load data'),
          );
        }
      },
    );
  }

  void _navigateToCompanyPage(int stockId) => context.push('/company/$stockId');
}
