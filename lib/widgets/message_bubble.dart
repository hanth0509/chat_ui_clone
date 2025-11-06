import 'package:flutter/material.dart';
import 'package:chat_ui_clone/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showMessageActions(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: 
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isMe) _buildAvatar(),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isMe 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!message.isMe && message.senderName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          message.senderName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    _buildMessageContent(context),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.timeString,
                          style: TextStyle(
                            color: message.isMe
                                ? Colors.white70
                                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                        if (message.isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIndicator(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.voice:
        return _buildVoiceMessage();
      case MessageType.system:
        return _buildSystemMessage();
      default:
        return _buildTextMessage(context);
    }
  }

  Widget _buildTextMessage(BuildContext context) {
    return Text(
      message.text,
      style: TextStyle(
        color: message.isMe
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://picsum.photos/200/300',
        width: 200,
        height: 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 150,
            color: Colors.grey.shade300,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / 
                      loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoiceMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: message.isMe 
            ? Colors.white.withOpacity(0.2)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_arrow,
            color: message.isMe ? Colors.white70 : Colors.grey.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '0:15',
            style: TextStyle(
              color: message.isMe ? Colors.white70 : Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
              color: message.isMe ? Colors.white30 : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: 16,
        child: Text(
          message.senderName != null ? message.senderName![0].toUpperCase() : 'J',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    IconData icon;
    Color color;
    
    switch (message.status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        color = Colors.white54;
        break;
      case MessageStatus.sent:
        icon = Icons.done;
        color = Colors.white54;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.white54;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.blue.shade200;
        break;
    }
    
    return Icon(icon, size: 14, color: color);
  }

  void _showMessageActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.reply,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text('Reply'),
                      onTap: () {
                        Navigator.pop(context);
                        _showReplySnackbar(context, message.text);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.copy,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text('Copy'),
                      onTap: () {
                        Navigator.pop(context);
                        _copyMessage(context, message.text);
                      },
                    ),
                    if (!message.isMe)
                      ListTile(
                        leading: Icon(
                          Icons.thumb_up,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text('React'),
                        onTap: () {
                          Navigator.pop(context);
                          _showReactions(context);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReplySnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reply to: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyMessage(BuildContext context, String text) {
    // In a real app, you'd use Clipboard.setData
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard')),
    );
  }

  void _showReactions(BuildContext context) {
    // Implement reaction picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reaction feature coming soon!')),
    );
  }
}