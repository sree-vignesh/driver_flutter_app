import 'package:flutter/material.dart';
import '../core/colors.dart';

class SliderButton extends StatefulWidget {
  final String text;
  final bool enabled;
  final VoidCallback onConfirmed;

  const SliderButton({
    super.key,
    required this.text,
    required this.enabled,
    required this.onConfirmed,
  });

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  double _dragX = 0.0;

  // tweak these to change spacing/size
  static const double _barHeight = 56.0;
  static const double _knobOuterSize =
      56.0; // used for initial visual reference
  static const double _knobInnerSize = 48.0; // actual knob inside the bar
  static const double _leftPadding =
      4.0; // "a little bit of space" before circle
  static const double _rightPadding = 4.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;

        // how far the knob may travel (delta from the initial leftPadding)
        final double maxDrag =
            (barWidth - _leftPadding - _knobInnerSize - _rightPadding).clamp(
              0.0,
              double.infinity,
            );

        // knobLeft is the absolute left coordinate inside the bar
        final double knobLeft = _leftPadding + _dragX.clamp(0.0, maxDrag);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: widget.enabled
              ? (details) {
                  setState(() {
                    // accumulate delta and clamp to [0, maxDrag]
                    _dragX = (_dragX + (details.primaryDelta ?? 0)).clamp(
                      0.0,
                      maxDrag,
                    );
                  });
                }
              : null,
          onHorizontalDragEnd: widget.enabled
              ? (_) {
                  // confirm if user dragged past 70% of the available drag range
                  if (_dragX >= (maxDrag * 0.7)) {
                    widget.onConfirmed();
                  }
                  // reset to start
                  setState(() {
                    _dragX = 0.0;
                  });
                }
              : null,
          child: Stack(
            clipBehavior:
                Clip.none, // allow knob shadow to overflow without being cut
            children: [
              // background bar
              Container(
                width: barWidth,
                height: _barHeight,
                decoration: BoxDecoration(
                  color: widget.enabled ? AppColors.primary : Colors.green,
                  borderRadius: BorderRadius.circular(_barHeight), // pill shape
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // knob
              if (widget.enabled)
                Positioned(
                  left: knobLeft,
                  top: ((_barHeight - _knobInnerSize) / 2),
                  child: Container(
                    width: _knobInnerSize,
                    height: _knobInnerSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_knobInnerSize),
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_forward, color: AppColors.primary),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
