import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_firebase/pages/expense/model/expense_model.dart';

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var totalExpense = 0.0.obs;
  var isLoading = true.obs; // Tambahkan isLoading state

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  void fetchExpenses() async {
    try {
      isLoading.value = true;
      var snapshot = await firestore.collection('expenses').get();

      var expenseList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Expense(
          id: doc.id,
          name: data['name'] ?? '',
          amount: (data['amount'] ?? 0.0).toDouble(),
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();

      expenses.assignAll(expenseList);
      totalExpense.value =
          expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      print('Error fetching expenses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final expenseMap = {
        'name': expense.name,
        'amount': expense.amount,
        'category': expense.category,
        'description': expense.description,
        'date': Timestamp.fromDate(expense.date),
      };

      var docRef = await firestore.collection('expenses').add(expenseMap);

      // Buat expense baru dengan ID yang digenerate
      final newExpense = Expense(
        id: docRef.id,
        name: expense.name,
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        date: expense.date,
      );

      expenses.add(newExpense);
      totalExpense.value += expense.amount;
    } catch (e) {
      print('Error adding expense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await firestore.collection('expenses').doc(id).delete();
      final expense = expenses.firstWhere((e) => e.id == id);
      expenses.remove(expense);
      totalExpense.value -= expense.amount;
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }
}
