class Validator {
  const Validator();

  Set<ValidationError> validateBudgetName(String budgetName) {
    if (budgetName.isValidInput()) {
      return const {};
    }
    return {ValidationError.invalidBudgetName};
  }

  Set<ValidationError> validateAmount(String amount) {
    if (amount.isValidAmount()) {
      return const {};
    }
    return {ValidationError.invalidAmount};
  }

  Set<ValidationError> validateCategory(String category) {
    if (category.isValidInput()) {
      return const {};
    }
    return {ValidationError.invalidCategory};
  }

  Set<ValidationError> validateRecurrence(String recurrence) {
    if (recurrence.isValidInput()) {
      return const {};
    }
    return {ValidationError.invalidRecurrence};
  }

  Set<ValidationError> validateStartDate(String startDate) {
    if (startDate.isValidInput()) {
      return const {};
    }
    return {ValidationError.invalidStartDate};
  }

  Set<ValidationError> validateEndDate(String endDate) {
    if (endDate.isValidInput()) {
      return const {};
    }
    return {ValidationError.invalidEndDate};
  }
}

enum ValidationError {
  invalidBudgetName,
  invalidAmount,
  invalidCategory,
  invalidRecurrence,
  invalidStartDate,
  invalidEndDate
}

extension ValidationExtention on String {
  bool isValidInput() {
    return this.length > 0;
  }

  bool isValidAmount() {
    return this.length > 0 && int.parse(this) > 0;
  }
}
