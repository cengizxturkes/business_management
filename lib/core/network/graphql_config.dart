import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/auth_service.dart';

class GraphQLConfig {
  static const String _httpUrl = 'http://localhost:4000/graphql';
  static const String _wsUrl = 'ws://localhost:4000/graphql'; // WebSocket URL'i

  static final HttpLink httpLink = HttpLink(_httpUrl);

  static final WebSocketLink webSocketLink = WebSocketLink(
    _wsUrl,
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        final token = await AuthService.getToken();
        debugPrint('WebSocket bağlantısı için token: $token');
        return {
          'Authorization': token != null ? 'Bearer $token' : '',
        };
      },
    ),
  );

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final token = await AuthService.getToken();
      debugPrint('HTTP bağlantısı için token: $token');
      return token != null ? 'Bearer $token' : null;
    },
  );

  static final Link link = Link.split(
    (request) {
      debugPrint(
          'İstek türü: ${request.isSubscription ? 'Subscription' : 'Query/Mutation'}');
      return request.isSubscription;
    },
    webSocketLink,
    authLink.concat(httpLink),
  );

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
