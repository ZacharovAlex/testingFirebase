import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
  //  required bool isLogged,
    bool? isSettingExist,
  }) = _MainState;
}
