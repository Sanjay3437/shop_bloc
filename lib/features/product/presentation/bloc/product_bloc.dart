import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_bloc/features/product/domain/entities/product.dart';

import '../../domain/use_case/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;


  static const int pageSize = 10;


  int currentPage = 1;


  String? currentCategory;

  ProductBloc({required this.getProducts}) : super(const ProductInitial()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductsNextPage>(_onProductsNextPage);
  }



  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<ProductState> emit,
  ) async {

    currentPage = 1;


    currentCategory = event.category;


    emit(const ProductLoading());


    final result = await getProducts(
      ProductParams(
        page: currentPage,
        limit: pageSize,
        category: currentCategory,
      ),
    );

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (products) {
        emit(
          ProductLoaded(
            products,
            isLoadingMore: false,
            hasReachedMax: products.length < pageSize,
            selectedCategory: currentCategory,
          ),
        );
      },
    );
  }



  Future<void> _onProductsNextPage(
    ProductsNextPage event,
    Emitter<ProductState> emit,
  ) async {

    if (state is! ProductLoaded) {
      return;
    }

    final currentState = state as ProductLoaded;


    if (currentState.isLoadingMore) {
      return;
    }


    if (currentState.hasReachedMax) {
      return;
    }


    emit(
      ProductLoaded(
        currentState.products,
        isLoadingMore: true,
        hasReachedMax: currentState.hasReachedMax,
        selectedCategory: currentCategory,
      ),
    );


    final nextPage = currentPage + 1;


    final result = await getProducts(
      ProductParams(page: nextPage, limit: pageSize, category: currentCategory),
    );

    result.fold(
      (failure) {

        emit(
          ProductLoaded(
            currentState.products,
            isLoadingMore: false,
            hasReachedMax: currentState.hasReachedMax,
            selectedCategory: currentCategory,
          ),
        );
      },
      (newProducts) {

        currentPage = nextPage;


        final allProducts = [...currentState.products, ...newProducts];

        emit(
          ProductLoaded(
            allProducts,
            isLoadingMore: false,
            hasReachedMax: newProducts.length < pageSize,
            selectedCategory: currentCategory,
          ),
        );
      },
    );
  }
}
