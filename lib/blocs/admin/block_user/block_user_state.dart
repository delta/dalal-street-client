part of 'block_user_cubit.dart';

abstract class BlockUserState extends Equatable {
  const BlockUserState();

  @override
  List<Object> get props => [];
}

class BlockUserInitial extends BlockUserState {}

class BlockUserLoading extends BlockUserState {
  const BlockUserLoading();
}

class BlockUserFailure extends BlockUserState {
  final String msg;

  const BlockUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class BlockUserSuccess extends BlockUserState {
  final user_id;
  final penalty;
  const BlockUserSuccess(this.user_id, this.penalty);
}
