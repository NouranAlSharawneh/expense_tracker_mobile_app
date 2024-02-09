import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
const uuid =  Uuid();

// more like types
enum Category { food, travel, friends, university }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff_outlined,
  Category.friends: Icons.family_restroom_sharp,
  Category.university: Icons.book_sharp,
};

class Expense {
  Expense({
    required this.title, 
    required this.amount, 
    required this.date,
    required this.category
  }) : id = uuid.v4();

  final double amount;
  final Category category;
  final DateTime date;
  final String id;
  final String title;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category, 
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category) : expenses = allExpenses
        .where((expense) => expense.category == category)
        .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for(final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}