import 'dart:async';
import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:crypto_app/presentation/settings/settings_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsCubit extends BaseCubit<SettingsState> {
  final IsarService service;

  // late StreamSubscription _subscriptionUrl;
  // late StreamSubscription _subscriptionPublicApi;
  // late StreamSubscription _subscriptionPrivateApi;
  // late StreamSubscription _subscriptionTelegram;
  late StreamSubscription _subscriptionSettings;

  SettingsCubit(this.service) : super(SettingsState()) {
    service.getSettings().then((value) => emit(state.copyWith(
          url: value?.url ?? 'No url',
          privateApi: value?.privateApi ?? 'No privateApi',
          publicApi: value?.publicApi ?? 'No publicApi',
          telegram: value?.telegram ?? 'No telegram',
        )));
    _subscriptionSettings = service.listenToSettings().listen((event) {
      print('Stream EVENT!!');
      print('telega ${event?.telegram}');
      emit(state.copyWith(
        url: event?.url ?? 'No url',
        privateApi: event?.privateApi ?? 'No privateApi',
        publicApi: event?.publicApi ?? 'No publicApi',
        telegram: event?.telegram ?? 'No telegram',
      ));
    });
    // _subscriptionUrl = service.listenToUrl().listen((event) {
    //   emit(state.copyWith(url: event));
    // });
    // _subscriptionPublicApi = service.listenToPublicApi().listen((event) {
    //   emit(state.copyWith(publicApi: event));
    // });
    // _subscriptionPrivateApi = service.listenToPrivateApi().listen((event) {
    //   emit(state.copyWith(privateApi: event));
    // });
    // _subscriptionTelegram = service.listenToTelegram().listen((event) {
    //   emit(state.copyWith(telegram: event));
    // });
  }

  // void setUserInfo({required String publicApi,required String privateApi,required String telegram,}) {
  //   if (publicApi != '') {
  //     service.savePublicApi(publicApi);
  //   }
  //   if (privateApi != '') {
  //     service.savePrivateApi(privateApi);
  //   }
  //   if (telegram != '') {
  //     service.saveTelegram(telegram);
  //   }
  // }
  void setUserInfo(UserSettings newSettings) {
    service.updateSettings(newSettings);
  }
}
