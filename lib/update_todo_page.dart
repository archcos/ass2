import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Todo> fetchTodo() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/todos'),
  );

  if (response.statusCode == 200) {
    //print(response.statusCode); //to check if to do loaded successfully
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load To Do');
  }
}

Future<Todo> updateTodo(int id, String title, String completed) async {
  final response = await http.put(
    Uri.parse("https://jsonplaceholder.typicode.com/todos/$id"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'completed': completed,
    }),
  );

  if (response.statusCode == 200) {
    //print(response.statusCode); //to check if updated successfully
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.statusCode);
  }
}

class Todo {
  String? title;
  String? completed;

  Todo({required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class EditPage extends StatefulWidget {
  final dynamic todo;

  const EditPage({
    required this.todo,
    Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController completedController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  late Future<Todo> _futureTodo;
  List comChoice = ["", "true", "false"];
  String selectedChoice = '';

  @override
  void initState() {
    _futureTodo = fetchTodo() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Todo Page"),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: FutureBuilder<Todo>(
          future: _futureTodo,
          builder: (context, index) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'TITLE',
                  ),
                  validator: (value){
                    return (value == '')? "Input Title" : null;
                  },
                ),
                const SizedBox(height: 20,),
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
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    const snackBar = SnackBar(
                        content: Text('Updated Successfully')
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {
                      _futureTodo = updateTodo(
                          widget.todo["id"],
                          titleController.text,
                          completedController.text);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update To Do'),
                ),
              ],
            );
          }
        )
      ),
    );
  }
}
