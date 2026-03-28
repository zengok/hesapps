import 'package:json_annotation/json_annotation.dart';

part 'calculation_history.g.dart';

@JsonSerializable()
class CalculationHistory {
  final String id;
  final String title;
  final String result;
  final DateTime date;

  const CalculationHistory({
    required this.id,
    required this.title,
    required this.result,
    required this.date,
  });

  factory CalculationHistory.fromJson(Map<String, dynamic> json) =>
      _$CalculationHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$CalculationHistoryToJson(this);

  CalculationHistory copyWith({
    String? id,
    String? title,
    String? result,
    DateTime? date,
  }) {
    return CalculationHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      result: result ?? this.result,
      date: date ?? this.date,
    );
  }
}
