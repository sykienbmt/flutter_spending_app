import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_app/model/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(this.transactions, this.deleteTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
          return Container(
            height: constraints.maxHeight *0.7,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/nothing.png',
                  fit: BoxFit.cover,
                )
              ],
            ),
          );
        })) 
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                          child: Text(
                              '${transactions[index].amount.toStringAsFixed(0)}k')),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].time)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () {
                      deleteTransaction(transactions[index].id);
                    },
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
