part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  /// One-off message for BlocListener (snackbar). Set on each change.
  final String? message;

  const CartState({this.items = const [], this.message});

  /// Total units in the cart (drives the badge).
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice => items.fold(0, (sum, i) => sum + i.totalPrice);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items, message];
}