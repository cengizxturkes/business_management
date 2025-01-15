import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/services/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial()) {
    loadBranches();
  }

  Future<void> loadBranches() async {
    try {
      final branches = await BranchRepository.getBranches();
      emit(RegisterBranchesLoaded(branches));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String branchId,
  }) async {
    try {
      emit(RegisterLoading());

      final result = await AuthRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        branchId: branchId,
      );

      final token = result['token'] as String;
      final user = result['user'] as UserModel;

      // Token ve user bilgilerini kaydet
      await AuthService.saveAuthData(token: token, user: user);

      emit(RegisterSuccess(user: user, token: token));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
