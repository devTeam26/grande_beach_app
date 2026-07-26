import 'package:flutter/material.dart';

/// Collapsible "Add-ons" row inside [PriceBreakdownCard]: a tappable
/// title/total header with a rotating chevron, expanded by default,
/// revealing the itemized add-on rows (plus their subtotal) when open.
class AddOnsBreakdownSection extends StatefulWidget {
  const AddOnsBreakdownSection({
    super.key,
    required this.title,
    required this.totalValue,
    required this.children,
    this.initiallyExpanded = true,
  });

  final String title;
  final String totalValue;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<AddOnsBreakdownSection> createState() =>
      _AddOnsBreakdownSectionState();
}

class _AddOnsBreakdownSectionState extends State<AddOnsBreakdownSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.totalValue,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
          secondChild: const SizedBox(width: double.infinity),
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}
