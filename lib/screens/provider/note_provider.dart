import 'package:flutter/material.dart';
import 'package:free_note/models/note_model.dart';
import 'package:free_note/utils/shared_prefs.dart';
import 'package:free_note/screens/widget/alert_dialog.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;
  
  Future<void> loadNotes() async {
    _notes = await NoteStorage.loadNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await NoteStorage.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    _notes.remove(note);
    await NoteStorage.saveNotes(_notes);
    notifyListeners();
  }

  Future<void> deleteNoteAt(int index) async {
    if (index >= 0 && index < _notes.length) {
      _notes.removeAt(index);
      await NoteStorage.saveNotes(_notes);
      notifyListeners();
    }
  }

  Future<void> updateNote(Note oldNote, Note newNote) async {
  final index = _notes.indexOf(oldNote);
  if (index != -1) {
    _notes[index] = newNote;
    await NoteStorage.saveNotes(_notes);
    notifyListeners();
  }
}

Future<void> togglePin(Note note) async {
  final index = _notes.indexOf(note);
  if (index != -1) {
    _notes[index].isPinned = !_notes[index].isPinned;
    await NoteStorage.saveNotes(_notes);
    notifyListeners();
  }
}

Future<void> deleteNoteWithConfirm(BuildContext context, Note note) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return DeleteAlertDialog(
        title: "Delete Note",
        content: "Are you sure you want to delete?",
        );
    },
  );

  if (shouldDelete == true) {
    _notes.remove(note);
    await NoteStorage.saveNotes(_notes);
    notifyListeners();
  }
}

}


