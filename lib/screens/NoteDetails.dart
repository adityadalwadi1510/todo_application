import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/model/Note.dart';
import 'package:todo_application/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetails(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetails(this.note, this.appBarTitle);
  }
}

class _NoteDetails extends State<NoteDetails> {
  static var prorityArray = ['High', 'Low'];
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  String proirity = "High";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetails(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                      title: DropdownButton(
                          items: prorityArray.map((String dropDownString) {
                            return DropdownMenuItem<String>(
                                value: dropDownString,
                                child: Text(dropDownString));
                          }).toList(),
                          style: textStyle,
                          value: updatePriorityIntToString(note.priority),
                          onChanged: (value) {
                            setState(() {
                              updatePriorityStringToInt(value);
                            });
                          })),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              child: Text(
                                'Save',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _save();
                                });
                              },
                            )),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                            child: RaisedButton(
                              color: Theme
                                  .of(context)
                                  .primaryColorDark,
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              child: Text(
                                'Delete',
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                setState(() {
                                  _delete();
                                });
                              },
                            ))
                      ],
                    ),
                  )
                ],
              )),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  void updatePriorityStringToInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String updatePriorityIntToString(int value) {
    String _priority;
    switch (value) {
      case 1:
        _priority = prorityArray[0];
        break;
      case 2:
        _priority = prorityArray[1];
        break;
    }
    return _priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {

    note.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) { //Update
      result = await databaseHelper.updateNote(note);
    } else { //Insert
      result = await databaseHelper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
    moveToLastScreen();
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
  void _delete() async{
    moveToLastScreen();
    if(note.id==null){
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    int result=await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleteing Note');
    }
  }
}
