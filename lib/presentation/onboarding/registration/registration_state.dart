import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_state.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    // required String publicApi,
    // required String privateApi,
    // required String telegram,
    @Default(false) bool isRegister,
    // @Default(BottomTab.home) BottomTab currentTab,
  }) = _RegistrationState;
}
