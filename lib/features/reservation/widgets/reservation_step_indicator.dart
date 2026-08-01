import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Four-step progress indicator: a circle per step connected by dashed
/// lines, with the step name shown underneath. Completed steps are filled
/// gold with a checkmark, the current step is a gold ring with a gold dot,
/// upcoming steps are plain grey outlines.
class ReservationStepIndicator extends StatelessWidget {
  const ReservationStepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  /// Zero-based index of the current step (0..3).
  final int currentStep;
  final List<String> stepLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.25);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < stepLabels.length; i++)
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: i == 0
                            ? const SizedBox(height: 2)
                            : _DashedLine(
                                filled: i - 1 < currentStep,
                                inactiveColor: inactiveColor,
                              ),
                      ),
                      _StepCircle(
                        isCompleted: i < currentStep,
                        isCurrent: i == currentStep,
                        inactiveColor: inactiveColor,
                      ),
                      Expanded(
                        child: i == stepLabels.length - 1
                            ? const SizedBox(height: 2)
                            : _DashedLine(
                                filled: i < currentStep,
                                inactiveColor: inactiveColor,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stepLabels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          i == currentStep ? FontWeight.w700 : FontWeight.w500,
                      color: i == currentStep
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.isCompleted,
    required this.isCurrent,
    required this.inactiveColor,
  });

  final bool isCompleted;
  final bool isCurrent;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: AppColors.primaryGold,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
      );
    }

    if (isCurrent) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGold, width: 2),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.primaryGold,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: inactiveColor, width: 2),
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.filled, required this.inactiveColor});

  final bool filled;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: CustomPaint(
        size: const Size(double.infinity, 2),
        painter: _DashedLinePainter(
          color: filled ? AppColors.primaryGold : inactiveColor,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  static const _dashWidth = 4.0;
  static const _dashGap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + _dashWidth, size.height / 2),
        paint,
      );
      x += _dashWidth + _dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
