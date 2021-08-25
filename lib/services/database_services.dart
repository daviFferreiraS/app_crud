import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_crud_2/model/todo.dart';

class DatabaseService {
  CollectionReference tarefaCollection =
      FirebaseFirestore.instance.collection("Tarefas");

  Future createnewTarefa(String title) async {
    return await tarefaCollection.add({"title": title, "isComplete": false});
  }

  Future completeTarefa(uid) async {
    await tarefaCollection.doc(uid).update({"isComplete": true});
  }

  Future removeTarefa(uid) async {
    await tarefaCollection.doc(uid).delete();
  }

  List<Todo> tarefafromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(
            isComplete: e.data()["isComplete"],
            title: e.data()["title"],
            uid: e.id);
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>> listTarefas() {
    return tarefaCollection.snapshots().map(tarefafromFirestore);
  }
}
