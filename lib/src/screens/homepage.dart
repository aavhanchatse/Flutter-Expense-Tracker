import 'dart:io';

import 'package:expense_tracker/src/widgets/chart.dart';
import 'package:expense_tracker/src/widgets/newtransactions.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/models/transactions.dart';
import 'package:expense_tracker/src/widgets/transactionlist.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: '1',
    //   title: 'Shoes',
    //   amount: 1000,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: '1',
    //   title: 'Adapter',
    //   amount: 900,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction
        .where((element) => element.date.isAfter(
              DateTime.now().subtract(
                Duration(days: 7),
              ),
            ))
        .toList();
  }

  void _addTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _openModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransactions(_addTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget,
    ];
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracker'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _openModal(context),
                )
              ],
            ),
          )
        : AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _openModal(context),
              ),
            ],
            title: Text('Expense Tracker'),
            centerTitle: true,
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
          if (!isLandscape)
            ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openModal(context),
                  ),
          );
  }
}
