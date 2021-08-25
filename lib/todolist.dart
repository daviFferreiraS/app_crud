import 'package:app_crud_2/loading.dart';
import 'package:app_crud_2/model/todo.dart';
import 'package:app_crud_2/services/database_services.dart';
import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplete = false;
  TextEditingController textTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coisas a Fazer",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTarefas(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              List<Todo> tarefas = snapshot.data;
              return Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        shrinkWrap: true,
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(tarefas[index].title),
                            background: Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            onDismissed: (direction) async {
                              await DatabaseService()
                                  .removeTarefa(tarefas[index].uid);
                            },
                            child: ListTile(
                                onTap: () {
                                  DatabaseService()
                                      .completeTarefa(tarefas[index].uid);
                                },
                                leading: Container(
                                  padding: EdgeInsets.all(2),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: tarefas[index].isComplete
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : Container(),
                                ),
                                title: Text(
                                  tarefas[index].title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            child: SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Adicionar Tarefa",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: textTitleController,
                  style: TextStyle(fontSize: 20, height: 1.5),
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "Fazer o app número 4",
                      border: InputBorder.none),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () async {
                        if (textTitleController.text.isNotEmpty) {
                          await DatabaseService()
                              .createnewTarefa(textTitleController.text.trim());
                          setState(() {
                            textTitleController.text = "";
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Adicionar à lista")),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
