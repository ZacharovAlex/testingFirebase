

import 'app_error.dart';

class ApiError extends AppError {
  @override
  final String? description;
  final String? status;

  ApiError({this.status, this.description});

//  String? get message => getMessageByStatusCode(errorCode!);//super.message;
//   @override
//   String toString() {
//     return 'ApiError{message: $description, code: $code, errorcode $errorCode}';
//   }
}
//
// String getMessageByStatusCode(int code) {
//   switch (code) {
//     case 11132:
//       return 'Already exist';
//     case 401:
//       return 'Не верный код';
//     case 403:
//       return 'UnauthorisedException';
//
//     case 400:
//       return 'BadRequestException';
//     case 500:
//       return 'ServerError';
//     default:
//       return 'Somesing went wrong';
//   }
// }


