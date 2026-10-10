// file: lib/models/vocabulary.dart
class Vocabulary {
  int id;
  String word;
  String meaning;

  Vocabulary({required this.id, required this.word, required this.meaning});
}

// Danh sách từ vựng dùng chung toàn app
List<Vocabulary> globalVocabs = [];