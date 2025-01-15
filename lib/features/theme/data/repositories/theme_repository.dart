import 'dart:ui';

import 'package:business_management/core/services/theme_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/theme_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/auth_service.dart';

class ThemeRepository {
  static const String themeSubscription = '''
    subscription OnThemeChanged(\$branchId: ID!) {
      themeChanged(branchId: \$branchId) {
        branchId
        backgroundColor
        textColor
        primaryColor
        secondaryColor
      }
    }
  ''';

  static const String updateThemeMutation = '''
    mutation UpdateTheme(\$input: ThemeInput!) {
      updateTheme(input: \$input) {
        branchId
        backgroundColor
        textColor
        primaryColor
        secondaryColor
      }
    }
  ''';

  static Stream<ThemeModel> subscribeToThemeChanges(String branchId) {
    final GraphQLClient client = GraphQLConfig.client;

    final SubscriptionOptions options = SubscriptionOptions(
      document: gql(themeSubscription),
      variables: {'branchId': branchId},
    );

    return client.subscribe(options).map((result) {
      if (result.hasException) {
        throw result.exception!;
      }

      final data = result.data?['themeChanged'];
      if (data == null) {
        throw Exception('Tema verisi alınamadı');
      }

      return ThemeModel.fromJson(data);
    });
  }

  static Future<ThemeModel> updateTheme({
    required String branchId,
    required String backgroundColor,
    required String textColor,
    required String primaryColor,
    required String secondaryColor,
  }) async {
    final GraphQLClient client = GraphQLConfig.client;

    final MutationOptions options = MutationOptions(
      document: gql(updateThemeMutation),
      variables: {
        'input': {
          'branchId': branchId,
          'backgroundColor': backgroundColor,
          'textColor': textColor,
          'primaryColor': primaryColor,
          'secondaryColor': secondaryColor,
        },
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      throw result.exception!;
    }

    return ThemeModel.fromJson(result.data!['updateTheme']);
  }
}
