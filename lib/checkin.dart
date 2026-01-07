import 'package:checkin/constant/style.dart';
import 'package:checkin/model/checkin_api.dart';
import 'package:checkin/model/model_get_data.dart';
import 'package:checkin/model/model_send_data.dart';
import 'package:checkin/popup/popup_cancel.dart';
import 'package:checkin/popup/popup_remark.dart';
import 'package:flutter/material.dart';

enum CheckinFilter { all, checked, notChecked }

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  late Future<List<CheckinGuest>> future;
  final FocusNode nameFocusNode = FocusNode();

  final TextEditingController nameCtrl = TextEditingController();
  CheckinFilter filter = CheckinFilter.all;

  @override
  void initState() {
    super.initState();
    future = CheckinApi().fetchCheckins();
    nameCtrl.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
  }

  void refresh() {
    setState(() {
      future = CheckinApi().fetchCheckins();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  List<CheckinGuest> _filter(List<CheckinGuest> all) {
    final keyword = nameCtrl.text.trim().toLowerCase();
    return all.where((g) {
      if (keyword.isNotEmpty && !g.name.toLowerCase().contains(keyword)) {
        return false;
      }

      switch (filter) {
        case CheckinFilter.all:
          return true;
        case CheckinFilter.checked:
          return g.isChecked;
        case CheckinFilter.notChecked:
          return !g.isChecked;
      }
    }).toList();
  }

  Color? color1;
  Color? color2;
  Color? colorCheckin = greenCheckin;

  void _handColor({required int numP}) {
    switch (numP) {
      case 0:
        color1 = grey1;
        color2 = grey1;
      case 1:
        color1 = grey2;
        color2 = grey1;
      case 2:
        color1 = grey1;
        color2 = grey2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Danh sách Check-in')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                future = CheckinApi().fetchCheckins(); // reload API
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CheckinGuest>>(
        future: future,
        builder: (context, snapshot) {
          /// ⏳ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        future = CheckinApi().fetchCheckins();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          /// ✅ Data
          final all = snapshot.data ?? [];
          final list = _filter(all);

          return SingleChildScrollView(
            child: Column(
              children: [
                /// FILTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320,
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: nameCtrl,
                        focusNode: nameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Tìm theo tên',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: InkWell(
                            onTap: () {
                              nameCtrl.clear();
                            },
                            child: Icon(Icons.clear),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 220,
                      padding: const EdgeInsets.only(top: 8),
                      child: DropdownButtonFormField<CheckinFilter>(
                        value: filter,
                        decoration: const InputDecoration(
                          labelText: 'Trạng thái',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: CheckinFilter.all,
                            child: Text('Tất cả'),
                          ),
                          DropdownMenuItem(
                            value: CheckinFilter.checked,
                            child: Text('Đã check-in'),
                          ),
                          DropdownMenuItem(
                            value: CheckinFilter.notChecked,
                            child: Text('Chưa check-in'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => filter = v ?? CheckinFilter.all),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// TABLE
                DataTable(
                  columns: const [
                    DataColumn(label: Text('STT')),
                    DataColumn(label: Text('Tên')),
                    DataColumn(label: Text('Số người')),
                    DataColumn(label: Text('Trạng thái')),
                    DataColumn(label: Text('Ghi chú')),
                    // DataColumn(label: Text('Update')),
                  ],
                  rows: list.asMap().entries.map((entry) {
                    final index = entry.key; // 👉 index dòng
                    final p = entry.value; // 👉 CheckinGuest
                    _handColor(numP: p.numP);
                    return DataRow(
                      cells: [
                        DataCell(Text(p.seq.toString())),
                        DataCell(Text(p.name)),
                        DataCell(Text(p.numP.toString())),
                        DataCell(
                          p.isChecked == true
                              ? ElevatedButton(
                                  onPressed: () {
                                    popUp_cancelCheckin(
                                      checkinId: list[index].checkinId,
                                      name: list[index].name,
                                      numP: list[index].numP,
                                      remark: list[index].remark,
                                      refresh: refresh,
                                    );
                                    // sendCheckin(
                                    //   checkinId: list[index].checkinId,
                                    //   isChecked: false,
                                    //   numP: list[index].numP,
                                    //   remark: list[index].remark,
                                    //   refresh: refresh,
                                    // );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      colorCheckin,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Checkin ${p.numP}',
                                    style: style_button,
                                  ),
                                )
                              : Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        sendCheckin(
                                          checkinId: list[index].checkinId,
                                          isChecked: true,
                                          numP: 1,
                                          remark: list[index].remark,
                                          refresh: refresh,
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          color1,
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),

                                      child: Text(
                                        'Checkin 1',
                                        style: style_button,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        sendCheckin(
                                          checkinId: list[index].checkinId,
                                          isChecked: true,
                                          numP: 2,
                                          remark: list[index].remark,
                                          refresh: refresh,
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          color2,
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Checkin 2',
                                        style: style_button,
                                      ),
                                    ),
                                  ],
                                ),
                          // Chip(
                          //   label: Text(
                          //     g.isChecked ? 'Đã check-in' : 'Chưa check-in',
                          //   ),
                          // ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () {
                              popUp_remark(
                                checkinId: list[index].checkinId,
                                name: list[index].name,
                                isChecked: list[index].isChecked,
                                numP: list[index].numP,
                                remark: list[index].remark,
                                refresh: refresh,
                              );
                            },
                            child: Container(
                              width: 150,
                              color: Colors.red,
                              child: Text(p.remark),
                            ),
                          ),
                        ),
                        // DataCell(Text(g.updateTime.toString())),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
