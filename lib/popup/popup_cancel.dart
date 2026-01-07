import 'dart:ui';

import 'package:checkin/constant/style.dart';
import 'package:checkin/model/model_send_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> popUp_cancelCheckin({
  required String checkinId,
  required String name,
  required int numP,
  required String remark,
  required VoidCallback refresh,
}) {
  Color colorCancel = Colors.red;
  return Get.defaultDialog(
    title: 'Checkin',
    titleStyle: TextStyle(fontSize: 28, color: Colors.grey[700]),
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              name,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                sendCheckin(
                  checkinId: checkinId,
                  isChecked: false,
                  numP: numP,
                  remark: remark,
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
          ),
        ],
      ),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Text('Back', style: style_button),
      ),
    ],
  );
}
