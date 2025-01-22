// lib/bindings/expense_binding.dart
import 'package:get/get.dart';
import 'package:project_firebase/pages/add_expense/controller/expense_controller.dart'; // Path yang sesuai

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseController>(() => ExpenseController());
  }
}