import 'dart:async';

import 'package:moneymanager/database/database.dart';
import 'package:moneymanager/database/model/budget_model.dart';
import 'package:moneymanager/views/budget/response.dart';
import 'package:rxdart/rxdart.dart';

class BudgetInteractorImpl implements BudgetInteractor {
  final DatabaseHelper _api;

  const BudgetInteractorImpl(this._api);

  @override
  Stream<BudgetMessage> saveBudget(
    BudgetModel credential,
    Sink<bool> isLoadingSink,
  ) {
    // StreamController<int> controller = new StreamController<int>();
    // var budgetSubject = BehaviorSubject.seeded(0);
    // int budget = await addNewBudget(credential);
    // budgetSubject.sink.add(budget);
    // return budgetSubject.stream.value;
    return Rx.defer(() => Stream.fromFuture(addNewBudget(credential)))
        .doOnListen(() => isLoadingSink.add(true))
        .onErrorReturnWith((e) => ErrorResponse(e))
        .map(_responseToMessage)
        .doOnDone(() => isLoadingSink.add(false));  
  }

  Future<BudgetResponse> addNewBudget(BudgetModel model) async {
    int inserValue = await _api.saveBudget(model);
    final response = (inserValue > 0)
        ? SuccessResponse("Successfully Done")
        : ErrorResponse("Error api response");
    return response;
  }
  
  static BudgetMessage _responseToMessage(BudgetResponse response) {
    if (response is SuccessResponse) {
      return BudgetSuccessMessage("Success");
    }
    if (response is ErrorResponse) {
      return BudgetErrorMessage(response.error);
    }
    return BudgetErrorMessage("Unknown response $response");
  }
}
