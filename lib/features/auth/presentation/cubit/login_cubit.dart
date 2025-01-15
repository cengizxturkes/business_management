import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../data/models/user_model.dart';
import '../../../../core/network/graphql_config.dart';
import '../../../../core/services/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation Login($email: String!, $password: String!) {
            login(input: {
              email: $email
              password: $password
            }) {
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
        '''),
        variables: {
          'email': email,
          'password': password,
        },
      );

      final QueryResult result = await GraphQLConfig.client.mutate(options);

      if (result.hasException) {
        emit(LoginError(result.exception?.graphqlErrors.first.message ??
            'Bir hata oluştu'));
        return;
      }

      final data = result.data?['login'];
      if (data != null) {
        final token = data['token'] as String;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

        await AuthService.saveAuthData(token: token, user: user);

        emit(LoginSuccess(user: user, token: token));
      } else {
        emit(const LoginError('Giriş başarısız'));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
