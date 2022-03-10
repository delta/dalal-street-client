import 'package:dalal_street_client/blocs/market_event/events/market_event_cubit.dart';
import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/pages/news/newsdetail_page.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/iso_to_datetime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CompanyNewsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final stockId;
  final bool isWeb;

  const CompanyNewsPage({Key? key, required this.stockId, required this.isWeb})
      : super(key: key);

  @override
  State<CompanyNewsPage> createState() => _CompanyNewsPageState();
}

class _CompanyNewsPageState extends State<CompanyNewsPage> {
  @override
  initState() {
    super.initState();
    context.read<MarketEventCubit>().getStockNews(widget.stockId);
  }

  Widget newsItem(
    String text,
    String imagePath,
    String createdAt,
  ) {
    String dur = ISOtoDateTime(createdAt);
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              width: widget.isWeb ? 200 : 125,
              height: 100,
              fit: BoxFit.contain,
              image: NetworkImage(imagePath),
            ),
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      text,
                      style: TextStyle(
                          color: white, fontSize: widget.isWeb ? 24 : 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox.square(
                    dimension: 5,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text('Published on ' + dur,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: lightGray,
                              fontSize: widget.isWeb ? 18 : 14)))
                ]),
          ),
        ],
      ),
    ));
  }

  Widget feedList() => BlocBuilder<MarketEventCubit, MarketEventState>(
          builder: (context, state) {
        if (state is MarketEventSuccess) {
          if (state.marketEvents.isNotEmpty) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: state.marketEvents.length,
              itemBuilder: (context, index) {
                MarketEvent marketEvent = state.marketEvents[index];
                String headline = marketEvent.headline;
                String imagePath = marketEvent.imagePath;
                String createdAt = marketEvent.createdAt;
                String text = marketEvent.text;
                String dur = ISOtoDateTime(createdAt);
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
        } else if (state is MarketEventFailure) {
          return Column(
            children: [
              const Text('Failed to reach server'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context
                      .read<MarketEventCubit>()
                      .getStockNews(widget.stockId),
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
        margin: const EdgeInsets.fromLTRB(0, 0, 45, 0),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Company Related News',
                      style: TextStyle(
                        fontSize: widget.isWeb ? 32 : 18,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  TertiaryButton(
                    width: 90,
                    height: 35,
                    fontSize: 16,
                    title: 'See All',
                    onPressed: () {
                      context.push('/news');
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              feedList()
            ]));
  }
}
