class MessagesModel {
  final String message;
  final String sender;
  final DateTime time;

  MessagesModel({
    required this.message,
    required this.sender,
    required this.time,
  });

  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    return MessagesModel(
      message: json['body'] ?? '',
      sender: json['address'],
      time:
          DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['date']) ?? 0),
    );
  }

  @override
  String toString() {
    return 'MessagesModel{message: $message, sender: $sender, time: ${time.toIso8601String()}}';
  }
}
