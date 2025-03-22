import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class paymentscreen extends StatefulWidget {
  const paymentscreen({super.key});

  @override
  State<paymentscreen> createState() => _paymentscreenState();
}

class _paymentscreenState extends State<paymentscreen> {
  void _openRazorpayCheckout() {
    // Check if Razorpay is available
    if (!js.context.hasProperty('Razorpay')) {
      print("Error: Razorpay SDK not loaded. Check web/index.html.");
      return;
    }

    // Minimal payment options
    final options = {
      "key": "rzp_test_1DP5mmOlF5G5ag", // Replace with your actual Test Key
      "amount": '0', // 1 INR (minimum amount for testing)
      "currency": "INR",
      "name": "Razorpay Flutter Sample",
      "description": "Test Transaction",
      "handler": js.allowInterop((response) {
        print("Payment Success: $response");
      }),
      "prefill": {
        "email": "test@example.com",
        "contact": "7395837797",
      },
      "notes": {
        "order_id": "order_12345", // Optional: Add a unique order ID
      },
      "modal": {
        "ondismiss": js.allowInterop(() {
          print("Payment cancelled by user");
        }),
      },
    };

    try {
      final razorpay = js.JsObject(js.context['Razorpay'], [js.JsObject.jsify(options)]);
      razorpay.callMethod('open');
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Razorpay Flutter Sample App")),
      body: Center(
        child: ElevatedButton(
          onPressed: _openRazorpayCheckout,
          child: const Text("Pay Now"),
        ),
      ),
    );
  }
}
