import 'dart:async';

import 'package:dalal_street_client/proto_build/datastreams/GameState.pb.dart';
import 'package:dalal_street_client/proto_build/models/GameState.pb.dart';

/// Generate a stream of [bool] using [gameStateStream]
class MarketOpenGenerator {
  bool isOpen;

  final Stream<GameStateUpdate> gameStateStream;

  MarketOpenGenerator(this.isOpen, this.gameStateStream) {
    _listenToGameState();
  }

  /// The [StreamController] used to generate a stream of [bool]
  final _controller = StreamController<bool>();

  /// A Read-only stream of [bool]
  Stream<bool> get stream => _controller.stream;

  /// Updates [isOpen] and adds it to [_controller]
  void updateStream(bool newValue) {
    isOpen = newValue;
    _controller.add(isOpen);
  }

  /// Updates [isOpen] for every new [GameStateUpdate]
  void _listenToGameState() => gameStateStream.listen((newUpdate) {
        final gameState = newUpdate.gameState;
        if (gameState.type == GameStateUpdateType.MarketStateUpdate) {
          updateStream(gameState.marketState.isMarketOpen);
        }
      });
}
