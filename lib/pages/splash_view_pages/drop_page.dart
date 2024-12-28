import 'package:flutter/material.dart';

class DropPage extends StatelessWidget {
  const DropPage({super.key, required this.incrementPage});

  final VoidCallback incrementPage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 12),
          Column(
            children: [
              const Text(
                'Welcome to CitiGuide',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Text(
                'Your travel companion',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: incrementPage,
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 6),
                    Text('Continue', style: TextStyle(fontSize: 16)),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
