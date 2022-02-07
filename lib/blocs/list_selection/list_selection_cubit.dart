import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_selection_state.dart';

/// Helper cubit to manage list selection ui
class ListSelectionCubit extends Cubit<ListSelectionState> {
  ListSelectionCubit() : super(const ListSelectionState(0));

  /// Update the selected index
  void updateSelection(int newIndex) {
    // Only update state if index is changed
    if (newIndex != state.selectedIndex) {
      emit(ListSelectionState(newIndex));
    }
  }

  /// Stream of selected indices
  Stream<int> get selectedIndexStream =>
      stream.map((state) => state.selectedIndex);
}
