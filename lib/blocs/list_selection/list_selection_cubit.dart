import 'package:bloc/bloc.dart';

part 'list_selection_state.dart';

class ListSelectedItemCubit extends Cubit<ListSelectedItemState> {
  ListSelectedItemCubit() : super(ListSelectedItemState(selectedItem: 1));

  void setSelectedItem(int selected) =>
      emit(ListSelectedItemState(selectedItem: selected));
}
