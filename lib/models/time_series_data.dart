/// TimeSeriesData is class used to construct
/// all types of stock price line graphs
class TimeSeriesData {
  final DateTime time;
  final double
      stockPrice; // can be close, open, low, high depending upon the graph use case

  TimeSeriesData(this.time, this.stockPrice);
}
