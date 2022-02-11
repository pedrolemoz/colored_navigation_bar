import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../utils/product_data.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  void displayCartSnackBar(BuildContext context, CartController controller) {
    final totalPrice = controller.cart.isEmpty
        ? 0.0
        : controller.cart.length == 1
            ? controller.cart.first.price
            : controller.cart.map((e) => e.price).reduce((a, b) => a += b);

    final snackBar = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'View your cart',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
          Text(
            MoneyMaskedTextController(
              initialValue: totalPrice,
              leftSymbol: 'R\$ ',
            ).text,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
      duration: const Duration(days: 99),
      dismissDirection: DismissDirection.none,
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.fixed,
    );

    if (controller.cart.isNotEmpty) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        ),
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final product = products.elementAt(index);
            final productHasBeenAddedToCart = controller.cart.contains(product);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product.description,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      MoneyMaskedTextController(
                        initialValue: product.price,
                        leftSymbol: 'R\$ ',
                      ).text,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const SizedBox(height: 8),
                    MaterialButton(
                      onPressed: () {
                        if (productHasBeenAddedToCart) {
                          controller.removeProductFromCart(product);
                        } else {
                          controller.addProductToCart(product);
                        }

                        displayCartSnackBar(context, controller);
                      },
                      child: productHasBeenAddedToCart
                          ? Text(
                              'Remove item',
                              style:
                                  Theme.of(context).textTheme.button!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            )
                          : Text(
                              'Add item',
                              style:
                                  Theme.of(context).textTheme.button!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                      color:
                          productHasBeenAddedToCart ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
