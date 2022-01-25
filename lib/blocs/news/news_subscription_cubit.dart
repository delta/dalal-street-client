import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/Subscribe.pb.dart';
import 'package:equatable/equatable.dart';

part 'news_subscription_state.dart';

class NewsSubscriptionCubit extends Cubit<NewsSubscriptionState> {
  NewsSubscriptionCubit() : super(NewsSubscriptionInitial());
  Future<void> GetNewsFeed(SubscriptionId subscriptionId) async {
    try {
      final marketeventstream = streamClient.getMarketEventUpdates(
          subscriptionId,
          options: sessionOptions(getIt()));
      await for (final marketevent in marketeventstream) {
        emit(SubscriptionToNewsSuccess(marketevent));
      }
    } catch (e) {
      logger.e(e);
      emit(SubscriptionToNewsFailed(e.toString()));
    }
  }
}
