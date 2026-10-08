import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/config/dimens.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(title: const Text('Cart')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return ListView.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = state.items[i];
                return ListTile(
                  leading: SizedBox(
                    width: 56,
                    child: Image.network(
                      item.product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context
                            .read<CartBloc>()
                            .add(CartItemRemoved(item.product.id)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.isEmpty) return const SizedBox.shrink();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.spaceL),
                child: Row(
                  children: [
                    Text(
                      'Total (${state.itemCount} items)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      '\$${state.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
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