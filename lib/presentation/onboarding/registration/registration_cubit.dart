import 'dart:async';
import 'package:crypto_app/data/isar_entity/settings.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:crypto_app/presentation/onboarding/registration/registration_state.dart';
import 'package:injectable/injectable.dart';


@injectable
class RegistrationCubit extends BaseCubit<RegistrationState> {
 // final LocalStorage _localStorage;
  final IsarService _service;
  RegistrationCubit( this._service)
      : super(RegistrationState(
  ));

  // void registration() {
  //   _localStorage.setAuthToken('token');
  //   //storage.initial();
  //   emit(state.copyWith(isRegister: true));
  // }
  void setSettings(UserSettings newSettings) async{
    await _service.updateSettings(newSettings);
    emit(state.copyWith(isRegister: true));
  }
  //void stopListen()=>emit(state.copyWith(isEnabled:false));


}