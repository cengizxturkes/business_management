import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final String branchId;
  final String backgroundColor;
  final String textColor;
  final String primaryColor;
  final String secondaryColor;

  ThemeModel({
    required this.branchId,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      branchId: json['branchId'] as String,
      backgroundColor: json['backgroundColor'] as String,
      textColor: json['textColor'] as String,
      primaryColor: json['primaryColor'] as String,
      secondaryColor: json['secondaryColor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  @override
  String toString() {
    return 'ThemeModel(branchId: $branchId, backgroundColor: $backgroundColor, textColor: $textColor, primaryColor: $primaryColor, secondaryColor: $secondaryColor)';
  }
}
