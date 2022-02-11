import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/controllers/cart_controller.dart';
import 'app/pages/products_page.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => CartController(),
        child: const AppRoot(),
      ),
    );

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsPage(),
    );
  }
}
