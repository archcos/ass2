import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Todo> postTodo(int? id, int? userId, String? title, String? completed) async {
  final response = await http.post(
    Uri.parse("https://jsonplaceholder.typicode.com/todos"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'completed': completed,
    }),
  );

  if (response.statusCode == 201) {
    //print (response.statusCode); //to check if addTodo is success
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Todo');
  }
}

class Todo {
  int? id;
  int? userId;
  String? title;
  String? completed;

  Todo({this.id, this.userId, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final TextEditingController idController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController completedController = TextEditingController();

  Future<Todo>? _futureTodo;
  var formKey = GlobalKey<FormState>();
  List comChoice = ["", "true", "false"];
  String selectedChoice = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add To Do"),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: FutureBuilder<Todo>(
          future: _futureTodo,
          builder: (context, index) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  controller: idController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'ID',
                      hintText: 'ID'
                  ),
                  validator: (value){
                    return (value == '')? "Input ID" : null;
                  },
                ),
                TextFormField(
                  controller: userIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'User ID',
                      hintText: 'User ID'
                  ),
                  validator: (value){
                    return (value == '')? "Input User ID" : null;
                  },
                ),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Title'
                  ),
                  validator: (value){
                    return (value == '')? "Input Title" : null;
                  },
                ),
                DropdownButtonFormField(
                    value: selectedChoice,
                    decoration: const InputDecoration(
                      labelText: 'Completed',
                    ),
                    validator: (value){
                      return (value == '')? "Choose Progress" : null;
                    },
                    items: [
                      ...comChoice.map((choices) => DropdownMenuItem(
                          value: choices,
                          child: Text(choices)))
                    ],
                    onChanged: (value){
                      setState(() {
                        selectedChoice = value as String;
                      }
                      );
                      completedController.text = selectedChoice;
                    }
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        const snackBar = SnackBar(
                            content: Text('Created Successfully')
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          postTodo(
                              int.parse(idController.text),
                              int.parse(userIdController.text),
                              titleController.text,
                              completedController.text);
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add To Do')
                ),
              ],
            );
          }
        ),
      )
    );
  }
}
