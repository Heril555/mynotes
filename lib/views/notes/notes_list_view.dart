import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({super.key, required this.notes, required this.onDeleteNote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
              note.text??'Dummy',
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Ensures the Row is only as wide as its content
            children: [
              IconButton(onPressed: () async {
                Share.share(note.text);
              }, icon: Icon(Icons.share)),
              IconButton(onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if(shouldDelete){
                  onDeleteNote(note);
                }
              }, icon: Icon(Icons.delete)),
            ],
          ),
          onTap: () {
            onTap(note);
          },
        );
      },
    );
  }
}

