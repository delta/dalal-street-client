import 'package:bloc/bloc.dart';
import 'package:dalal_street_client/grpc/client.dart';
import 'package:dalal_street_client/main.dart';
import 'package:dalal_street_client/proto_build/actions/GetMarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/datastreams/MarketEvents.pb.dart';
import 'package:dalal_street_client/proto_build/models/MarketEvent.pb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../proto_build/datastreams/Subscribe.pb.dart';

part 'market_event_event.dart';
part 'market_event_state.dart';

class MarketEventBloc extends Bloc<MarketEvent_events, MarketEventState> {
  MarketEventBloc() : super(MarketEventInitial()) {
    on<GetMarketEvent>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(),
          options: sessionOptions(getIt()),
        );
        
        emit(GetMarketEventSucess(marketEventResponse));
      } catch (e) {
        emit(GetMarketEventFailure(e.toString()));
      }
    });

    on<GetMarketEventFeed>((event, emit) async {
        try {
           final marketeventstream =
             
              streamClient.getMarketEventUpdates(event.subscriptionId,options: sessionOptions(getIt()));
          await for (final marketevent in marketeventstream) {
            emit(SubscriptionToMarketEventSuccess(marketevent));
          }
        } catch (e) {
          logger.e(e);
          emit(SubscriptionToMarketEventFailed(e.toString()));
        }
      });

      on<GetMoreMarketEvent>((event, emit) async {
      try {
        final GetMarketEventsResponse marketEventResponse =
            await actionClient.getMarketEvents(
          GetMarketEventsRequest(lastEventId: event.lasteventid),
          options: sessionOptions(getIt()),
        );
        
        emit(GetMarketEventSucess(marketEventResponse));
      } catch (e) {
        emit(GetMarketEventFailure(e.toString()));
      }
    });
    // void LoadMarketEvents() {
    // if (state is MarketEventsLoading) return;

    // final currentState = state;

    // var oldMarketEvents = <MarketEvent>[];
    // if (currentState is MarketEventsLoaded) {
    //   oldMarketEvents= currentState.marketevents;
    // }

    // emit(MarketEventsLoading(oldMarketEvents, isFirstFetch: page == 1));

    // repository.fetchPosts(page).then((newPosts) {
    //   page++;

    //   final posts = (state as PostsLoading).oldPosts;
    //   posts.addAll(newPosts);    

    //   emit(PostsLoaded(posts));
    // });
  }
  }

  

