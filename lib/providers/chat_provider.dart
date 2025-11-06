import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [
    Message(
      text: "Hey! How are you doing?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isMe: false,
      senderName: "John Doe",
      status: MessageStatus.read,
    ),
    Message(
      text: "I'm good! Just working on some Flutter projects.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      isMe: true,
      status: MessageStatus.read,
    ),
    Message(
      text: "That's awesome! What are you building?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      isMe: false,
      senderName: "John Doe",
      status: MessageStatus.read,
    ),
    Message(
      text: "A chat UI clone similar to WhatsApp with Provider state management",
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isMe: true,
      status: MessageStatus.read,
    ),
  ];

  List<Message> get messages => _messages;
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void addMessage(String text) {
    if (text.trim().isEmpty) return;
    
    // Add sending message
    final newMessage = Message(
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sending,
    );
    
    _messages.add(newMessage);
    notifyListeners();

    // Auto scroll to bottom
    scrollToBottom();

    // Simulate message sending process
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageStatus(_messages.length - 1, MessageStatus.sent);
      
      Future.delayed(const Duration(milliseconds: 300), () {
        _updateMessageStatus(_messages.length - 1, MessageStatus.delivered);
        
        Future.delayed(const Duration(milliseconds: 500), () {
          _updateMessageStatus(_messages.length - 1, MessageStatus.read);
          _simulateTyping();
        });
      });
    });
  }

  void _updateMessageStatus(int index, MessageStatus status) {
    _messages[index] = _messages[index].copyWith(status: status);
    notifyListeners();
  }

  void _simulateTyping() {
    _isTyping = true;
    notifyListeners();
    
    Future.delayed(const Duration(seconds: 2), () {
      _isTyping = false;
      notifyListeners();
      _addAutoReply();
    });
  }

  void _addAutoReply() {
    final replies = [
      "That's cool! 🚀",
      "I see what you did there!",
      "Nice implementation!",
      "Flutter is amazing, right?",
      "The UI looks great!",
    ];
    
    final randomReply = replies[DateTime.now().millisecond % replies.length];
    
    final replyMessage = Message(
      text: randomReply,
      timestamp: DateTime.now(),
      isMe: false,
      senderName: "John Doe",
      status: MessageStatus.read,
    );
    
    _messages.add(replyMessage);
    notifyListeners();
    scrollToBottom();
  }

  // Đổi từ _scrollToBottom thành scrollToBottom (public method)
  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}