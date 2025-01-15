import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/user_model.dart';

class AuthRepository {
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String branchId,
  }) async {
    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation Register($email: String!, $password: String!, $firstName: String!, $lastName: String!, $branchId: ID!) {
            register(input: {
              email: $email,
              password: $password,
              firstName: $firstName,
              lastName: $lastName,
              branchId: $branchId
            }) {
              token
              user {
                id
                email
                firstName
                lastName
                role
              }
            }
          }
        '''),
        variables: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'branchId': branchId,
        },
      );

      final QueryResult result = await GraphQLConfig.client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Kayıt işlemi başarısız');
      }

      final data = result.data?['register'];
      if (data == null) {
        throw Exception('Kayıt verisi alınamadı');
      }

      return {
        'token': data['token'] as String,
        'user': UserModel.fromJson(data['user'] as Map<String, dynamic>),
      };
    } catch (e) {
      throw Exception('Kayıt işlemi başarısız: $e');
    }
  }
}
