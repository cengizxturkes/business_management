import 'package:equatable/equatable.dart';

class BranchModel extends Equatable {
  final String id;
  final String branchName;
  final int branchType;
  final bool active;
  final String phoneNumber;
  final String email;

  const BranchModel({
    required this.id,
    required this.branchName,
    required this.branchType,
    required this.active,
    required this.phoneNumber,
    required this.email,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? '',
      branchName: json['branchName'] ?? '',
      branchType: json['branchType'] ?? 0,
      active: json['active'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
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
  List<Object?> get props =>
      [id, branchName, branchType, active, phoneNumber, email];
}
