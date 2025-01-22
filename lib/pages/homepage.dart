import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_firebase/pages/expense/controller/expense_controller.dart';
import 'package:project_firebase/pages/expense/view/expense_page.dart';

class Homepage extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    expenseController.fetchExpenses();

    return Scaffold(
      body: ExpensePage(),
    );
  }
}
