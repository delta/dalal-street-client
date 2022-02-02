import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_orders_state.dart';

class OpenOrdersCubit extends Cubit<OpenOrdersState> {
  OpenOrdersCubit() : super(OpenOrdersInitial());
}
