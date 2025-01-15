import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../core/network/graphql_config.dart';
import '../models/branch_model.dart';

class BranchRepository {
  static final GraphQLClient _publicClient = GraphQLClient(
    link: GraphQLConfig.httpLink,
    cache: GraphQLCache(),
  );

  static Future<List<BranchModel>> getBranches() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(r'''
          query GetBranches {
            branches {
              id
              branchName
              branchType
              active
              phoneNumber
              email
              defaultCurrencyId
              defaultPriceListId
              createdAt
              updatedAt
            }
          }
        '''),
      );

      final QueryResult result = await _publicClient.query(options);

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
