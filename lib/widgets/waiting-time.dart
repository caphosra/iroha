import 'package:flutter/material.dart';

///
/// 待ち時間を表示するUI
///
class IrohaWaitingTime extends StatelessWidget {
  ///
  /// 待ち時間
  ///
  final Duration duration;

  ///
  /// 待ち時間を表示するUI
  ///
  IrohaWaitingTime({required this.duration});

  ///
  /// 待ち時間に基づいて色を決定します。
  ///
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
