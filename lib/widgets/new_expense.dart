// adding a new expense
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.travel;

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();

  }

  void _submitFormDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if(_titleController.text.trim().isEmpty || 
        amountIsInvalid || 
        _selectedDate == null) 
    {
      showDialog(
        context: context, 
        builder: (ctnx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('please make sure a valid input is entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctnx);
              }, 
              child: const Text('Okay')
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(Expense(
      title: _titleController.text, 
      amount: enteredAmount, 
      date: _selectedDate!, 
      category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate,
      lastDate: now
    );
    // this line will excute after the value is avaible
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('expense name')
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('amount')
                  ),
                )  
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null ? 'No date is selcted' : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _showDatePicker,
                      icon: const Icon(Icons.calendar_month_outlined),
                    )
                  ],
                )
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase(),
                    ),
                  ),
                ).toList(), 
                onChanged: (value) {
                  if(value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text('cancel')
              ),
              ElevatedButton(
                onPressed: _submitFormDate, 
                child: const Text('save expense'),
              ),
            ],
          )
        ]
      ),
    );
  }
}