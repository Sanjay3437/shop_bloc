part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}


class ProductsFetched extends ProductEvent {
  final String? category;

  const ProductsFetched({this.category});

  @override
  List<Object?> get props => [category];
}

// Fetch next page
class ProductsNextPage extends ProductEvent {
  const ProductsNextPage();
}
