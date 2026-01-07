import 'package:checkin/model/model_get_data.dart';
import 'package:flutter/material.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

enum CheckinFilter { all, checked, notChecked }

class _CheckinPageState extends State<CheckinPage> {
  final TextEditingController nameCtrl = TextEditingController();
  CheckinFilter filter = CheckinFilter.all;

  final List<CheckinGuest> all = [
    CheckinGuest(
      checkinId: '1',
      seq: '1',
      name: 'Anh Đỗ Văn Nhân',
      isChecked: true,
      numP: 1,
      remark: 'test',
      updateTime: DateTime.now(),
    ),
    CheckinGuest(
      checkinId: '2',
      seq: '10',
      name: 'Anh Nguyễn Quốc Khánh',
      isChecked: false,
      numP: 2,
      remark: '',
      updateTime: DateTime.now(),
    ),
  ];

  List<CheckinGuest> get filtered {
    final keyword = nameCtrl.text.toLowerCase().trim();

    return all.where((g) {
      if (keyword.isNotEmpty && !g.name.toLowerCase().contains(keyword)) {
        return false;
      }

      switch (filter) {
        case CheckinFilter.checked:
          return g.isChecked;
        case CheckinFilter.notChecked:
          return !g.isChecked;
        case CheckinFilter.all:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// FILTER
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Tìm theo tên',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<CheckinFilter>(
                    value: filter,
                    onChanged: (v) =>
                        setState(() => filter = v ?? CheckinFilter.all),
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
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// TABLE
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('STT')),
                      DataColumn(label: Text('Tên')),
                      DataColumn(label: Text('Số người')),
                      DataColumn(label: Text('Trạng thái')),
                      DataColumn(label: Text('Cập nhật')),
                    ],
                    rows: filtered.map((g) {
                      return DataRow(
                        cells: [
                          DataCell(Text(g.seq)),
                          DataCell(Text(g.name)),
                          DataCell(Text(g.numP.toString())),
                          DataCell(
                            Chip(
                              label: Text(
                                g.isChecked ? 'Đã check-in' : 'Chưa check-in',
                              ),
                            ),
                          ),
                          DataCell(
                            Text(g.updateTime.toString().substring(0, 19)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
