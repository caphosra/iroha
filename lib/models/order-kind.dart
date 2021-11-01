///
/// メニューの種類
///
/// 'eat in'と'take out'というエセ英単語については突っ込んではいけない。
///
enum IrohaOrderKind { EAT_IN, TAKE_OUT }

///
/// `IrohaOrderKind`の拡張
///
extension IrohaOrderKindEx on IrohaOrderKind {
  ///
  /// 文字列に変換します。
  ///
  /// 'eat in'と'take out'というエセ英単語については突っ込んではいけない。
  ///
  /// ```dart
  /// IrohaOrderKind.EAT_IN.get(); // 'eat-in'
  /// IrohaOrderKind.TAKE_OUT.get(); // 'take-out'
  /// ```
  ///
  String get() {
    switch (this) {
      case IrohaOrderKind.EAT_IN:
        return 'eat-in';
      case IrohaOrderKind.TAKE_OUT:
        return 'take-out';
    }
  }

  ///
  /// 日本語の文字列に変換します。
  ///
  /// 'イートイン'と'テイクアウト'というエセ英単語については突っ込んではいけない。
  ///
  /// ```dart
  /// IrohaOrderKind.EAT_IN.getJapaneseName(); // 'イートイン'
  /// IrohaOrderKind.TAKE_OUT.getJapaneseName(); // 'テイクアウト'
  /// ```
  ///
  String getJapaneseName() {
    switch (this) {
      case IrohaOrderKind.EAT_IN:
        return 'イートイン';
      case IrohaOrderKind.TAKE_OUT:
        return 'テイクアウト';
    }
  }
}
