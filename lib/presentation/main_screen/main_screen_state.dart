import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/data/isar_entity/users_credentials.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_screen_state.freezed.dart';

@freezed
class MainScreenState with _$MainScreenState {
  const factory MainScreenState({
  UserSettings? settings,
    UserCredentials? credentials,
    String? url,
    String? public,
    String? privat,
    String? telegram,
    @Default(false) errorSocket,
     @Default(false) bool isEnabled,
   // @Default(BottomTab.home) BottomTab currentTab,
  }) = _MainScreenState;
}
