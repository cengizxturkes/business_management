import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/theme_model.dart';
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
        backgroundColor
        textColor
        primaryColor
        secondaryColor
      }
    }
  ''';

  static Stream<ThemeModel> subscribeToThemeChanges(String branchId) {
    debugPrint('Tema subscription başlatılıyor. Branch ID: $branchId');
    final GraphQLClient client = GraphQLConfig.client;

    final SubscriptionOptions options = SubscriptionOptions(
      document: gql(themeSubscription),
      variables: {'branchId': branchId},
    );

    return client.subscribe(options).map((result) {
      debugPrint('Subscription sonucu alındı: ${result.data}');
      debugPrint('Subscription hatası var mı: ${result.hasException}');

      if (result.hasException) {
        debugPrint('Subscription hatası: ${result.exception.toString()}');
        throw result.exception!;
      }

      final data = result.data?['themeChanged'];
      debugPrint('Tema verisi: $data');

      if (data == null) {
        debugPrint('Tema verisi null geldi');
        throw Exception('Tema verisi alınamadı');
      }

      final theme = ThemeModel.fromJson(data);
      debugPrint('Dönüştürülen tema: ${theme.toString()}');
      return theme;
    });
  }

  static Future<ThemeModel> updateTheme({
    required String branchId,
    required String backgroundColor,
    required String textColor,
    required String primaryColor,
    required String secondaryColor,
  }) async {
    final user = await AuthService.getUser();
    if (user == null || user.branchId != branchId) {
      throw Exception('Bu şube için tema güncellenemez');
    }

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

    final data = result.data!['updateTheme'];
    return ThemeModel.fromJson({
      ...data,
      'branchId': branchId,
    });
  }
}
