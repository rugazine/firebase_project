import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_firebase/pages/profile/profile_page.dart';
import 'controller/expense_controller.dart';
import 'model/expense_model.dart';
import 'package:project_firebase/pages/add_expense/screens/add_expense.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project_firebase/auth/auth_service.dart'; // Impor AuthService

class ExpensePage extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final AuthService authService = AuthService(); // Instance AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[700],
        title: Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Get.to(() => ProfilePage());
                  break;
                case 'logout':
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              authService.logout(); 
                            },
                          ),
                        ],
                      );
                    },
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Summary Cards
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Total Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Expenses',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(() {
                          return Text(
                            '\$${expenseController.totalExpense.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Quick Stats Row
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickStat(
                            'This Month',
                            Icons.calendar_today,
                            () {
                              final now = DateTime.now();
                              return expenseController.expenses
                                  .where((e) =>
                                      e.date.month == now.month &&
                                      e.date.year == now.year)
                                  .fold(0.0, (sum, e) => sum + e.amount);
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickStat(
                            'Average/Day',
                            Icons.show_chart,
                            () {
                              if (expenseController.expenses.isEmpty) return 0.0;
                              final total = expenseController.totalExpense.value;
                              final days = expenseController.expenses.length;
                              return total / days;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Recent Expenses Header & List
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Obx(() => Text(
                    '${expenseController.expenses.length} items',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  )),
                ],
              ),
            ),

            // Recent Expenses List
            Obx(() {
              if (expenseController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (expenseController.expenses.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text('No expenses yet', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: expenseController.expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenseController.expenses[index];
                  final isFirstOfDay = index == 0 ||
                      !isSameDay(expense.date,
                          expenseController.expenses[index - 1].date);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFirstOfDay) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          child: Text(
                            DateFormat('MMMM dd, yyyy').format(expense.date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                      Card(
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getCategoryIcon(expense.category),
                                color: Colors.blue[700]),
                          ),
                          title: Text(
                            expense.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy').format(expense.date),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[700],
                                ),
                              ),
                              Text(
                                expense.category,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Expense'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Are you sure you want to delete this expense?'),
                                      SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Icon(
                                              _getCategoryIcon(
                                                  expense.category),
                                              color: Colors.blue[700],
                                              size: 20),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(expense.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  '\$${expense.amount.toStringAsFixed(2)} - ${expense.category}',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        expenseController
                                            .deleteExpense(expense.id);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }),

            // Category Pie Chart
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    final categoryStats = expenseController.getCategoryExpenses();
                    if (categoryStats.isEmpty) return SizedBox();

                    return Container(
                      height: 200,
                      child: PieChart(
                        dataMap: categoryStats,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        colorList: categoryStats.keys.map((key) => 
                          expenseController.getCategoryColor(key)
                        ).toList(),
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Monthly Statistics
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    final monthlyStats = expenseController.getMonthlyExpenses();
                    if (monthlyStats.isEmpty) return SizedBox();

                    return Column(
                      children: monthlyStats.entries.map((entry) {
                        final percentage = (entry.value / expenseController.totalExpense.value * 100).clamp(0, 100);
                        
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    '\$${entry.value.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: percentage / 100,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[700],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${percentage.toStringAsFixed(1)}% of total',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddExpensePage()),
        backgroundColor: Colors.blue[700],
        icon: Icon(Icons.add),
        label: Text('Add Expense'),
      ),
    );
  }

  Widget _buildQuickStat(
      String title, IconData icon, double Function() getValue) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                '\$${getValue().toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      default:
        return Icons.attach_money;
    }
  }
}