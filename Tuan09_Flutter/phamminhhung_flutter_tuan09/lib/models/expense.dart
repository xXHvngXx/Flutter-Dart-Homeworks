class Expense {
  int? id;
  String content;
  double amount;
  String note;

  Expense({this.id, required this.content, required this.amount, required this.note});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'amount': amount,
      'note': note,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      content: map['content'],
      amount: map['amount'],
      note: map['note'],
    );
  }
}