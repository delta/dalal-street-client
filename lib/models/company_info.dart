import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';

/// Static info of a company that doesn't change
class CompanyInfo {
  final int id;
  final String shortName;
  final String fullName;
  final String description;

  CompanyInfo(this.id, this.shortName, this.fullName, this.description);

  CompanyInfo.from(Stock stock)
      : id = stock.id,
        shortName = stock.shortName,
        fullName = stock.fullName,
        description = stock.description;
}

Map<T, CompanyInfo> stockMapToCompanyMap<T>(Map<T, Stock> stockMap) =>
    stockMap.map(
      (key, value) => MapEntry(
        key,
        CompanyInfo.from(value),
      ),
    );
