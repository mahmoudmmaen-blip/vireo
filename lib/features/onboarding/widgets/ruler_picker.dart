import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Interactive horizontal ruler picker with center indicator line and haptic ticks on every notch.
class RulerPicker extends StatefulWidget {
  const RulerPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
    this.step = 1.0,
    this.unit = '',
    this.itemWidth = 10.0,
    this.height = 110.0,
  });

  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double> onChanged;
  final double step;
  final String unit;
  final double itemWidth;
  final double height;

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  late ScrollController _scrollController;
  late double _currentValue;
  int _lastTickIndex = -1;

  int get _itemCount =>
      ((widget.maxValue - widget.minValue) / widget.step).round() + 1;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue.clamp(widget.minValue, widget.maxValue);
    final initialIndex = ((_currentValue - widget.minValue) / widget.step).round();
    _lastTickIndex = initialIndex;
    _scrollController = ScrollController(
      initialScrollOffset: initialIndex * widget.itemWidth,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final index = (offset / widget.itemWidth).round().clamp(0, _itemCount - 1);
    if (index != _lastTickIndex) {
      _lastTickIndex = index;
      HapticFeedback.selectionClick();
      final val = (widget.minValue + (index * widget.step));
      final clamped = val.clamp(widget.minValue, widget.maxValue);
      if (clamped != _currentValue) {
        setState(() => _currentValue = clamped);
        widget.onChanged(clamped);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final halfWidth = MediaQuery.sizeOf(context).width / 2.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Big value readout
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              widget.step < 1.0
                  ? _currentValue.toStringAsFixed(1)
                  : _currentValue.round().toString(),
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: colors.text,
                letterSpacing: -0.5,
              ),
            ),
            if (widget.unit.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                widget.unit,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.ember,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Ruler track
        SizedBox(
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _onScroll();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: halfWidth),
                  itemCount: _itemCount,
                  itemBuilder: (context, index) {
                    final isMajor = index % 10 == 0;
                    final isMid = index % 5 == 0 && !isMajor;

                    return SizedBox(
                      width: widget.itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: isMajor ? 2.5 : (isMid ? 2.0 : 1.2),
                            height: isMajor ? 36.0 : (isMid ? 24.0 : 14.0),
                            decoration: BoxDecoration(
                              color: isMajor
                                  ? colors.text
                                  : (isMid
                                      ? colors.textMute
                                      : colors.textMute.withValues(alpha: 0.4)),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          if (isMajor) ...[
                            const SizedBox(height: 6),
                            Text(
                              '${(widget.minValue + (index * widget.step)).round()}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colors.textMute,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Center fixed needle / pointer
              Positioned(
                top: 8,
                child: Column(
                  children: [
                    Container(
                      width: 3.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: colors.ember,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: colors.ember.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Icon(
                      Icons.arrow_drop_up_rounded,
                      color: colors.ember,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
