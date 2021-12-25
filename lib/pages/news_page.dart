import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/market_event/market_event_bloc.dart';

// ignore: camel_case_types
class News_Page extends StatefulWidget {
  const News_Page({Key? key}) : super(key: key);

  @override
  _News_PageState createState() => _News_PageState();
}

// ignore: camel_case_types
class _News_PageState extends State<News_Page> {
  @override
  initState() {
    super.initState();
    context.read<MarketEventBloc>().add(const GetMarketEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //  decoration: BoxDecoration(color: backgroundColor,borderRadius: BorderRadius.circular(10)),
            color: backgroundColor,

            //  child:

            child: Feed()));
  }
}

// ignore: non_constant_identifier_names
Container Feed() {
  return Container(
    // color: ,
    decoration: BoxDecoration(
        color: baseColor, borderRadius: BorderRadius.circular(10)),

    child: news_list(),
  );
}

// ignore: non_constant_identifier_names
BlocBuilder<MarketEventBloc, MarketEventState> news_list() {
  return BlocBuilder<MarketEventBloc, MarketEventState>(
      builder: (context, state) {
    if (state is GetMarketEventSucess) {
      List<MarketEvent> mapMarketEvents = state.marketEventsList.marketEvents;
      logger.i(mapMarketEvents.length);
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: mapMarketEvents.length,
        itemBuilder: (context, index) {
          MarketEvent marketEvent = mapMarketEvents[index];
          String headline = marketEvent.headline;
          String text = marketEvent.text;
          String imagePath = marketEvent.imagePath;
          return newsItem(headline, text, imagePath);
        },
      );
    } else if (state is GetMarketEventFailure) {
      return const Text('error');
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: secondaryColor,
        ),
      );
    }
  });
}

Container newsItem(String headline, String text, String imagePath) {
  return (Container(
    padding: const EdgeInsets.all(10),
    child: Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Image.network(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          )),
          Flexible(
              child: Text(headline,
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              fit: FlexFit.loose),
          //  Text(text,style: TextStyle(color: Color.fromARGB(255, 179, 0, 0),fontSize: 10 )
          //  ),
          //  Image.asset(imagePath,width: 100,height: 100,fit: BoxFit.fill,)
          // Newsimage()
        ],
      ),
    ]),
  ));
}
