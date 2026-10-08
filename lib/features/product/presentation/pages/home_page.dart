import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes.dart';
import '../../../../shared/config/dimens.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';

import 'package:shop_bloc/features/cart/presentation/widgets/cart_badge_button.dart';
import 'package:shop_bloc/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();


  final List<String> categories = const [
    'All',
    'beauty',
    'fragrances',
    'furniture',
    'groceries',
    'laptops',
    'mens-shirts',
    'mens-shoes',
    'mens-watches',
    'mobile-accessories',
    'motorcycle',
    'skin-care',
    'smartphones',
    'sports-accessories',
    'sunglasses',
    'tablets',
    'tops',
    'vehicle',
    'womens-bags',
    'womens-dresses',
    'womens-jewellery',
    'womens-shoes',
    'womens-watches',
  ];

  @override
  void initState() {
    super.initState();


    _scrollController.addListener(_onScroll);
  }



  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // Load next page when close to bottom
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ProductBloc>().add(const ProductsNextPage());
    }
  }



  void _selectCategory(String category) {
    context.read<ProductBloc>().add(
      ProductsFetched(category: category == 'All' ? null : category),
    );
  }



  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          const CartBadgeButton(),

          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),

      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          // Selected category
          String? selectedCategory;

          if (state is ProductLoaded) {
            selectedCategory = state.selectedCategory;
          }

          return Column(
            children: [


              SizedBox(
                height: Dimens.categoryBarHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceM, vertical: Dimens.spaceS
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    final bool isSelected = category == 'All'
                        ? selectedCategory == null
                        : selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: Dimens.spaceS),
                      child: ChoiceChip(
                        label: Text(
                          category == 'All' ? 'All' : _formatCategory(category),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          _selectCategory(category);
                        },
                      ),
                    );
                  },
                ),
              ),


              Expanded(
                child: switch (state) {


                  ProductInitial() || ProductLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),


                  ProductError(:final message) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(message, textAlign: TextAlign.center),

                        const SizedBox(height: 12),

                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              ProductsFetched(category: selectedCategory),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),


                  ProductLoaded(:final products, :final isLoadingMore) =>
                    GridView.builder(
                      controller: _scrollController,

                      padding: const EdgeInsets.all(Dimens.spaceM),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Dimens.productGridColumns,
                            childAspectRatio: Dimens.productCardAspectRatio,
                            crossAxisSpacing: Dimens.productGridSpacing,
                            mainAxisSpacing: Dimens.productGridSpacing,
                          ),

                      itemCount: products.length + (isLoadingMore ? 1 : 0),

                      itemBuilder: (context, index) {
                        // Bottom loading indicator
                        if (index == products.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final product = products[index];

                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.push(AppRoutes.productDetail, extra: product);
                          },
                        );
                      },
                    ),
                },
              ),
            ],
          );
        },
      ),
    );
  }



  String _formatCategory(String category) {
    return category
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
