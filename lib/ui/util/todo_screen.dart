import 'package:flutter/material.dart';
import 'package:todoapp/ui/model/todo_item.dart';
import 'package:todoapp/ui/util/database_client.dart';
import 'package:todoapp/ui/util/dateFormated.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    super.initState();

    _readToDoList();
  }

  void _handlerSubmit(String text) async {
    _textEditingController.clear();

    ToDoItem toDoItem = new ToDoItem(text, dateFormated());
    int savedItemId = await db.saveItem(toDoItem);

    ToDoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem); //used to populate listvew
    });

    print("Item id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          new Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (context, int index) {
                return Card(
                  color: Colors.white10,
                  child: new ListTile(
                    title: _itemList[index],
                    onLongPress: () => _updateToDoList(_itemList[index], index),
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) {
                        _deleteToDoList(_itemList[index].id, index);
                        _snackBar("Item Deleted!");
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        onPressed: _showFromDialog,
      ),
    );
  }

  void _showFromDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: new TextField(
              controller: _textEditingController,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg. Add note",
                  icon: Icon(Icons.note_add)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // _textEditingController.clear();
            if (_textEditingController.text.isEmpty) {
              debugPrint("Empty");
              _snackBar("Note can't be empty!");
            } else {
              _handlerSubmit(_textEditingController.text);
              _snackBar("Note saved!");
            }
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  _readToDoList() async {
    List items = await db.getItems();

    if (items == null) {
      _snackBar("lolololol");
    } else {
      items.forEach((item) {
        // ToDoItem toDoItem = ToDoItem.map(item);
        setState(() {
          _itemList.add(ToDoItem.map(item));
          // print("Items: ${toDoItem.itemName}");
          _snackBar("not null");
        });
      });
    }
  }

  _deleteToDoList(int id, int index) async {
    debugPrint("Deleted!");
    await db.deleteItem(id);

    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateToDoList(ToDoItem item, int index) {
    var alert = AlertDialog(
      title: new Text("Update note"),
      content: Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item",
                hintText: "eg. Update note",
                icon: new Icon(Icons.update),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            ToDoItem updateItem = ToDoItem.fromMap({
              "itemName": _textEditingController.text,
              "dateCreated": dateFormated(),
              "id": item.id
            });
            _handlerSubmitUpdate(index, item); //redrawing scree
            await db.updateItem(updateItem); //updating note

            setState(() {
              _readToDoList(); //redrawing screen again with updated items
            });
            _snackBar("Note Updated!");
            Navigator.pop(context);
          },
          child: new Text("Update"),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context),
          child: new Text("Cancel"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _handlerSubmitUpdate(int index, ToDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });
    });
  }

  void _snackBar(String message) {
    final snackBar = new SnackBar(
      content: new Text(
        message,
        style: TextStyle(
          fontSize: 17.0,
        ),
      ),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     debugPrint("Undo");
      //   },
      // ),
      // backgroundColor: Theme.of(context).backgroundColor,
      duration: new Duration(milliseconds: 500),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
