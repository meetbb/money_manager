import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:meta/meta.dart';
import 'package:moneymanager/database/model/budget_model.dart';
import 'package:moneymanager/views/budget/validator.dart';
import 'package:rxdart/rxdart.dart';

// ignore_for_file: close_sinks

/// BLoC handle validate form and Budget Creation
class BudgetBloc {
  /// Input functions
  final void Function(String) budgetNameChanged;
  final void Function(String) budgetAmountChanged;
  final void Function(String) budgetCategoryChanged;
  final void Function(String) budgetRecurrenceChanged;
  final void Function(String) budgetStartDateChanged;
  final void Function(String) budgetEndDateChanged;
  final void Function() submitBudget;

  /// Streams
  final Stream<Set<ValidationError>> budgetNameError$;
  final Stream<Set<ValidationError>> budgetAmountError$;
  final Stream<Set<ValidationError>> budgetCategoryError$;
  final Stream<Set<ValidationError>> budgetRecurrenceError$;
  final Stream<Set<ValidationError>> budgetStartDateError$;
  final Stream<Set<ValidationError>> budgetEndDateError$;
  final ValueStream<bool> isLoading$;
  final Stream<BudgetMessage> message$;

  /// Clean up
  final void Function() dispose;

  BudgetBloc._({
    @required this.budgetNameChanged,
    @required this.budgetAmountChanged,
    @required this.budgetCategoryChanged,
    @required this.budgetRecurrenceChanged,
    @required this.budgetStartDateChanged,
    @required this.budgetEndDateChanged,
    @required this.submitBudget,
    @required this.budgetNameError$,
    @required this.budgetAmountError$,
    @required this.budgetCategoryError$,
    @required this.budgetRecurrenceError$,
    @required this.budgetStartDateError$,
    @required this.budgetEndDateError$,
    @required this.isLoading$,
    @required this.message$,
    @required this.dispose,
  });

  factory BudgetBloc(BudgetInteractor interactor) {
    assert(interactor != null);
    const validator = Validator();

    // Stream controllers
    final budgetNameSubject = BehaviorSubject.seeded('');
    final budgetAmountSubject = BehaviorSubject.seeded('');
    final budgetCategorySubject = BehaviorSubject.seeded('');
    final budgetRecurrenceSubject = BehaviorSubject.seeded('');
    final budgetStartDateSubject = BehaviorSubject.seeded('');
    final budgetEndDateSubject = BehaviorSubject.seeded('');
    final isLoadingS = BehaviorSubject.seeded(false);
    final submitBudget = StreamController<void>();
    final subjects = [
      budgetNameSubject,
      budgetAmountSubject,
      budgetCategorySubject,
      budgetRecurrenceSubject,
      budgetStartDateSubject,
      budgetEndDateSubject,
      isLoadingS,
      submitBudget
    ];

    // Email error and password error stream
    final budgetNameError$ =
        budgetNameSubject.map(validator.validateBudgetName).distinct().share();

    final budgetAmountError$ =
        budgetAmountSubject.map(validator.validateAmount).distinct().share();
    final budgetCategoryError$ = budgetCategorySubject
        .map(validator.validateCategory)
        .distinct()
        .share();
    final budgetRecurrenceError$ = budgetRecurrenceSubject
        .map(validator.validateRecurrence)
        .distinct()
        .share();
    final startDateError$ = budgetStartDateSubject
        .map(validator.validateStartDate)
        .distinct()
        .share();
    final endDateError$ =
        budgetEndDateSubject.map(validator.validateEndDate).distinct().share();

    // Submit stream
    final submit$ = submitBudget.stream
        .throttleTime(const Duration(milliseconds: 500))
        .withLatestFrom<bool, bool>(
          Rx.combineLatest<Set<ValidationError>, bool>(
            [
              budgetNameError$,
              budgetAmountError$,
              // budgetCategoryError$,
              // budgetRecurrenceError$,
              // startDateError$,
              // endDateError$
            ],
            (listOfSets) => listOfSets.every((errorsSet) => errorsSet.isEmpty),
          ),
          (_, isValid) => isValid,
        )
        .share();

    // Message stream
    final message$ = Rx.merge(
      [
        submit$
            .where((isValid) => isValid)
            .withLatestFrom6(
              budgetNameSubject,
              budgetAmountSubject,
              budgetCategorySubject,
              budgetRecurrenceSubject,
              budgetStartDateSubject,
              budgetEndDateSubject,
              (_, budgetname, budgetamount, budgetcategory, budgetrecurrence,
                      budgetstartdate, budgetenddate) =>
                  BudgetModel(budgetname, budgetamount, budgetcategory,
                      budgetrecurrence, budgetstartdate, budgetenddate, "Yes"),
            )
            .exhaustMap(
              (credential) => interactor.saveBudget(
                credential,
                isLoadingS,
              ),
            ),
        submit$
            .where((isValid) => !isValid)
            .map((_) => const InvalidInformationMessage()),
      ],
    ).publish();

    return BudgetBloc._(
      budgetNameChanged: budgetNameSubject.add,
      budgetAmountChanged: budgetAmountSubject.add,
      budgetCategoryChanged: budgetCategorySubject.add,
      budgetRecurrenceChanged: budgetRecurrenceSubject.add,
      budgetStartDateChanged: budgetStartDateSubject.add,
      budgetEndDateChanged: budgetEndDateSubject.add,
      submitBudget: () => submitBudget.add(null),
      budgetNameError$: budgetNameError$,
      budgetAmountError$: budgetAmountError$,
      budgetCategoryError$: budgetCategoryError$,
      budgetRecurrenceError$: budgetRecurrenceError$,
      budgetStartDateError$: startDateError$,
      budgetEndDateError$: endDateError$,
      isLoading$: isLoadingS.stream,
      message$: message$,
      dispose: DisposeBag([message$.connect(), ...subjects]).dispose,
    );
  }
}
