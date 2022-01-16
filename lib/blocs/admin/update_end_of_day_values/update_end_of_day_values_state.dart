part of 'update_end_of_day_values_cubit.dart';

abstract class UpdateEndOfDayValuesState extends Equatable {
  const UpdateEndOfDayValuesState();

  @override
  List<Object> get props => [];
}

class UpdateEndOfDayValuesInitial extends UpdateEndOfDayValuesState {}

class UpdateEndOfDayValuesLoading extends UpdateEndOfDayValuesState {
  const UpdateEndOfDayValuesLoading();
}

class UpdateEndOfDayValuesFailure extends UpdateEndOfDayValuesState {
  final String msg;

  const UpdateEndOfDayValuesFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UpdateEndOfDayValuesSuccess extends UpdateEndOfDayValuesState {
  const UpdateEndOfDayValuesSuccess();
}
