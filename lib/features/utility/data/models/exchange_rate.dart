import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate.g.dart';

@JsonSerializable()
class ExchangeRate {
  final String currencyCode;
  final double rate;
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.currencyCode,
    required this.rate,
    required this.lastUpdated,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateToJson(this);

  ExchangeRate copyWith({
    String? currencyCode,
    double? rate,
    DateTime? lastUpdated,
  }) {
    return ExchangeRate(
      currencyCode: currencyCode ?? this.currencyCode,
      rate: rate ?? this.rate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
