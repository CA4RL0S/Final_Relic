import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PayPalService {
  // IMPORTANTE: Reemplaza estos valores con tus credenciales de PayPal
  // Obtén tus credenciales en: https://developer.paypal.com/dashboard/

  // Para SANDBOX (Pruebas):
  static const String _clientIdSandbox =
      'AfcNty12tYxkx5q9X5pPaWIY2D7qnE64E8V6u73wn4XuWYW7cba-IbgZrArifcA-fHGYZ4jF7cwb-ovO';
  static const String _secretKeySandbox =
      'EAhIgcCut31G5O6x7G_K3cxaNCQU7iMHUfHi518J8n-93S3riQxqxhNGyffm2v8c_K7mcba2rwY9QIoq';

  // Para PRODUCCIÓN (Pagos reales):
  static const String _clientIdProduction = 'TU_CLIENT_ID_PRODUCTION_AQUI';
  static const String _secretKeyProduction = 'TU_SECRET_KEY_PRODUCTION_AQUI';

  // Cambiar a true cuando vayas a producción
  static const bool isProduction = false;

  static String get clientId =>
      isProduction ? _clientIdProduction : _clientIdSandbox;
  static String get secretKey =>
      isProduction ? _secretKeyProduction : _secretKeySandbox;

  // Procesar pago con PayPal
  static void processPayment({
    required BuildContext context,
    required String itemName,
    required double amount,
    required String itemId,
    required Function() onSuccess,
    required Function(String error) onError,
    required Function() onCancel,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: !isProduction,
          clientId: clientId,
          secretKey: secretKey,
          transactions: [
            {
              "amount": {
                "total": amount.toStringAsFixed(2),
                "currency": "USD", // PayPal usa USD principalmente
                "details": {
                  "subtotal": amount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": itemName,
              "item_list": {
                "items": [
                  {
                    "name": itemName,
                    "quantity": 1,
                    "price": amount.toStringAsFixed(2),
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "Compra en Final Relic",
          onSuccess: (Map params) async {
            print("PayPal: Pago exitoso");
            print("Payment ID: ${params['paymentId']}");
            print("Payer ID: ${params['payerID']}");
            onSuccess();
          },
          onError: (error) {
            print("PayPal: Error - $error");
            onError(error.toString());
          },
          onCancel: () {
            print('PayPal: Pago cancelado');
            onCancel();
          },
        ),
      ),
    );
  }

  // Método de simulación para pruebas rápidas (sin PayPal)
  static Future<bool> simulatePurchase({
    required String itemId,
    required double amount,
  }) async {
    // Simula un delay de red
    await Future.delayed(Duration(seconds: 2));

    print('MODO SIMULACIÓN: Comprando $itemId por \$$amount USD');
    return true;
  }

  // Convertir de MXN a USD (tasa aproximada)
  static double convertMxnToUsd(double mxn) {
    // Tasa aproximada: 1 USD = 17 MXN
    // Ajusta según la tasa actual
    return mxn / 17.0;
  }
}
