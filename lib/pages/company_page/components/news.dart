import 'package:dalal_street_client/blocs/news/news_bloc.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/pages/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<MarketEvent> mapMarketEvents = [];
int i = 1;

class CompanyNewsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final stockId;

  const CompanyNewsPage({Key? key, required this.stockId}) : super(key: key);

  @override
  State<CompanyNewsPage> createState() => _CompanyNewsPageState();
}

class _CompanyNewsPageState extends State<CompanyNewsPage> {
  @override
  initState() {
    super.initState();
    logger.i('CompanyNewsPage initState');
    context.read<NewsBloc>().add(GetNewsById(widget.stockId));
  }

  Widget newsItem(
    String text,
    String imagePath,
    String createdAt,
  ) {
    String dur = getdur(createdAt);
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              image: NetworkImage(imagePath),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 100) * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                const SizedBox.square(
                  dimension: 5,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text('Published on ' + dur,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: lightGray,
                            fontSize: 12)))
              ]),
        ],
      ),
    ));
  }

  String getdur(String createdAt) {
    DateTime dt1 = DateTime.parse(createdAt);
    DateTime dt2 = DateTime.now();
    Duration diff = dt2.difference(dt1);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return (diff.inMinutes.toString() + ' minutes ago');
      } else {
        return (diff.inHours.toString() + ' hour ago');
      }
    } else {
      return (diff.inDays.toString() + ' day ago');
    }
  }

  Widget feedlist() =>
      BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is GetNewsSucess) {
          mapMarketEvents.clear();
          mapMarketEvents.addAll(state.marketEventsList.marketEvents);
          // Sort MarketEvents according to there created time
          mapMarketEvents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          logger.i(mapMarketEvents);
          if (mapMarketEvents.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: mapMarketEvents.length,
              itemBuilder: (context, index) {
                MarketEvent marketEvent = mapMarketEvents[index];
                String headline = marketEvent.headline;
                String imagePath = marketEvent.imagePath;
                String createdAt = marketEvent.createdAt;
                String text = marketEvent.text;
                String dur = getdur(createdAt);
                return GestureDetector(
                    child: newsItem(headline, imagePath, createdAt),
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NewsDetail(
                              text: text,
                              imagePath: imagePath,
                              headline: headline,
                              dur: dur),
                        )));
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else {
            return const Center(
              child: Text(
                'No News',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            );
          }
        } else if (state is GetNewsFailure) {
          return Column(
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context.read<NewsBloc>().add(GetMoreNews(
                      mapMarketEvents[mapMarketEvents.length - 1].id - 1)),
                  child: const Text('Retry'),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: DalalLoadingBar(),
          );
        }
      });
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: background2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Company Related News',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  TertiaryButton(
                    width: 80,
                    height: 25,
                    fontSize: 12,
                    title: 'See All',
                    onPressed: () {
                      Navigator.pushNamed(context, '/news');
                    },
                  ),
                ],
              ),
              feedlist()
            ]));
  }
}
