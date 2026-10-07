part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}


class ProductInitial extends ProductState {
  const ProductInitial();
}


class ProductLoading extends ProductState {
  const ProductLoading();
}
class ProductLoaded extends ProductState {
  final List<Product> products;

  final bool isLoadingMore;

  final bool hasReachedMax;


  final String? selectedCategory;

  const ProductLoaded(
    this.products, {
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [
    products,
    isLoadingMore,
    hasReachedMax,
    selectedCategory,
  ];
}


class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
