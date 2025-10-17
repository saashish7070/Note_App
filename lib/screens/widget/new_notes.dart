import 'package:flutter/material.dart';

class NotesFormBox extends StatefulWidget {
  const NotesFormBox({super.key});

  @override
  State<NotesFormBox> createState() => _NotesFormBoxState();
}

class _NotesFormBoxState extends State<NotesFormBox> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 0),
                spreadRadius: 1,
                blurStyle: BlurStyle.solid,
            ),
            ]
          ),
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(),
                ),
                const Center(
                  child: Text(
                    "Add Task",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 228, 226, 226),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 228, 226, 226),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pop(context,{
                      "title": _titleController.text,
                      "content":_contentController.text,
                    });
                  }
                }, child: Text("Submit"))
              ],
            )),
        ),
      ),
    );
  }
}
