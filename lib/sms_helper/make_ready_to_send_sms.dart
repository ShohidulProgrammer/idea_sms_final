import 'package:flutter/material.dart';
import '../db/model/sms_queue_model.dart';
import '../db/utils/db_helper.dart';
import '../http_helper/get_web_data.dart';
import 'my_sms_sender.dart';

DatabaseHelper dbHelper = DatabaseHelper.db;
SmsQueueModel smsQueue;

makeReadyToSendSms(
    {@required BuildContext context, @required String url}) async {
  var webDataList;

  try {
    //  get data from web url
    webDataList = await getDataFromWeb(url: url);
  } catch (e) {
    print('\nnetwork error: $e');
  }

  // insert queue from web url
  try {
    for (int i = 0; i < webDataList.length; i++) {
      await dbHelper.saveQItem(SmsQueueModel(
          id: webDataList[i]['id'],
          mobileNo: webDataList[i]['mobileNo'],
          userName: webDataList[i]['userName'],
          message: webDataList[i]['massage']));
    }
  } catch (e) {
    print('\nsmsQue insertion error: $e');
  }

  // send sms from queue table
  try {
    // get all data from queue table
    final List<SmsQueueModel> smsQueues = await dbHelper.getAllQueues();
    // send sms each mobile no
    smsQueues.forEach((que) {
      MySmsSender.sendSms(que: que);
    });

//    sendSmsFromQueue(context);
  } catch (e) {
    print('\nqueue data read error: $e');
  }
}
