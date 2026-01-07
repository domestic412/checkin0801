import 'dart:ui';

import 'package:checkin/constant/style.dart';
import 'package:checkin/model/model_send_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> popUp_remark({
  required String checkinId,
  required String name,
  required bool isChecked,
  required int numP,
  required String remark,
  required VoidCallback refresh,
}) {
  TextEditingController rmCtrl = TextEditingController();
  rmCtrl.text = remark;

  Color? color1;
  Color? color2;
  Color? colorCancel = Colors.red;

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
  print('popup');
  return Get.defaultDialog(
    title: 'Information',
    titleStyle: TextStyle(fontSize: 28, color: Colors.deepPurple),
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Họ và tên: ', style: style_text_popup),
              Text(name, style: TextStyle(fontSize: 18, color: Colors.red)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ghi chú: ', style: style_text_popup),
              Container(
                width: 320,
                child: TextField(
                  controller: rmCtrl,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          isChecked == true
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      sendCheckin(
                        checkinId: checkinId,
                        isChecked: false,
                        numP: numP,
                        remark: rmCtrl.text,
                        refresh: refresh,
                      );
                      Get.back();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(colorCancel),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text('Cancel Checkin $numP', style: style_button),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        sendCheckin(
                          checkinId: checkinId,
                          isChecked: true,
                          numP: 1,
                          remark: rmCtrl.text,
                          refresh: refresh,
                        );
                        Get.back();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(color1),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text('Checkin 1', style: style_button),
                      ),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        sendCheckin(
                          checkinId: checkinId,
                          isChecked: true,
                          numP: 2,
                          remark: rmCtrl.text,
                          refresh: refresh,
                        );
                        Get.back();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(color2),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text('Checkin 2', style: style_button),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          sendCheckin(
            checkinId: checkinId,
            isChecked: isChecked,
            numP: numP,
            remark: rmCtrl.text,
            refresh: refresh,
          );
          Get.back();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            const Color.fromARGB(255, 7, 0, 102),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Text('SAVE', style: style_button),
      ),
    ],
  );
}
