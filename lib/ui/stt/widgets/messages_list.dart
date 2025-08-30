import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key, required this.messages});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: messages.length,
        itemBuilder:
            (_, i) => Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  messages[i],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
      ),
    );
  }
}
