import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_bloc/features/cart/presentation/bloc/cart_bloc.dart';

import '../../../../core/constants/routes.dart';
import '../../../../shared/config/dimens.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CartBloc, CartState>(
      listenWhen: (_, current) => current.message != null,

      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.message!),
              duration: const Duration(milliseconds: 1500),
            ),
          );
      },

      child: Scaffold(


        appBar: AppBar(title: const Text('Details')),


        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [


              Hero(
                tag: 'product-image-${product.id}',

                child: Container(
                  height: Dimens.productImageHeight,
                  width: double.infinity,

                  color: Colors.white,

                  padding: const EdgeInsets.all(Dimens.spaceL),

                  child: Image.network(
                    product.image,

                    fit: BoxFit.contain,

                    errorBuilder: (_, __, ___) {
                      return const Icon(Icons.broken_image, size: 48);
                    },
                  ),
                ),
              ),

              const SizedBox(height: Dimens.spaceL),

              Chip(label: Text(product.category)),

              const SizedBox(height: Dimens.spaceS),


              Text(
                product.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: Dimens.spaceS),


              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',

                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  const Icon(Icons.star, size: 18, color: Colors.amber),

                  const SizedBox(width: Dimens.spaceXS),

                  Text('${product.rating} (${product.ratingCount})'),
                ],
              ),

              const SizedBox(height: Dimens.spaceL),


              Text(
                'Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: Dimens.spaceXS),

              Text(product.description, style: theme.textTheme.bodyMedium),

              const SizedBox(height: 100),
            ],
          ),
        ),


        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.bottomBarPadding),

            child: Row(
              children: [


                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<CartBloc>().add(CartItemAdded(product));
                    },

                    icon: const Icon(Icons.add_shopping_cart),

                    label: const Text('Add to Cart'),
                  ),
                ),

                const SizedBox(width: 12),


                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      context.read<CartBloc>().add(CartItemAdded(product));

                      context.push(AppRoutes.cart);
                    },

                    icon: const Icon(Icons.shopping_bag),

                    label: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
