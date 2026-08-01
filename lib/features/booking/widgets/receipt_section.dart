import 'package:flutter/material.dart';

/// Plain, unboxed section used on the Booking Details screen — a bold
/// title followed by rows, blending into the screen's own background.
/// Sections are separated from one another with a [Divider], not a card.
class ReceiptSection extends StatelessWidget {
  const ReceiptSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
