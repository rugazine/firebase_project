import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_firebase/pages/expense/controller/expense_controller.dart';
import 'package:project_firebase/pages/expense/expense_page.dart';

class Homepage extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    // Memuat data pengeluaran saat halaman ini ditampilkan
    expenseController.fetchExpenses();

    return Scaffold(
      body: ExpensePage(), // Menampilkan halaman pengeluaran
    );
  }
}
