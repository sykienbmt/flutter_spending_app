class Transaction {
  late String id;
  late String title;
  num amount;
  DateTime time;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.time
  });
}
