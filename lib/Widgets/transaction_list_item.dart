import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/Models/transaction.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      elevation: 5,
      child: ListTile(
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        trailing: MediaQuery.of(context).size.width >= 400
            ? FlatButton.icon(
                onPressed: () => deleteTransaction(transaction.id),
                icon: Icon(Icons.delete),
                label: Text("Delete"))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(transaction.id)),
      ),
    );
  }
}
