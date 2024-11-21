import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../enums/menu_action.dart';
import '../../utilities/dialogs/generic_dialog.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    super.initState();
    _notesService=NotesService();
    _notesService.open();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    try {
                      await AuthService.firebase().logOut();
                    } catch (e) {
                      devtools.log(e.toString());
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.done:
                // print('Current user: ${_notesService._user}');
                return StreamBuilder(stream: _notesService.allNotes, builder: (context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes...');
                    case ConnectionState.active:
                      if(snapshot.hasData){
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        print('all notes:$allNotes');
                        return NotesListView(notes: allNotes, onDeleteNote: (note) async {
                          await _notesService.deleteNote(id: note.id);
                        }, onTap: (DatabaseNote note) async {
                          await Navigator.of(context).pushNamed(createOrUpdateNoteRoute,arguments: note);
                        },);
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },);
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
      },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
