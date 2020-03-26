import 'package:meta/meta.dart';

class BudgetModel {
  int budgetId;
  String budgetName;
  String budgetAmount;
  String budgetCategory;
  String budgetRecurrence;
  String startDate;
  String endDate;
  String isNotificationsAllowed;

  BudgetModel(
      this.budgetName,
      this.budgetAmount,
      this.budgetCategory,
      this.budgetRecurrence,
      this.startDate,
      this.endDate,
      this.isNotificationsAllowed,
      {this.budgetId});

  BudgetModel.map(dynamic obj) {
    this.budgetId = obj["BudgetId"];
    this.budgetName = obj["BudgetName"];
    this.budgetAmount = obj["BudgetAmount"];
    this.budgetCategory = obj["BudgetCategory"];
    this.budgetRecurrence = obj["BudgetRecurrence"];
    this.startDate = obj["BudgetStartDate"];
    this.endDate = obj["BudgetEndDate"];
    this.isNotificationsAllowed = obj["BudgetNotifications"];
  }

  int get getBudgetId => budgetId;
  String get getBudgetName => budgetName;
  String get getBudgetAmount => budgetAmount;
  String get getBudgetCategory => budgetCategory;
  String get getBudgetRecurrence => budgetRecurrence;
  String get getStartDate => startDate;
  String get getEndDate => endDate;
  String get getNotifications => isNotificationsAllowed;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    // map["BudgetId"] = budgetId;
    map["BudgetName"] = budgetName;
    map["BudgetAmount"] = budgetAmount;
    map["BudgetCategory"] = budgetCategory;
    map["BudgetRecurrence"] = budgetRecurrence;
    map["BudgetStartDate"] = startDate;
    map["BudgetEndDate"] = endDate;
    map["BudgetNotifications"] = isNotificationsAllowed;
    return map;
  }
}

/// Interactor
abstract class BudgetInteractor {
  Stream<BudgetMessage> saveBudget(
    BudgetModel budgetModel,
    Sink<bool> isLoadingSink,
  );
}

/// Login message
@immutable
abstract class BudgetMessage {}

class BudgetSuccessMessage implements BudgetMessage {
  final String token;

  const BudgetSuccessMessage(this.token);
}

class BudgetErrorMessage implements BudgetMessage {
  final Object error;

  const BudgetErrorMessage(this.error);
}

class InvalidInformationMessage implements BudgetMessage {
  const InvalidInformationMessage();
}
