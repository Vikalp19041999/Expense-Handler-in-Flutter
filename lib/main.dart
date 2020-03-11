import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'expenseList.dart';
import 'form.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final expenses = ExpenseListModel();
  runApp(ScopedModel<ExpenseListModel>(
    model: expenses,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Handle Your Expenses'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: ScopedModelDescendant<ExpenseListModel>(
          builder: (context, child, expenses) {
            return ListView.separated(
              itemCount: expenses.items == null ? 1 : expenses.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text(
                    "Total expenses: " + expenses.totalExpense.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ));
                } else {
                  index = index - 1;
                  return Dismissible(
                      key: Key(expenses.items[index].id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expenses.items[index]);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Item is dismissed")));
                      },
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormPage(
                                          id: expenses.items[index].id,
                                        )));
                          },
                          leading: Icon(Icons.monetization_on, color: Colors.black),
                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black,),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(expenses.items[index].category + ':',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  Text(expenses.items[index].amount.toString(),
                                  style: TextStyle(
                                    fontSize:21
                                  ),),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Date Spent On :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22)),
                                  Text(expenses.items[index].formattedDate,
                                  style: TextStyle(
                                    fontSize:21
                                  )),
                                ],
                              ),
                            ],
                          )));
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<ExpenseListModel>(
            builder: (context, child, expenses) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScopedModelDescendant<ExpenseListModel>(
                              builder: (context, child, expenses) {
                            return FormPage(
                              id: 0,
                              expenses: expenses,
                            );
                          })));
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
          );
        }));
  }
}

