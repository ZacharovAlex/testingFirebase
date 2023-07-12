import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    //UserSettings? settings
     String? publicApi,
    String? privateApi,
   String? telegram,
   String? url,
    // @Default(true) bool isBottomBarVisible,
   // @Default(BottomTab.home) BottomTab currentTab,
  }) = _SettingsState;
}
