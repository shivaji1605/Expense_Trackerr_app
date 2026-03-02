import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'expense_model.dart';
import 'chart_widget.dart';
import 'export_service.dart';
import 'ocr_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void addExpense(Box<Expense> box) {
    box.add(
      Expense(
        title: "Food",
        amount: 200,
        category: "Food",
        date: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Expense Tracker")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Expense>('expenses').listenable(),
        builder: (context, Box<Expense> box, _) {
          final expenses = box.values.toList();

          return Column(
            children: [
              ExpenseChart(expenses: expenses),

              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (_, i) {
                    final e = expenses[i];
                    return ListTile(
                      title: Text(e.title),
                      subtitle: Text(e.category),
                      trailing: Text("₹${e.amount}"),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => ExportService.exportPDF(expenses),
                      child: const Text("PDF"),
                    ),
                    ElevatedButton(
                      onPressed: () => ExportService.exportExcel(expenses),
                      child: const Text("Excel"),
                    ),
                    ElevatedButton(
                      onPressed: () => OCRService.scanReceipt(context),
                      child: const Text("Scan"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final box = Hive.box<Expense>('expenses');
          return FloatingActionButton(
            onPressed: () => addExpense(box),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}