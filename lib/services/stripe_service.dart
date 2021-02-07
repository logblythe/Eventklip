import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eventklip/api/client.dart';
import 'package:eventklip/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:stripe_payment/stripe_payment.dart';

@lazySingleton
class StripeService {
  DioClient _dioClient = getIt.get<DioClient>();

  String apiBase = 'https://api.stripe.com/v1';
  String paymentApiUrl = "https://api.stripe.com/v1/payment_intents";
  String secret =
      "sk_test_51IGRslEpxz6XvV1GS5xKBmYoAyi5maUiZJEKPP104EgFxvSIiA0vKIB3BpJZZljtS0KsYF7IAgsB9EyNcfXAxm0t00S625YebW";

  Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await createPaymentIntent(amount, currency);
      var res = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (res.status == "succeeded") {
        return StripeTransactionResponse(
          success: true,
          message: 'Transaction successful',
        );
      } else {
        return StripeTransactionResponse(
          success: true,
          message: 'Transaction failed',
        );
      }
    } catch (e) {
      return StripeTransactionResponse(
        success: false,
        message: 'Transaction failed: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer $secret',
    };
    try {
      var response = await _dioClient.post(
        paymentApiUrl,
        data: body,
        options: Options(
          headers: headers,
          contentType: 'application/x-www-form-urlencoded',
        ),
      );
      return response.data;
    } catch (e) {
      print('error charging user: ${e.toString()}');
    }
    return null;
  }
}

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({this.message, this.success});
}
