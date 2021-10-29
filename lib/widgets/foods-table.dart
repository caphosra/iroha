import 'package:flutter/material.dart';

class IrohaFoodsTable<T> extends StatelessWidget {
  final List<T> data;
  final Widget? Function(BuildContext context, T item) builder;

  IrohaFoodsTable({required this.data, required this.builder, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        Container(margin: EdgeInsets.all(10), height: 2, color: Colors.blue),
        Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text('料理',
                                      style: TextStyle(fontSize: 20))),
                              DataColumn(
                                  label: Text('個数',
                                      style: TextStyle(fontSize: 20)))
                            ],
                            rows: data
                                .map((item) {
                                  final widget = builder(context, item);
                                  if (widget == null) {
                                    return null;
                                  } else {
                                    return DataRow(cells: [
                                      DataCell(Text(item.toString(),
                                          style: TextStyle(fontSize: 20))),
                                      DataCell(widget)
                                    ]);
                                  }
                                })
                                .where((widget) => widget != null)
                                .map((widget) => widget ?? DataRow(cells: []))
                                .toList()))))),
        Container(margin: EdgeInsets.all(10), height: 2, color: Colors.blue)
      ],
    );
  }
}
