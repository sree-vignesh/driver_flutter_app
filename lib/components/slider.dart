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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 48; // account for padding
    const knobSize = 56.0;

    return GestureDetector(
      onHorizontalDragUpdate: widget.enabled
          ? (details) {
              setState(() {
                _dragX += details.primaryDelta!;
                _dragX = _dragX.clamp(0.0, width - knobSize);
              });
            }
          : null,
      onHorizontalDragEnd: widget.enabled
          ? (_) {
              if (_dragX > width * 0.7) {
                widget.onConfirmed();
              }
              setState(() => _dragX = 0.0); // reset after drag
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background bar
          Container(
            height: knobSize,
            decoration: BoxDecoration(
              color: widget.enabled ? AppColors.primary : Colors.green,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // soft shadow
                  blurRadius: 8, // how soft the shadow is
                  offset: const Offset(0, 4), // move shadow down
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
            ),
          ),

          // Knobw
          if (widget.enabled)
            Positioned(
              left: _dragX,
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Icon(Icons.arrow_forward, color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
