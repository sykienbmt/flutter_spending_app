import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double, DateTime) addTransaction;
  NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInputController = TextEditingController();

  final amountInputController = TextEditingController();
  DateTime? _selectDate;

  void onAddNewTransaction() {
    if (amountInputController.text.isEmpty) {
      return;
    }

    final titleValue = titleInputController.text;
    final amountValue = double.parse(amountInputController.text);

    if (titleValue.isEmpty || amountValue <= 0 || _selectDate == null) {
      return;
    }

    widget.addTransaction(
      titleInputController.text,
      double.parse(amountInputController.text),
      _selectDate!,
    );
    //auto off popup
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((dateTime) {
      if (dateTime == null) {
        return;
      } else {
        setState(() {
          _selectDate = dateTime;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom +10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              controller: titleInputController,
              onSubmitted: (_) => {onAddNewTransaction()},
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
              controller: amountInputController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => {onAddNewTransaction()},
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectDate != null
                          ? DateFormat.yMd().format(_selectDate!)
                          : "No date choosen",
                    ),
                  ),
                  FlatButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      "Choose Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onAddNewTransaction();
              },
              child: const Text("Add Transaction"),
            )
          ],
        ),
      )),
    );
  }
}
