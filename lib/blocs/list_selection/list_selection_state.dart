part of 'list_selection_cubit.dart';

class ListSelectionState extends Equatable {
  final int selectedIndex;

  const ListSelectionState(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}
