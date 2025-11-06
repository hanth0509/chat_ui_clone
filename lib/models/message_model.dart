import 'package:intl/intl.dart';

class Message {
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;
  final String? senderName;
  final MessageStatus status;

  Message({
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.senderName,
    this.status = MessageStatus.sent,
  });

  String get timeString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (timestamp.isAfter(today)) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (timestamp.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  Message copyWith({
    String? text,
    DateTime? timestamp,
    bool? isMe,
    MessageType? type,
    String? senderName,
    MessageStatus? status,
  }) {
    return Message(
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      senderName: senderName ?? this.senderName,
      status: status ?? this.status,
    );
  }
}

enum MessageType {
  text,
  image,
  voice,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}