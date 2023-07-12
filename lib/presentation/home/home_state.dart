import 'package:crypto_app/presentation/home/home_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    String? telegram,
    @Default(false) bool isEnable,
   // @Default(true) bool isBottomBarVisible,
    @Default(BottomTab.home) BottomTab currentTab,
  }) = _HomeState;
}
