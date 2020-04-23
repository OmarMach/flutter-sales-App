import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/Widgets/chart.dart';

import 'Widgets/new_transaction.dart';
import 'Widgets/transaction_list.dart';
import 'Models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.lime,
          accentColor: Colors.yellow,
          fontFamily: 'Opensans',
          textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
              title: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      title: 'Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return Wrap(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: NewTransaction(_addNewTransaction))
          ]);
        });
  }

  final amountInputController = TextEditingController();
  final titleInputController = TextEditingController();
  bool _showChart = false;
  final List<Transaction> _transactionlist = [
    Transaction(
        amount: 12,
        title: "Place holder 1",
        id: DateTime.now().toString(),
        date: DateTime.now()),
    Transaction(
        amount: 59.1,
        title: "Place holder 2",
        id: DateTime.now().toString(),
        date: DateTime.now()),
    Transaction(
        amount: 15,
        title: "Place holder 3",
        id: DateTime.now().toString(),
        date: DateTime.now())
  ];
  List<Transaction> get _recentTrasaction {
    return _transactionlist.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());

    setState(() {
      _transactionlist.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionlist.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    final _isLandscapre =
        mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personnal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Pesronal expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => startAddNewTransaction(context),
              )
            ],
          );
    final transactionList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _transactionlist,
        deleteTransaction: _deleteTransaction,
      ),
    );

    List<Widget> _buildLandscapeMode(MediaQueryData mediaQuery){
      return [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show chart', style: Theme.of(context).textTheme.title,),
              Switch.adaptive(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
              ),
            ],
          ),_showChart
              ? Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: Chart(_recentTrasaction),
                )
              : transactionList
      ];
    }
      
    List<Widget> _buildPortraitMode(MediaQueryData mediaQuery){
      return [
        Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.3,
            child: Chart(_recentTrasaction),
          ),transactionList,
      ];
    }
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_isLandscapre)
          ..._buildLandscapeMode(mediaQuery),
        if (!_isLandscapre)
          ..._buildPortraitMode(mediaQuery)
      ],
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child:  SafeArea(child: body),
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => startAddNewTransaction(context),
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
            body: body);
  }
}
