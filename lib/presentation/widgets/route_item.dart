import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteListItem extends StatelessWidget {
  final String routeName;
  final bool isLast; // Keeping this parameter for compatibility

  const RouteListItem({
    super.key,
    required this.routeName,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineComponent(isLast),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            routeName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineComponent(bool isLast) {
    return SizedBox(
      width: 20,
      height: 40,
      child: Column(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Color(0xFFE26C2C),
              shape: BoxShape.circle,
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                color: const Color(0xFFE26C2C),
              ),
            ),
        ],
      ),
    );
  }
}
