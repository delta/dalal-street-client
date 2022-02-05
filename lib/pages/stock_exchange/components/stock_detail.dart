import 'package:dalal_street_client/blocs/list_selection/list_selection_cubit.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockDetail extends StatefulWidget {
  const StockDetail({Key? key}) : super(key: key);

  @override
  _StockDetailState createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListSelectedItemCubit, ListSelectedItemState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: background3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('${state.selectedItem}')],
          ),
        );
      },
    );
  }
}
