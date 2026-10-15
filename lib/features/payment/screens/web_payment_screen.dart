import 'dart:convert';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebPaymentScreen extends StatefulWidget {
  final String? token;
  const WebPaymentScreen({super.key, this.token});

  @override
  State<WebPaymentScreen> createState() => _WebPaymentScreenState();
}

class _WebPaymentScreenState extends State<WebPaymentScreen> {

  getValue() async {
    if(html.window.location.href.contains('success') && widget.token != null){
      final orderProvider =  Provider.of<OrderProvider>(context, listen: false);
      String tokenString = utf8.decode(base64Url.decode(widget.token!.replaceAll(' ', '+')));

      // Parse token to get transaction reference and order_id (if present)
      Map<String, String> tokenParams = {};
      for (String param in tokenString.split('&&')) {
        List<String> keyValue = param.split('=');
        if (keyValue.length == 2) {
          tokenParams[keyValue[0]] = keyValue[1];
        }
      }

      String? transactionReference = tokenParams['transaction_reference'];
      String? orderId = tokenParams['order_id'];

      // If order_id is in the token (from M-Pesa success), the order is already confirmed
      // Just navigate to success screen
      if (orderId != null && orderId.isNotEmpty && orderId != 'null') {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
        orderProvider.clearPlaceOrder();
        // Clear pending order ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('pending_order_id');
        Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/$orderId/success');
        return;
      }

      // Fallback: Check for stored pending order ID
      final prefs = await SharedPreferences.getInstance();
      String? pendingOrderId = prefs.getString('pending_order_id');

      if (pendingOrderId != null && pendingOrderId.isNotEmpty) {
        // Order was already created as pending, it should be confirmed by the server
        // Just navigate to success screen
        Provider.of<CartProvider>(context, listen: false).clearCartList();
        orderProvider.clearPlaceOrder();
        await prefs.remove('pending_order_id');
        Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/$pendingOrderId/success');
        return;
      }

      // Legacy flow: If no pending order ID, use the old flow (shouldn't happen with new implementation)
      String placeOrderString = utf8.decode(base64Url.decode(orderProvider.getPlaceOrder()!.replaceAll(' ', '+')));
      String paymentMethod = tokenParams['payment_method'] ?? '';

      PlaceOrderModel placeOrderBody = PlaceOrderModel.fromJson(jsonDecode(placeOrderString)).copyWith(
        paymentMethod: paymentMethod,
        transactionReference: transactionReference,
      );
      orderProvider.placeOrder(placeOrderBody, _callback);

    } else {
      // Handle cancellation or failure
      String status = 'fail';
      if(html.window.location.href.contains('cancel')) {
        status = 'cancel';
      }

      // Cancel the pending order if exists
      final prefs = await SharedPreferences.getInstance();
      String? pendingOrderId = prefs.getString('pending_order_id');
      if (pendingOrderId != null && pendingOrderId.isNotEmpty) {
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        await orderProvider.cancelPendingOrder(orderId: pendingOrderId);
        await prefs.remove('pending_order_id');
      }

      Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/0/$status');
    }
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    Provider.of<CartProvider>(context, listen: false).clearCartList();
    Provider.of<OrderProvider>(context, listen: false).clearPlaceOrder();
    Provider.of<OrderProvider>(context, listen: false).stopLoader();
    // Clear pending order ID
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pending_order_id');
    if(isSuccess) {
      Navigator.pushReplacementNamed(context, '${RouteHelper.orderSuccessful}/$orderID/success');
    }else {
      showCustomSnackBarHelper(message);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getValue();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): null,
      body: Center(
          child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),
    );
  }
}
