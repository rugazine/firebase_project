class Expense {
  String? id  ;
  String description;
  double amount;
  String category;
  DateTime date;

  Expense({
    this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Mengonversi Expense menjadi Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Membuat objek Expense dari Map (misalnya dari Firestore)
  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      description: map['description'] ?? '',
      amount: map['amount'] ?? 0.0,
      category: map['category'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
