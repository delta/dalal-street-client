part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterFailure extends RegisterState {
  final String msg;

  const RegisterFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class RegisterSuccess extends RegisterState {
  final String mail;

  const RegisterSuccess(this.mail);
}
