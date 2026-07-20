import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database_helper.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  
  List<Transaction> get transactions => _transactions;

  double get totalBalance {
    double balance = 0;
    for (var tx in _transactions) {
      balance += (tx.type == 'income') ? tx.amount : -tx.amount;
    }
    return balance;
  }

  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == 'income')
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == 'expense')
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  Future<void> fetchTransactions() async {
    _transactions = await DatabaseHelper.instance.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction tx) async {
    await DatabaseHelper.instance.insert(tx);
    await fetchTransactions();
  }

  Future<void> removeTransaction(int id) async {
    await DatabaseHelper.instance.delete(id);
    await fetchTransactions();
  }

  // Laporan Logika
  List<Transaction> filterByDay(DateTime date) {
    return _transactions.where((tx) => 
      tx.date.year == date.year && tx.date.month == date.month && tx.date.day == date.day
    ).toList();
  }

  List<Transaction> filterByMonth(DateTime date) {
    return _transactions.where((tx) => 
      tx.date.year == date.year && tx.date.month == date.month
    ).toList();
  }

  List<Transaction> filterByYear(DateTime date) {
    return _transactions.where((tx) => 
      tx.date.year == date.year
    ).toList();
  }
}
