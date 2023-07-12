import 'app_error.dart';

class DefaultError extends AppError {
  @override
  final String? description;
  final String? status;

  DefaultError({this.status, this.description});

  @override
  String toString() {
    return 'ApiError{message: $status, code: $description}';
  }
}
