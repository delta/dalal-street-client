import 'package:dalal_street_client/components/buttons/tertiary_button.dart';
import 'package:dalal_street_client/proto_build/models/OrderType.pbenum.dart';
import 'package:dalal_street_client/proto_build/models/Stock.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedPage extends StatelessWidget {
  final int orderId;
  final Int64 quantity;
  final OrderType type;
  final Stock stock;

  const OrderPlacedPage(
      {Key? key,
      required this.orderId,
      required this.quantity,
      required this.type,
      required this.stock})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: background2,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset(
                'assets/lottie/green_tick.json',
                width: 250,
                height: 250,
              ),
              const Text(
                'Order Placed Successfully',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stock.shortName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    stock.shortName,
                    style: const TextStyle(
                        color: blurredGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Text(
                'Order Details',
                style: TextStyle(
                    color: bronze, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order Id: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('$orderId',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Qty',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('$quantity',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('${type.value}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TertiaryButton(
                title: 'Done',
                fontSize: 18,
                height: 50,
                width: 150,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
