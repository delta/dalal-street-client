import 'package:bloc/bloc.dart';

part 'selected_index_state.dart';

class SelectedIndexCubit extends Cubit<SelectedIndexState> {
  final List<bool> initialList;
  SelectedIndexCubit(this.initialList) : super(SelectedIndexState(selectedItems:  initialList));

  void setSelected(int index) {
    for(int i=0;i<initialList.length;i++) {
      initialList[i]=false;
    }
    initialList[index]=true;
    emit(SelectedIndexState(selectedItems: initialList));
  }
}
