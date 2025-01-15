import 'package:equatable/equatable.dart';

class BranchModel extends Equatable {
  final String id;
  final String branchName;
  final int branchType;
  final bool active;
  final String phoneNumber;
  final String email;
  final String defaultCurrencyId;
  final String defaultPriceListId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BranchModel({
    required this.id,
    required this.branchName,
    required this.branchType,
    required this.active,
    required this.phoneNumber,
    required this.email,
    required this.defaultCurrencyId,
    required this.defaultPriceListId,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      try {
        return DateTime.parse(value.toString());
      } catch (e) {
        return null;
      }
    }

    return BranchModel(
      id: json['id'] ?? '',
      branchName: json['branchName'] ?? '',
      branchType: json['branchType'] ?? 0,
      active: json['active'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      defaultCurrencyId: json['defaultCurrencyId'] ?? '',
      defaultPriceListId: json['defaultPriceListId'] ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  String get branchTypeText {
    switch (branchType) {
      case 1:
        return 'Merkez Şube';
      case 2:
        return 'Normal Şube';
      case 3:
        return 'Bayi';
      default:
        return 'Bilinmiyor';
    }
  }

  @override
  List<Object?> get props => [
        id,
        branchName,
        branchType,
        active,
        phoneNumber,
        email,
        defaultCurrencyId,
        defaultPriceListId,
        createdAt,
        updatedAt,
      ];
}
