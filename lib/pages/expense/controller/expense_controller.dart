import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var totalExpense = 0.0.obs;
  var isLoading = true.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      if (userId.isEmpty) return;

      isLoading.value = true;
      var snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .orderBy('date', descending: true)
          .get();

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
      if (userId.isEmpty) return;

      isLoading.value = true;
      final expenseMap = {
        'name': expense.name,
        'amount': expense.amount,
        'category': expense.category,
        'description': expense.description,
        'date': Timestamp.fromDate(expense.date),
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add(expenseMap);

      fetchExpenses();
    } catch (e) {
      print('Error adding expense: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      if (userId.isEmpty) return;

      isLoading.value = true;
      await firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(id)
          .delete();

      fetchExpenses();
    } catch (e) {
      print('Error deleting expense: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      expenses.clear();
      totalExpense.value = 0;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Map<String, double> getMonthlyExpenses() {
    Map<String, double> monthlyTotals = {};
    
    for (var expense in expenses) {
      String monthYear = DateFormat('MMMM yyyy').format(expense.date);
      monthlyTotals[monthYear] = (monthlyTotals[monthYear] ?? 0) + expense.amount;
    }
    
    // Sort by date descending (newest first)
    var sortedEntries = monthlyTotals.entries.toList()
      ..sort((a, b) {
        var aDate = DateFormat('MMMM yyyy').parse(a.key);
        var bDate = DateFormat('MMMM yyyy').parse(b.key);
        return bDate.compareTo(aDate);
      });
    
    return Map.fromEntries(sortedEntries);
  }

  Map<String, double> getCategoryExpenses() {
    Map<String, double> categoryTotals = {};
    
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    
    // Sort by amount descending
    var sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries);
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.pink;
      case 'entertainment':
        return Colors.purple;
      case 'bills':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
