// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingPaymentModel _$PendingPaymentModelFromJson(Map<String, dynamic> json) =>
    PendingPaymentModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amountUsd: (json['amountUsd'] as num).toDouble(),
    );

Map<String, dynamic> _$PendingPaymentModelToJson(
  PendingPaymentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'amountUsd': instance.amountUsd,
};
