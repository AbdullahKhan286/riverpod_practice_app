import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivepod_training/models/product.dart';
import 'package:rivepod_training/providers/cart_provider.dart';
import 'package:rivepod_training/providers/products_provider.dart';
import 'package:rivepod_training/shared/cart_icon.dart';

// home_screen.dart

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.read(productsProvider);
    log('allProducts: $allProducts');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Sale Products'),
        actions: const [CartIcon()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: allProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return ProductItem(product: allProducts[index]);
          },
        ),
      ),
    );
  }
}

// product_item.dart

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.blueGrey.withOpacity(0.05),
      child: Column(
        children: [
          Image.asset(product.image, width: 60, height: 60),
          Text(product.title),
          Text('£${product.price}'),
          Consumer(
            builder: (context, ref, child) {
              final cartProducts = ref.watch(cartNotifierProvider);
              if (cartProducts.contains(product)) {
                return TextButton(
                  onPressed: () {
                    ref
                        .read(cartNotifierProvider.notifier)
                        .removeProduct(product);
                  },
                  child: const Text('Remove'),
                );
              } else {
                return TextButton(
                  onPressed: () {
                    ref.read(cartNotifierProvider.notifier).addProduct(product);
                  },
                  child: const Text('Add to Cart'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
