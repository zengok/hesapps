// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculationHistory _$CalculationHistoryFromJson(Map<String, dynamic> json) =>
    CalculationHistory(
      id: json['id'] as String,
      title: json['title'] as String,
      result: json['result'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$CalculationHistoryToJson(CalculationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'result': instance.result,
      'date': instance.date.toIso8601String(),
    };
