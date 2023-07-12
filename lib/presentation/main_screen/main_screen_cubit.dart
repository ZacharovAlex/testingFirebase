import 'dart:async';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

import 'main_screen_state.dart';


@injectable
class MainScreenCubit extends BaseCubit<MainScreenState> {
 // final LocalStorage localStorage;
final IsarService service;
late StreamSubscription _subscriptionSettings;
// late StreamSubscription _subscriptionPublic;
// late StreamSubscription _subscriptionPrivat;
// late StreamSubscription _subscriptionTelegram;
  MainScreenCubit(this.service,)
      : super(MainScreenState(
      )){
    getSettings();
    getCredentials();
    _subscriptionSettings = service.listenToSettings().listen((event) {
      emit(state.copyWith(settings: event));

    });
  }

  void enableListen() {
   // localStorage.setTimeStartSession(DateTime.now());
    service.updateStartSessionTime(DateTime.now().subtract(const Duration(minutes: 10)));
    emit(state.copyWith(isEnabled: true));}
  void getSettings() async{
    await service.getSettings().then((value)  {
      print('Value $value');
      emit(state.copyWith(settings: value));});
  }
  void getCredentials() async{
    await service.getCredentials().then((value)  {
      print('Value $value');
      emit(state.copyWith(credentials: value));});
  }
  void setError() async{
    emit(state.copyWith(errorSocket: true));
  }

 // void stopListen()=>emit(state.copyWith(isEnabled:false));


}
