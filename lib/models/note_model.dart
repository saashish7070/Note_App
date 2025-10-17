class Note {
  String title;
  String content;
  String email;
  bool isPinned;

  Note({
    required this.title,
    required this.content,
    required this.email,
    this.isPinned = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json["title"],
        content: json["content"],
        email: json["email"],
        isPinned: json["isPinned"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "email": email,
        "isPinned": isPinned,
      };
}


//My Note:
//factory -> constructor