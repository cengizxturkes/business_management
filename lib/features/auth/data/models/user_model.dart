import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String branchId;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.role = '',
    required this.branchId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('UserModel.fromJson çağrıldı. JSON: $json');
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      branchId: json['branchId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'branchId': branchId,
    };
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, role, branchId];

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, firstName: $firstName, lastName: $lastName, role: $role, branchId: $branchId)';
  }
}
