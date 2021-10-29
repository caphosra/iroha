import 'package:flutter/material.dart';

class IrohaWaitingTime extends StatelessWidget {
  final Duration duration;

  IrohaWaitingTime({required this.duration});

  Color _getColor() {
    if (duration.inMinutes < 5) {
      return Colors.blue.shade900;
    } else if (duration.inMinutes < 10) {
      return Colors.purple;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('${duration.inMinutes}分待ち',
        style: TextStyle(color: _getColor(), fontSize: 15));
  }
}
