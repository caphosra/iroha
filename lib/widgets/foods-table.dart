import 'package:flutter/material.dart';

class IrohaFoodsTable<T> extends StatelessWidget {
  final List<T> data;
  final Widget? Function(BuildContext context, T item) builder;
  final Color color;

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
        Container(margin: EdgeInsets.all(5), height: 2, color: color),
        Center(
            child: Container(
                width: 300,
                margin: EdgeInsets.all(10),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        //child: SingleChildScrollView(
                        // scrollDirection: Axis.horizontal,
                        child: Center(
                            child: Column(
                                children: data
                                    .map((item) {
                                      final widget = builder(context, item);
                                      if (widget == null) {
                                        return null;
                                      } else {
                                        return Container(
                                            margin: EdgeInsets.all(5),
                                            child: Row(children: [
                                              Container(
                                                width: 180,
                                                child: Text(item.toString(),
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ),
                                              Container(
                                                  width: 40,
                                                  child: Center(child: widget))
                                            ]));
                                      }
                                    })
                                    .where((widget) => widget != null)
                                    .map((widget) => widget ?? Container())
                                    .toList())))))),
        Container(margin: EdgeInsets.all(5), height: 2, color: color)
      ],
    );
  }
}
