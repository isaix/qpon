import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Messaging{
  static final Client client = Client();
  static const String serverKey = 'AAAAgLYJ6Ss:APA91bGVLMjL00l7YzFPJIerp3aVpmiZDnozHIEJ4DEuD-FT0ifTQT_S7MpmZCaOi5PTTuNFNL64quQMbktec5V-mduFJ_pOQCYqfbZ6toMEFfVX_H9RLAvGTrofiwLIy2tg1M2fjMj8';

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}