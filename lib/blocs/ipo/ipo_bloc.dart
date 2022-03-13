import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ipo_event.dart';
part 'ipo_state.dart';

class IpoBloc extends Bloc<IpoEvent, IpoState> {
  IpoBloc() : super(IpoInitial()) {
    on<IpoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
