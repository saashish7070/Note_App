import 'dart:convert';
import 'package:free_note/models/note_model.dart';
import 'package:free_note/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteStorage {
  static const String _keyNotes = "notes";

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((note) => json.encode(note.toJson())).toList();
    await prefs.setStringList(_keyNotes, jsonList);
  }

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyNotes) ?? [];
    return jsonList
        .map((str) => Note.fromJson(json.decode(str)))
        .toList();
  }

  static Future<void> clearNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNotes);
  }
}


class UserStorage{
  static const String _userKey = "user";

  static Future<void> saveUser(List<User> users) async{
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((user)=> json.encode(user.toJson())).toList();
    await prefs.setStringList(_userKey,jsonList);
  }

  static Future<List<User>> loadUser() async{
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_userKey) ?? [];
    return jsonList.map((str) => User.fromJson(json.decode(str))).toList();
  }
}