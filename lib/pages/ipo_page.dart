import 'package:dalal_street_client/blocs/ipo/ipo_cubit.dart';
import 'package:dalal_street_client/proto_build/models/IpoStock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IpoPage extends StatefulWidget {
  const IpoPage({Key? key}) : super(key: key);

  @override
  _IpoPageState createState() => _IpoPageState();
}

class _IpoPageState extends State<IpoPage> {
  @override
  void initState() {
    context.read<IpoCubit>().getipostocklist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('IPO Listings', style: TextStyle(fontSize: 20.0)),
            bottom: PreferredSize(
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text('Listings'),
                      ),
                      Tab(
                        child: Text('My Orders'),
                      ),
                    ]),
                preferredSize: Size.fromHeight(30.0)),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text('Listings'),
                ),
              ),
              Container(child: Center(child: BlocBuilder<IpoCubit, IpoState>(
                builder: (context, state) {
                  if (state is GetIpoStockListSucess) {
                    Map<int, IpoStock> ipoStockList = state.Ipostocklist;
                    return ListView.builder(
                        itemCount: ipoStockList.length,
                        itemBuilder: (context, index) {
                          return buildIpoItem(ipoStockList[index]);
                        });
                  }
                  else
                  {
                    return  Text(state.toString());
                  }

                },
              )))
            ],
          ),
        ));
  }


Widget buildIpoItem(IpoStock? ipoStock) {
  if (ipoStock!.isBiddable) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: background2,
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/9/9a/BTC_Logo.svg'),
              SizedBox.square(
                dimension: 10,
              ),
              Column(children: [
                Text(
                  ipoStock.fullName,
                  style: TextStyle(fontSize: 16, color: white),
                ),
                Text('Open for Bids',style: TextStyle(backgroundColor: blurredGray,color: secondaryColor,) )
              ])
            ],
          ),
          Text(ipoStock.description,style: TextStyle(fontSize: 13,color: white,overflow: TextOverflow.ellipsis),)
        ],
      ),
    );
  }
  else
  {
   return Text('Not biddable');
  }
}

Widget IPOItem() {
  return Card(
    child: Column(children: [
      Row(
        children: [
          Image.asset(
            '',
            width: 50,
            height: 50,
          ),
        ],
      )
    ]),
    color: background2,
  );
}
}