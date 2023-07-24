import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/domain/repository/user_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../data/local_storage.dart';

import 'main_state.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  final IsarService service;

  MainCubit(Repository repository, this.service) : super(MainState()) {
    isSettingsExist();
    checkAndDeleteSmsBox();
  //  initialSettings();
  }
  Future<void> isSettingsExist()async{
   if (await service.getSettings()==null){
    // print('MAIN SETTINGS ==NULL!!');
     emit(state.copyWith(isSettingExist: null
     ));
   }else{
    // print('MAIN SETTINGS NE NULL!!');
     emit(state.copyWith(isSettingExist: true
     ));
   }
  }

  void checkAndDeleteSmsBox(){
   service.deleteMessages();
  }
}
