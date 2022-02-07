import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_selection_state.dart';

class ListSelectionCubit extends Cubit<ListSelectionState> {
  ListSelectionCubit() : super(const ListSelectionState(0));

  void updateSelection(int newIndex) {
    // Only update state if index is changed
    if (newIndex != state.selectedIndex) {
      emit(ListSelectionState(newIndex));
    }
  }

  Stream<int> get selectedIndexStream =>
      stream.map((state) => state.selectedIndex);
}
