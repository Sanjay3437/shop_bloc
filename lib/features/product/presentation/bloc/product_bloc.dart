import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/core/utils/use_case.dart';
import '../../domain/entities/product.dart';
import '../../domain/use_case/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;

  ProductBloc({required this.getProducts}) : super(const ProductInitial()) {
    on<ProductsFetched>(_onProductsFetched);
  }

  Future<void> _onProductsFetched(
      ProductsFetched event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    final result = await getProducts(const NoParams());

    result.fold(
          (failure) => emit(ProductError(failure.message)),
          (products) => emit(ProductLoaded(products)),
    );
  }
}