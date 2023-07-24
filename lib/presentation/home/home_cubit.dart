import 'dart:async';
import 'package:crypto_app/data/isar_service.dart';
import 'package:crypto_app/domain/repository/user_data_repository.dart';
import 'package:crypto_app/presentation/base/base_cubit.dart';
import 'package:crypto_app/presentation/home/home_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final IsarService service;
  late StreamSubscription _subscriptionSettings;


  HomeCubit( Repository repository, this.service) : super( HomeState(

  ))
  {
    service.getSettings().then((value) =>  emit(state.copyWith(telegram: value?.telegram??'no telegram')));

    _subscriptionSettings = service.listenToSettings().listen((event) {
      emit(state.copyWith(telegram: event?.telegram??'no telegram'));

    });
  }

  void moveTo(BottomTab tab) => emit(state.copyWith(currentTab: tab));
}

enum BottomTab { home,listenSms,settings }//TODO if listen sms add "listenSms",
