import 'package:json_annotation/json_annotation.dart';

part 'pending_payment_model.g.dart';

@JsonSerializable()
class PendingPaymentModel {
  final String id;
  final String type;
  final double amountUsd;

  PendingPaymentModel({
    required this.id,
    required this.type,
    required this.amountUsd,
  });

  factory PendingPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PendingPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PendingPaymentModelToJson(this);
}
