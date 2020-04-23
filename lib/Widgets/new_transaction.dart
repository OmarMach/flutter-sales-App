import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtransaction;

  NewTransaction(this.addtransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInputController = TextEditingController();
  final amountInputController = TextEditingController();
  DateTime _selectedDate;

  void _presentDatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null)
        return;
      else
        setState(() {
          _selectedDate = pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    void submitData() {
      if (amountInputController.text.isEmpty) return;
      var titleInput = titleInputController.text;
      var amountInput = double.parse(amountInputController.text);
      if (titleInput.isEmpty || amountInput <= 0 || _selectedDate == null) {
        return;
      }
      widget.addtransaction(titleInput, amountInput, _selectedDate);
      Navigator.of(context).pop();
    }

    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: titleInputController,
                //onSubmitted: (_) => submitData(),
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: amountInputController,
                //onSubmitted: (_) => submitData(),
                decoration: InputDecoration(labelText: "Price"),
              ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(_selectedDate == null
                            ? 'No date chosen'
                            : 'Picked date : ' +
                                DateFormat('dd/MM/yy').format(_selectedDate))),
                    FlatButton(
                      child: Text(
                        'Choose Date',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: _presentDatepicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text("Add"),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
