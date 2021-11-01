import 'package:flutter/material.dart';

///
/// メニューと個数の表を表示するUI
///
class IrohaFoodsTable<T> extends StatelessWidget {
  ///
  /// 表の元となるデータ
  ///
  final List<T> data;

  ///
  /// 表の元となるデータから表の1列を生成する処理
  ///
  final Widget? Function(BuildContext context, T item) builder;

  ///
  /// 枠組みの色
  ///
  final Color color;

  ///
  /// メニューと個数の表を表示するUI
  ///
  IrohaFoodsTable(
      {required this.data,
      required this.builder,
      this.color = Colors.blue,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        Container(margin: const EdgeInsets.all(5), height: 2, color: color),
        Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                    minWidth: 300),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: [
                              const DataColumn(
                                  label: Text('料理',
                                      style: TextStyle(fontSize: 15))),
                              const DataColumn(
                                  label: Text('個数',
                                      style: TextStyle(fontSize: 15)))
                            ],
                            rows: data
                                .map((item) {
                                  final widget = builder(context, item);
                                  if (widget == null) {
                                    return null;
                                  } else {
                                    return DataRow(cells: [
                                      DataCell(
                                        Container(
                                          width: 150,
                                          child: Text(item.toString(),
                                              style: TextStyle(fontSize: 15)),
                                        ),
                                      ),
                                      DataCell(
                                          Container(width: 50, child: widget))
                                    ]);
                                  }
                                })
                                .where((widget) => widget != null)
                                .map((widget) => widget ?? DataRow(cells: []))
                                .toList()))))),
        Container(margin: const EdgeInsets.all(5), height: 2, color: color)
      ],
    );
  }
}
