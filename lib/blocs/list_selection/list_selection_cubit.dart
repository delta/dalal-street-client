import 'package:bloc/bloc.dart';

part 'list_selection_state.dart';

class ListSelectedItemCubit extends Cubit<ListSelectedItemState> {
  final int initialItem;
  ListSelectedItemCubit(this.initialItem)
      : super(ListSelectedItemState(selectedItem: initialItem));

  void setSelectedItem(int selected) =>
      emit(ListSelectedItemState(selectedItem: selected));
}
