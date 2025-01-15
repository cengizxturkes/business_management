part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterBranchesLoaded extends RegisterState {
  final List<BranchModel> branches;

  const RegisterBranchesLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class RegisterSuccess extends RegisterState {
  final UserModel user;
  final String token;

  const RegisterSuccess({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
