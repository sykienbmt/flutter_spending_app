import 'package:flutter/material.dart';
import 'package:spending_app/widgets/chart.dart';
import 'package:spending_app/widgets/new_transaction.dart';
import 'package:spending_app/widgets/transaction_list.dart';
import './model/transaction.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Second App",
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: "Quicksand",
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        textTheme: ThemeData.light().textTheme.copyWith(
            titleMedium: const TextStyle(
                fontFamily: "Quicksand",
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleInputController = TextEditingController();
  final amountInputController = TextEditingController();

  final List<Transaction> _userTransaction = [];
  bool isShowChart = false;

  void _addTransaction(String title, double amount, DateTime selectedDate) {
    final newTrans = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      time: selectedDate,
    );
    setState(() {
      _userTransaction.add(newTrans);
    });
  }

  void _deleteTransaction(String idTransaction) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == idTransaction);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((element) {
      return element.time.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void showAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  final appBar = AppBar(
    title: const Text(
      "Spending app",
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.add_circle_outline_outlined),
        // onPressed: () => showAddTransaction(context),
        onPressed: () => {},
      )
    ],
  );

  List<Widget> _renderLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget renderTransactionList) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Show chart ?"),
        Switch.adaptive(
            value: isShowChart,
            onChanged: (val) {
              setState(() {
                isShowChart = val;
              });
            }),
      ]),
      isShowChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: MyChart(_recentTransactions),
            )
          : renderTransactionList,
    ];
  }

  List<Widget> _renderPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget renderTransactionList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: MyChart(_recentTransactions),
      ),
      renderTransactionList,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final renderTransactionList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        if (isLandscape)
          ..._renderLandscapeContent(
            mediaQuery,
            appBar,
            renderTransactionList,
          ),
        if (!isLandscape)
          ..._renderPortraitContent(
            mediaQuery,
            appBar,
            renderTransactionList,
          ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
