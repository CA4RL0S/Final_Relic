import 'dart:convert';
import 'package:http/http.dart' as http;

class MercadoPagoService {
  // IMPORTANTE: Reemplaza esto con tu Access Token de Mercado Pago
  // Obtén tu token en: https://www.mercadopago.com.mx/developers/panel/credentials
  static const String _accessToken =
      'APP_USR-7629240760826719-111310-4b83cc47a8b8538a9abf2a70bd6eabb0-2986636659';

  // URL base de la API de Mercado Pago
  static const String _baseUrl = 'https://api.mercadopago.com';

  // Crear una preferencia de pago
  Future<Map<String, dynamic>?> createPaymentPreference({
    required String title,
    required double amount,
    required String itemId,
    required int quantity,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/checkout/preferences');

      final body = {
        'items': [
          {
            'title': title,
            'quantity': quantity,
            'currency_id': 'MXN', // Pesos mexicanos
            'unit_price': amount,
            'id': itemId,
          }
        ],
        'back_urls': {
          'success': 'darknessdungeon://payment/success',
          'failure': 'darknessdungeon://payment/failure',
          'pending': 'darknessdungeon://payment/pending',
        },
        'auto_return': 'approved',
        'statement_descriptor': 'Final Relic',
        'external_reference': itemId,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Error creating payment preference: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating payment preference: $e');
      return null;
    }
  }

  // Verificar el estado de un pago
  Future<Map<String, dynamic>?> getPaymentStatus(String paymentId) async {
    try {
      final url = Uri.parse('$_baseUrl/v1/payments/$paymentId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error getting payment status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception getting payment status: $e');
      return null;
    }
  }

  // Procesar el resultado del pago
  Future<bool> processPaymentResult(Map<String, dynamic> paymentData) async {
    try {
      final status = paymentData['status'];

      // Estados posibles: approved, pending, in_process, rejected, cancelled
      if (status == 'approved') {
        return true;
      }

      return false;
    } catch (e) {
      print('Exception processing payment result: $e');
      return false;
    }
  }

  // Método de prueba para simular compra (solo para desarrollo)
  Future<bool> simulatePurchase({
    required String itemId,
    required double amount,
  }) async {
    // Simula un delay de red
    await Future.delayed(Duration(seconds: 2));

    // En desarrollo, siempre retorna true
    // En producción, esto debe ser reemplazado por el flujo real de Mercado Pago
    print('MODO PRUEBA: Simulando compra de $itemId por \$$amount MXN');
    return true;
  }
}
