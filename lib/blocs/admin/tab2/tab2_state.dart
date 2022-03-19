part of 'tab2_cubit.dart';

abstract class Tab2State extends Equatable {
  const Tab2State();

  @override
  List<Object> get props => [];
}

class Tab2Initial extends Tab2State {}

abstract class OpenMarketState extends Equatable {
  const OpenMarketState();

  @override
  List<Object> get props => [];
}

class OpenMarketInitial extends Tab2State {}

class OpenMarketLoading extends Tab2State {
  const OpenMarketLoading();
}

class OpenMarketFailure extends Tab2State {
  final String msg;

  const OpenMarketFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class OpenMarketSuccess extends Tab2State {
  final String msg;

  const OpenMarketSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class CloseMarketState extends Equatable {
  const CloseMarketState();

  @override
  List<Object> get props => [];
}

class CloseMarketInitial extends Tab2State {}

class CloseMarketLoading extends Tab2State {
  const CloseMarketLoading();
}

class CloseMarketFailure extends Tab2State {
  final String msg;

  const CloseMarketFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class CloseMarketSuccess extends Tab2State {
  final String msg;

  const CloseMarketSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class BlockUserState extends Equatable {
  const BlockUserState();

  @override
  List<Object> get props => [];
}

class BlockUserInitial extends Tab2State {}

class BlockUserLoading extends Tab2State {
  const BlockUserLoading();
}

class BlockUserFailure extends Tab2State {
  final String msg;

  const BlockUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class BlockUserSuccess extends Tab2State {
  final String msg;

  const BlockUserSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class InspectUserState extends Equatable {
  const InspectUserState();

  @override
  List<Object> get props => [];
}

class InspectUserInitial extends Tab2State {}

class InspectUserLoading extends Tab2State {
  const InspectUserLoading();
}

class InspectUserFailure extends Tab2State {
  final String msg;

  const InspectUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class InspectUserSuccess extends Tab2State {
  final String msg;
  final List<InspectDetails> list;
  const InspectUserSuccess(this.msg, this.list);
  @override
  List<Object> get props => [msg, list];
}

abstract class UnblockAllUsersState extends Equatable {
  const UnblockAllUsersState();

  @override
  List<Object> get props => [];
}

class UnblockAllUsersInitial extends Tab2State {}

class UnblockAllUsersLoading extends Tab2State {
  const UnblockAllUsersLoading();
}

class UnblockAllUsersFailure extends Tab2State {
  final String msg;

  const UnblockAllUsersFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UnblockAllUsersSuccess extends Tab2State {
  final String msg;

  const UnblockAllUsersSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class UnblockUserState extends Equatable {
  const UnblockUserState();

  @override
  List<Object> get props => [];
}

class UnblockUserInitial extends Tab2State {}

class UnblockUserLoading extends Tab2State {
  const UnblockUserLoading();
}

class UnblockUserFailure extends Tab2State {
  final String msg;

  const UnblockUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UnblockUserSuccess extends Tab2State {
  final String msg;

  const UnblockUserSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class SquareOffLoading extends Tab2State {
  const SquareOffLoading();
}

class SquareOffError extends Tab2State {
  final String msg;

  const SquareOffError(this.msg);

  @override
  List<Object> get props => [msg];
}

class SquareOffSuccess extends Tab2State {
  const SquareOffSuccess();

  @override
  List<Object> get props => [];
}
