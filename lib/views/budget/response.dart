import 'package:meta/meta.dart';

@immutable
abstract class BudgetResponse {}

class SuccessResponse extends BudgetResponse {
  final String token;

  SuccessResponse(this.token);
}

class ErrorResponse extends BudgetResponse {
  final error;

  ErrorResponse(this.error);
}