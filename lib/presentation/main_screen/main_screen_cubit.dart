import 'dart:async';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import 'main_screen_state.dart';

@injectable
class MainScreenCubit extends BaseCubit<MainScreenState> {
  final IsarService service;
  late StreamSubscription _subscriptionSettings;
  late final StreamSubscription _fcmSubscription;

  MainScreenCubit(
    this.service,
  ) : super(MainScreenState()) {
    getSettings();
    getCredentials();
    _subscriptionSettings = service.listenToSettings().listen((event) {
      emit(state.copyWith(settings: event));
    });
    _fcmSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(updateFcmToken); //TODO FCM token to Firebase
    FirebaseMessaging.instance.getToken().then(updateFcmToken);
  }

  Future<void> updateFcmToken(String? fcmToken) async {
    print(fcmToken);
    if (fcmToken != null) {
      service.updateFcmToken(fcmToken);
    }
  }

  void enableListen() {
    // localStorage.setTimeStartSession(DateTime.now());
    service.updateStartSessionTime(DateTime.now().subtract(const Duration(minutes: 10)));
    emit(state.copyWith(isEnabled: true));
  }

  void getSettings() async {
    await service.getSettings().then((value) {
      print('Value $value');
      emit(state.copyWith(settings: value));
    });
  }

  void getCredentials() async {
    await service.getCredentials().then((value) {
      print('Value $value');
      emit(state.copyWith(credentials: value));
    });
  }

  void setError() async {
    emit(state.copyWith(errorSocket: true));
  }

  void reconnectTryToggle(bool isNowTry) async {
    emit(state.copyWith(isReconnectTry: isNowTry));
  }

// void stopListen()=>emit(state.copyWith(isEnabled:false));
}
