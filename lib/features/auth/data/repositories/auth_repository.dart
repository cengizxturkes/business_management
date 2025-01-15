import 'package:business_management/core/services/auth_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  static const String loginMutation = '''
    mutation Login(\$input: LoginInput!) {
      login(input: \$input) {
        token
        user {
          id
          email
          firstName
          lastName
          role
          branchId
        }
      }
    }
  ''';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(loginMutation),
        variables: {
          'input': {
            'email': email,
            'password': password,
          },
        },
      );

      final result = await GraphQLConfig.client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Giriş yapılamadı');
      }

      debugPrint('Login response: ${result.data}');

      final loginData = result.data!['login'];
      debugPrint('Login data: $loginData');

      debugPrint('User data before parsing: ${loginData['user']}');
      final user = UserModel.fromJson(loginData['user']);
      debugPrint('Parsed user with branchId: ${user.branchId}');

      final token = loginData['token'] as String;

      debugPrint('Saving auth data for user with branchId: ${user.branchId}');
      await AuthService.saveAuthData(
        token: token,
        user: user,
      );

      final savedUser = await AuthService.getUser();
      debugPrint('Retrieved saved user with branchId: ${savedUser?.branchId}');

      return {
        'user': user,
        'token': token,
      };
    } catch (e) {
      debugPrint('Login error: $e');
      throw Exception('Giriş yapılamadı: $e');
    }
  }

  static const String registerMutation = '''
    mutation Register(\$input: RegisterInput!) {
      register(input: \$input) {
        token
        user {
          id
          email
          firstName
          lastName
          role
          branchId
        }
      }
    }
  ''';

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String branchId,
  }) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(registerMutation),
        variables: {
          'input': {
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
            'branchId': branchId,
          },
        },
      );

      final result = await GraphQLConfig.client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Kayıt yapılamadı');
      }

      debugPrint('Register response: ${result.data}');

      final registerData = result.data!['register'];
      final user = UserModel.fromJson(registerData['user']);
      final token = registerData['token'] as String;

      debugPrint('Registered user: $user');
      debugPrint('Token: $token');

      await AuthService.saveAuthData(
        token: token,
        user: user,
      );

      return {
        'user': user,
        'token': token,
      };
    } catch (e) {
      debugPrint('Register error: $e');
      throw Exception('Kayıt yapılamadı: $e');
    }
  }
}
