import 'package:flutter/material.dart';
import '../Models/transaction.dart';
import 'transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(
      {@required this.transactions, @required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          child: transactions.isEmpty
              ? Column(
                  children: <Widget>[
                    Container(
                      height: constraints.maxHeight * 0.15,
                      child: Text(
                        'The list is empty',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.05,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.8,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ListItem(
                        transaction: transactions[index],
                        deleteTransaction: deleteTransaction);
                  },
                  itemCount: transactions.length));
    });
  }
}

