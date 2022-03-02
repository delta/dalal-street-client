enum OpenOrderType { ASK, BID }

extension AsString on OpenOrderType {
  String asString() {
    switch (this) {
      case OpenOrderType.ASK:
        return 'ASK';
      case OpenOrderType.BID:
        return 'BID';
    }
  }
}
