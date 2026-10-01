import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/features/product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == event.product.id);

    if (index == -1) {
      items.add(CartItem(product: event.product));
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }

    emit(CartState(items: items, message: 'Added to cart'));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final items =
    state.items.where((i) => i.product.id != event.productId).toList();

    if (items.length == state.items.length) return; // nothing to remove

    emit(CartState(items: items, message: 'Removed from cart'));
  }

  void _onCleared(CartCleared event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}