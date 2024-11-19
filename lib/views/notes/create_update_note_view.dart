import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';

import '../../services/crud/notes_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  String? text;

  void _textControllerListener() async{
    final note = _note;
    if(note==null){
      return;
    }
    final text = _textController.text;
    print('text2 $text');
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async{
    final widgetNote = context.getArgument<DatabaseNote>();
    if(widgetNote!=null){
      _note=widgetNote;
      _textController.text = widgetNote.text!;
      return widgetNote;
    }
    final existingNote = _note;
    if(existingNote!=null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty(){
    final note = _note;
    if(_textController.text.isEmpty && note!=null){
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async{
    final note = _note;
    final text = _textController.text;
    if(note!=null && text.isNotEmpty){
      print('text1 : $text');
      await _notesService.updateNote(note: note, text: text);
    }
  }

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _textController=TextEditingController();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(future: createOrGetExistingNote(context), builder: (context, snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.done:
            _note = snapshot.data as DatabaseNote;
            _setupTextControllerListener();
            return Column(
              children: [
                TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    // setState(() {
                    //   text=value;
                    // });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start writing your note...'
                  ),
                ),
                // Center(
                //   child: Text(text??""),
                // ),
              ],
            );
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },),
    );
  }
}