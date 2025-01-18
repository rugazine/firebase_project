import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });
}
