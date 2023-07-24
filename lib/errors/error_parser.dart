import 'package:crypto_app/errors/server_not_reachable_error.dart';
import 'package:dio/dio.dart';
import 'app_error.dart';
import 'default_error.dart';
import 'network_connection_error.dart';

AppError parseError(Object error) {
  // logger.e(error);
  if (error is AppError) {
    print('APPERROR');
    return error;
  }
  if (error is DioException &&
      error.type == DioExceptionType.unknown
      ) {
    print('DIO ERROR');
    return const NetworkConnectionError();
  }
  if (error is DioException &&
      (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout)) {
    print('DIO ERROR');
    return const ServerNotReachableError();
  }

  if (error is DioException && (error.response?.statusCode != null)) {
    print('DIO ERROR TUT! ${error.response?.statusCode}');
    return DefaultError(); // TODO here implement and uncomment next code by errorcode
      // getErrorByErrorCode(error.response?.data[
      //   "errorCode"]); //ApiError(errorCode: error.response?.data["errorCode"],code: error.response?.statusCode, description: error.response?.data["description"]);
  }
  // error as DefaultError;
  print('DEFAULT ERRROR V PARSINGE  ${error.toString()}');
  return DefaultError();
  //DefaultError(code: (error as MyBaseResponse).statusCode, message: (error).description);
}

// AppError getErrorByErrorCode(int? errorCode) { //TODO Uncomment if need error handling!
//   switch (errorCode) {
//     case 210001:
//       return IncorrectLoginPassError();
//     case 210004:
//       return InvalidEmailError();
//     case 200008:
//       return IncorrectPinCodeError();
//     case 200006:
//       return UserAlreadyExistError();
//     case 210005:
//       return InvalidValidationCodeError();
//     default:
//       return DefaultError();
//   }
// }
