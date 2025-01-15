import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/auth_service.dart';

class GraphQLConfig {
  static final HttpLink httpLink = HttpLink('http://localhost:4000/graphql');

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final token = await AuthService.getToken();
      return token != null ? 'Bearer $token' : null;
    },
  );

  static final Link link = authLink.concat(httpLink);

  static final GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );

  static ValueNotifier<GraphQLClient> clientToQuery() {
    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
  }
}
