import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/branch_model.dart';

class BranchRepository {
  static Future<List<BranchModel>> getBranches() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query GetBranches {
            branches {
              id
              branchName
              branchType
              email
              phoneNumber
              active
            }
          }
        '''),
      );

      final QueryResult result = await GraphQLConfig.client.query(options);

      if (result.hasException) {
        throw Exception(result.exception?.graphqlErrors.first.message ??
            'Şubeler alınamadı');
      }

      final List<dynamic> branches = result.data?['branches'] ?? [];
      return branches
          .map((branch) => BranchModel.fromJson(branch as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Şubeler alınamadı: $e');
    }
  }
}
