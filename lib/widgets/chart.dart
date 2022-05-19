import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_app/model/transaction.dart';
import 'package:spending_app/widgets/chart_bar.dart';

class MyChart extends StatelessWidget {
  final List<Transaction> listTransaction;
  const MyChart(
    this.listTransaction, {
    Key? key,
  }) : super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (int i = 0; i < listTransaction.length; i++) {
        if (listTransaction[i].time.day == weekDay.day &&
            listTransaction[i].time.month == weekDay.month &&
            listTransaction[i].time.year == weekDay.year) {
          totalSum += listTransaction[i].amount;
        }
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    });
  }

  double get totalPending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((item) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                item['day'] as String,
                item['amount'] as double,
                totalPending == 0.0
                    ? 0.0
                    : (item['amount'] as double) / totalPending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
