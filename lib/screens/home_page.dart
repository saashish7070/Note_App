import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:free_note/screens/provider/user_provider.dart';
import 'package:free_note/screens/provider/note_provider.dart';
import 'package:free_note/models/note_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final notesProvider = context.watch<NotesProvider>();

    final userEmail = userProvider.user?.email ?? "";
    final userNotes =
        notesProvider.notes.where((note) => note.email == userEmail).toList();

    userNotes.sort((a, b) => b.isPinned ? 1 : -1);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${userEmail.isEmpty ? "Guest" : userEmail}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              userProvider.logout();
            },
          )
        ],
      ),
      body: userNotes.isEmpty
          ? const Center(child: Text("No notes yet. Add one!"))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemCount: userNotes.length,
              itemBuilder: (context, index) {
                final note = userNotes[index];
                return GestureDetector(
                  onTap: () => _showUpdateNoteDialog(context, note),
                  child: Card(
                    color: note.isPinned ? Colors.yellow[100] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              note.content,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  note.isPinned
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                  color: note.isPinned
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  context
                                      .read<NotesProvider>()
                                      .togglePin(note);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context
                                      .read<NotesProvider>()
                                      .deleteNoteWithConfirm(context, note);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context, userEmail);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, String userEmail) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Content"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  final note = Note(
                    title: titleController.text,
                    content: contentController.text,
                    email: userEmail,
                  );
                  context.read<NotesProvider>().addNote(note);
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateNoteDialog(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: "Content"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  final updatedNote = Note(
                    title: titleController.text,
                    content: contentController.text,
                    email: note.email,
                    isPinned: note.isPinned,
                  );
                  context.read<NotesProvider>().updateNote(note, updatedNote);
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
