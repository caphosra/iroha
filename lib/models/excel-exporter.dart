import 'package:excel/excel.dart';
import 'package:iroha/models/menu-items.dart';
import 'package:iroha/models/order-kind.dart';
import 'package:iroha/models/order.dart';

///
/// サーバー上のデータをExcelファイルとして出力するもの
///
/// 詳しくは[excel (package)](https://pub.dev/packages/excel)を参照すること。
///
class ExcelExporter {
  ///
  /// Excelファイルを表現しているアイテム
  ///
  late Excel _excel;

  ///
  /// サーバー上のデータをExcelファイルとして出力するもの
  ///
  /// 詳しくは[excel (package)](https://pub.dev/packages/excel)を参照すること。
  ///
  ExcelExporter() {
    _excel = Excel.createExcel();
  }

  ///
  /// メニューのデータをExcelファイルに書き込みます。
  ///
  /// 具体的には'メニュー'という名前のシートに書き込まれます。
  ///
  void generateMenuItemsPage() {
    final sheet = _excel['メニュー'];

    sheet.cell(CellIndex.indexByString('A1')).value = 'メニュー名';
    sheet.cell(CellIndex.indexByString('B1')).value = '価格';
    sheet.cell(CellIndex.indexByString('C1')).value = 'イートイン';
    sheet.cell(CellIndex.indexByString('D1')).value = 'テイクアウト';

    var rowNumber = 1;

    for (final kind in IrohaOrderKind.values) {
      for (final menu in MenuItems.getMenu(kind).items) {
        final nameCell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowNumber));
        nameCell.value = menu.name;

        final priceCell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowNumber));
        priceCell.value = menu.price;

        final kindCell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: kind.index + 2, rowIndex: rowNumber));
        kindCell.value = 'Yes';

        rowNumber++;
      }
    }
  }

  ///
  /// 注文のデータをExcelファイルに書き込みます。
  ///
  void generateOrdersPage(IrohaOrderKind kind, List<IrohaOrder> orders) {
    final sheet = _excel[kind.getJapaneseName()];

    sheet.cell(CellIndex.indexByString('A1')).value = 'テーブル番号';
    sheet.cell(CellIndex.indexByString('B1')).value = '投稿時刻';
    sheet.cell(CellIndex.indexByString('C1')).value = '調理時刻';
    sheet.cell(CellIndex.indexByString('D1')).value = '提供時刻';
    sheet.cell(CellIndex.indexByString('E1')).value = '支払時刻';

    var columnNumber = 5;
    for (final menu in MenuItems.getMenu(kind).items) {
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: columnNumber, rowIndex: 0))
          .value = menu.name;

      columnNumber++;
    }

    var rowNumber = 1;
    for (final order in orders) {
      final tableNumberCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowNumber));
      tableNumberCell.value = order.tableNumber;

      final postedCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowNumber));
      postedCell.value = _dateTimeToString(order.posted);

      final cookedCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowNumber));
      cookedCell.value = _dateTimeToString(order.cooked);

      final servedCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowNumber));
      servedCell.value = _dateTimeToString(order.served);

      final paidCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowNumber));
      paidCell.value = _dateTimeToString(order.paid);

      var columnNumber = 5;
      for (final menu in MenuItems.getMenu(kind).items) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: columnNumber, rowIndex: rowNumber))
            .value = order.foods[menu.name];

        columnNumber++;
      }

      rowNumber++;
    }
  }

  ///
  /// 時間を`yyyy/mm/dd hh:mm`という書式の文字列に変換します。
  ///
  String _dateTimeToString(DateTime? time) {
    if (time == null) {
      return '';
    } else {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '${time.year}/${time.month}/${time.day} $hour:$minute';
    }
  }

  ///
  /// Excelファイルの名前を取得します。
  ///
  String _getFileName() {
    var date = _dateTimeToString(DateTime.now());
    date = date.replaceAll(RegExp(r'[/\s:]'), '-');
    return '売上情報-$date.xlsx';
  }

  ///
  /// Excelファイルを保存します。
  ///
  /// 環境によって保存する方法が変わるので、
  /// 詳しくは[excel (package)](https://pub.dev/packages/excel)を参照すること。
  ///
  void save() {
    _excel.delete('Sheet1');
    _excel.save(fileName: _getFileName());
  }
}
