import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];
  HomePage() {
    items = [];
    // items.addAll([
    //   Item(id: 1, title: "Estudar React", done: true),
    //   Item(id: 2, title: "Estudar Flutter", done: false),
    //   Item(id: 3, title: "Estudar Angular", done: true)
    // ]);
    // items.add(Item(id: 4, title: "Estudar Firebase", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void add() {
    if (newTaskController.text.trim().isEmpty) return;
    setState(() {
      widget.items.add(Item(
          id: widget.items.length + 1,
          title: newTaskController.text,
          done: false));
      newTaskController.text = "";
    });
    save();
  }

  void remove(index) {
    setState(() {
      widget.items.removeAt(index);
    });
    save();
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decode = jsonDecode(data);
      List<Item> result = decode.map((item) => Item.fromJson(item)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          decoration: InputDecoration(
              labelText: "New Task",
              labelStyle: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items[index];
            return Dismissible(
              key: Key(item.id.toString()),
              child: CheckboxListTile(
                title: Text(item.title),
                key: Key(item.id.toString()),
                value: item.done,
                onChanged: (value) {
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              background: Container(
                color: Colors.red.withOpacity(0.9),
              ),
              onDismissed: (direction) {
                remove(index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class InputTodoTask extends StatefulWidget {
  @override
  _InputTodoTaskState createState() => _InputTodoTaskState();
}

class _InputTodoTaskState extends State<InputTodoTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(),
    );
  }
}
