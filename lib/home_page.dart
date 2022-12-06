import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'update_todo_page.dart';
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List todos = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getTodo();
  }

  getTodo() async {
    var url = 'https://jsonplaceholder.typicode.com/todos';
    var response = await http.get(Uri.parse(url));

    setState(() {
      todos = convert.jsonDecode(response.body) as List<dynamic>;
      }
    );
  }

  deleteTodo(int id) async {
    var response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'));

    if (response.statusCode == 200) {
      //print (response.statusCode); //to check if addTodo is success
    } else {
      throw Exception('${response.statusCode}: FAILED TO DELETED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
        ),
        body: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title:Text('ID: ${todos[index]['id']}'),
                subtitle: Text('User ID: ${todos[index]['userId']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () async{
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => EditPage(todo: todos[index])
                            )
                          );
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          final snackBar = SnackBar(
                                content: Text('ID: ${todos[index]['id']} Deleted Successfully')
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          deleteTodo(todos[index]['id']);
                          setState(() {
                             todos.remove(todos[index]);
                          });
                        },
                        icon: const Icon(Icons.delete)
                    )
                  ],
                 ),
                children: [
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.all(15)),
                      Text('Title: ${todos[index]['title']}')
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.all(15)),
                      Text('Completed: ${todos[index]['completed']}')
                    ],
                  )
                ],
              );
            }
         ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            var postTodo = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FormPage()
                )
              );
            if (postTodo!=null){
              setState(() {
                todos.add(postTodo);
              });
            }
          },
          child: const Icon(Icons.add),
      ),
    );
  }
}