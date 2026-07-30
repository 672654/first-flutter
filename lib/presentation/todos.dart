import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {

List<dynamic>? _todos;

@override
  void initState() {
    super.initState();
    readTodos();
  }
/*
READ
*/
void readTodos() async {

  try {
    final response = await Supabase.instance.client
        .from('todo')
        .select();

    setState(() {
      _todos = response as List<dynamic>?;
    });
  } catch (error) {
    print('Error reading todos: $error');
  }
}

void createTodo(String itemname) async {
  await Supabase.instance.client
      .from('todo')
      .insert({'item': itemname});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: _todos == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _todos!.length,
              itemBuilder: (context, index) {
                final todo = _todos![index];
                return ListTile(
                  title: Text(todo['item']),
                );
              },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createTodo("New Todo");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
