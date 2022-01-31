import 'dart:async';

import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pb.dart';

// TODO: add docs
class MarketOpenGenerator {
  bool isOpen;

  final Stream<GameStateUpdate> gameStateStream;

  MarketOpenGenerator(this.isOpen, this.gameStateStream) {
    _listenToGameState();
  }

  final _controller = StreamController<bool>();

  Stream<bool> get stream => _controller.stream;

  void updateStream(bool newValue) {
    isOpen = newValue;
    _controller.add(isOpen);
  }

  void _listenToGameState() => gameStateStream.listen((newUpdate) {
        final gameState = newUpdate.gameState;
        if (gameState.type == GameStateUpdateType.MarketStateUpdate) {
          updateStream(gameState.marketState.isMarketOpen);
        }
      });
}
