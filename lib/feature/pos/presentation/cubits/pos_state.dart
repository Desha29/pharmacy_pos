import '../../data/models/tab_data.dart';

class PosState {
  final List<TabData> tabs;
  final int activeTabIndex;

  PosState({required this.tabs, required this.activeTabIndex});

  factory PosState.initial() => PosState(tabs: [TabData()], activeTabIndex: 0);

  PosState copyWith({
    List<TabData>? tabs,
    int? activeTabIndex,
  }) {
    return PosState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }
}